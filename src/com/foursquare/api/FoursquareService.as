////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 18, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.api
{
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.ErrorEvent;
	import com.foursquare.events.HistoryEvent;
	import com.foursquare.events.LoginEvent;
	import com.foursquare.models.LibraryModel;
	import com.foursquare.util.XMLUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import mx.collections.ArrayCollection;
	
	import org.flaircode.oauth.IOAuth;
	import org.flaircode.oauth.OAuth;
	import org.iotashan.oauth.OAuthToken;
	import org.robotlegs.mvcs.Actor;

	public class FoursquareService extends Actor implements IFoursquareService
	{
		
		[Inject]
		public var model:LibraryModel;
		
		private var _url : String = "http://api.foursquare.com/v1/";
		
		private var consumerKey : String = '266d5934f6cb223fcd5ffc75eeb0a99404acf504c';
		private var consumerSecret : String = '6265da6ce9bd8cb2c69632ae51836327';
		
		private var oauth : IOAuth;
		
		//TODO (seth) move these into a Model
		private var actor : UserVO;
		
		public function FoursquareService()
		{
			oauth = new OAuth(consumerKey, consumerSecret);
		}
		
		public function login(event:LoginEvent):void
		{
			var request : URLRequest = oauth.buildRequest(	URLRequestMethod.POST, _url+'authexchange',null, 
				{fs_username: event.username, fs_password: event.password});
			
			var loader : URLLoader = new URLLoader();
			model.rememberMe = event.rememberMe;
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoginError);
			loader.addEventListener(Event.COMPLETE, onLoginSuccess);
			loader.load(request);
		}
		
		/**
		 * checkin 
		 * @param shout
		 * @param venueVO
		 * 
		 */		
		public function checkin(shout:String="", venueVO:VenueVO=null):void
		{
			var params:Object = new Object();
			if (venueVO){
				if( venueVO.id ) params.vid = venueVO.id;
				if (venueVO.name.length > 1) params.venue = venueVO.name;
			}
			
			if (shout.length > 1) params.shout = shout;
			
			var request : URLRequest = oauth.buildRequest(
				URLRequestMethod.POST,
				_url+"checkin.xml",
				model.oauth_token,
				params);
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(Event.COMPLETE, onSuccess_checkin);
			loader.load(request);
		}
		
		/**
		 * Get Checkins 
		 */		
		public function getCheckins():void
		{
			var request : URLRequest = oauth.buildRequest(
				URLRequestMethod.GET, 
				_url+'checkins.xml',
				model.oauth_token);
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(Event.COMPLETE, onResult_getCheckins);
			loader.load(request);
		}
		
		public function getHistory(limit:int):void
		{
			var request : URLRequest = oauth.buildRequest(
				URLRequestMethod.GET, 
				_url+'history.xml',
				model.oauth_token,
				{l:limit});
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(Event.COMPLETE, onResult_getHistory);
			loader.load(request);
		}
		
		public function getUserDetails(userVO:UserVO, badges:Boolean=false, mayor:Boolean=false):void
		{
		}
		
		public function getVenues(geolat:Number, geolong:Number, r:Number=25, l:int=10, q:String=null):void
		{
		}
		
		public function listCities():void
		{
		}
		
		//*****************************************
		// HANDLERS
		//*****************************************	
		
		private function onLoginSuccess(event:Event):void{
			var loader : URLLoader = event.target as URLLoader;
			try
			{
				//set token info.
				var xml : XML = new XML(loader.data);
				
				var oauthToken:OAuthToken = new OAuthToken(
												xml.descendants('oauth_token').toString(),
												xml.descendants('oauth_token_secret').toString()
											);
				
				model.oauth_token = oauthToken;
				
				//dispatch event
				var successEvent:LoginEvent = new LoginEvent( LoginEvent.LOGIN_SUCCESS );
				successEvent.rememberMe = model.rememberMe;
				dispatch(successEvent);
			}
			catch (e : Error)
			{
				var error : Error = e;
				handleError(error);
			}
		}
		
		private function onLoginError(event:IOErrorEvent):void{
			var error : Error = new Error("Incorrect username/password or couldnt talk to foursquare");
			handleError(error);
		}
		
		/**
		 * process results of getCheckins 
		 * @param event
		 * 
		 */		
		private function onResult_getCheckins(event : Event):void{
			var checkins:Array = new Array();
			var xml:XML = new XML((event.target as URLLoader).data);
			
			//loop through xml and create VOs
			for each( var checkin : XML in xml..checkin){
				checkins.push( new CheckinVO( XMLUtil.XMLToObject( checkin.children() )) );
			}
			
			//dispatch event
			var checkinEvent:CheckinEvent = new CheckinEvent(CheckinEvent.READ_RETURNED);
			checkinEvent.checkins = new ArrayCollection( checkins );
			dispatch( checkinEvent );
		}
		
		private function onResult_getHistory(event : Event):void{
			var history:Array = new Array();
			var xml:XML = new XML((event.target as URLLoader).data);
			
			//loop through xml and create VOs
			for each( var checkin : XML in xml..checkin){
				history.push( new CheckinVO( XMLUtil.XMLToObject( checkin.children() )) );
			}
			
			//dispatch event
			var historyEvent:HistoryEvent = new HistoryEvent(HistoryEvent.READ_RETURNED);
			historyEvent.history = new ArrayCollection( history );
			dispatch( historyEvent );
		}
		
		/**
		 * returned from adding a checkin 
		 * @param event
		 * 
		 */		
		private function onSuccess_checkin(event:Event):void{
			var xml:XML = new XML((event.target as URLLoader).data);
			var checkinEvent:CheckinEvent = new CheckinEvent( CheckinEvent.SHOUT_SUCCESS );
			checkinEvent.message = xml..message;
			dispatch( checkinEvent );
		}
		
		private function onIOError(event:IOErrorEvent):void{
			var error : Error = new Error( (event.target as URLLoader).data, event.errorID );
			handleError(error);
		}
		
		private function handleError(error : Error) : void
		{
			var errorEvent:ErrorEvent = new ErrorEvent( ErrorEvent.ERROR);
			errorEvent.error = error;
			dispatch(errorEvent);
		}
		
	}
}