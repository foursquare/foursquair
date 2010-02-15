package com.foursquare.api
{
	import com.foursquare.events.ErrorEvent;
	import com.foursquare.events.LoginEvent;
	import com.foursquare.events.UserEvent;
	import com.foursquare.models.LibraryModel;
	import com.foursquare.util.XMLUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.collections.ArrayCollection;
	
	import org.flaircode.oauth.*;
	import org.iotashan.oauth.*;
	import org.robotlegs.mvcs.Actor;

	public class FoursquareService extends Actor implements IFoursquareService
	{


		[Inject]
		public var model:LibraryModel;
		
		private var consumerKey : String = '266d5934f6cb223fcd5ffc75eeb0a99404acf504c';
		private var consumerSecret : String = '6265da6ce9bd8cb2c69632ae51836327';

		private var oauth : IOAuth;

		//TODO (seth) move these into a Model
		private var actor : UserVO;

		public function FoursquareService()
		{
			oauth = new OAuth(consumerKey, consumerSecret);
		}

		/**
		 * LOGIN 
		 * @param username
		 * @param password
		 * 
		 */		
		public function login( loginEvent:LoginEvent ) : void
		{
			var request : URLRequest = oauth.buildRequest(	URLRequestMethod.POST,
															'http://api.foursquare.com/v1/authexchange',
															null, 
															{fs_username: loginEvent.username, fs_password: loginEvent.password});
			request.method = URLRequestMethod.POST;


			var loader : URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e : IOErrorEvent) : void
				{
					var error : Error = new Error("Incorrect username/password or couldnt talk to foursquare :(");
					handleError(error);
				});
			
			loader.addEventListener(Event.COMPLETE, function(e : Event) : void
				{
					var loader : URLLoader = e.target as URLLoader;
					try
					{
						//set token info.
						var xml : XML = new XML(loader.data);
						model.oauth_token = xml.descendants('oauth_token').toString();
						model.oauth_token_secret = xml.descendants('oauth_token_secret').toString();
						
						//dispatch event
						var successEvent:LoginEvent = new LoginEvent( LoginEvent.LOGIN_SUCCESS );
						successEvent.rememberMe = loginEvent.rememberMe;
						dispatch(successEvent);
					}
					catch (e : Error)
					{
						var error : Error = e;
						handleError(error);
					}
				});
			loader.load(request);
		}

		/**
		 * vid - (optional, not necessary if you are 'shouting' or have a venue name). ID of the venue where you want to check-in.
		 * venue - (optional, not necessary if you are 'shouting' or have a vid) if you don't have a venue ID, pass the venue name as a string using this parameter. foursquare will attempt to match it on the server-side
		 * shout - (optional) a message about your check-in
		 * private - (optional, defaults to the user's setting). "1" means "don't show your friends". "0" means "show everyone"
		 * twitter - (optional, default to the user's setting). "1" means "send to twitter". "0" means "don't send to twitter"
		 * geolat - (optional, but recommended)
		 * geolong - (optional, but recommended)
		 */
		public function checkin(vid : int, venue : String='', shout : String='', onSuccess : Function=null, onError : Function=null) : void
		{
			var params : Object = new Object();
			if (vid > 0)
			{
				params.vid = vid;
			}
			if (venue.length > 1)
			{
				params.venue = venue;
			}
			if (shout.length > 1)
			{
				params.shout = shout;
			}
			getData('http://api.foursquare.com/v1/checkin.xml', function(d : Object) : void
				{
					var c : Object = d.checkin;
					d.user = actor;
					d.shout = shout;
					d.created = new Date();
					onSuccess(new CheckinVO(d));
				}, true, params);
		}

		/**
		 * TODO: convert to a service that has a proper handler and uses E4X convert to an Obj.
		 * 
		 * GET CHECKINS 
		 * @param onSuccess
		 * @param onError
		 * 
		 */		
		public function getCheckins(onSuccess : Function, onError : Function=null) : void
		{
			getData('http://api.foursquare.com/v1/checkins.xml', function(d : Object) : void
				{
					var o : ArrayCollection = new ArrayCollection();
					
					if(d.checkins){
						if (d.checkins.checkin is ArrayCollection)
						{
							var checkins : ArrayCollection = d.checkins.checkin as ArrayCollection;
							for (var i : int = 0; i < d.checkins.checkin.length; i++)
							{
								var c : Object = checkins.getItemAt(i);
								o.addItem( new CheckinVO(c) );
							}
						}
						else
						{
							o.addItem( new CheckinVO(d.checkins.checkin) );
						}
					}

					onSuccess(o);
				}, true);
		}

		/**
		 * GET HISTORY 
		 * @param limit
		 * @param onSuccess
		 * @param onError
		 * 
		 */		
		public function getHistory(limit : int, onSuccess : Function, onError : Function=null) : void
		{
			getData('http://api.foursquare.com/v1/history.xml', function(d : Object) : void
				{
					var o : Array = new Array();
					var checkins : Array = d.checkins.checkin.source as Array;
					checkins.forEach(function(el : Object, index : int, arr : Array) : void
						{
							el.user = actor;
							o.push(new CheckinVO(el));
						});
					onSuccess(o);
				}, true, {l: limit});
		}

		/**
		 * GET USER DETAILS 
		 * @param uid
		 * @param onSuccess
		 * @param onError
		 * @param badges
		 * @param mayor
		 * 
		 */		
		public function getUserDetails(userVO : UserVO, badges : Boolean=false, mayor : Boolean=false) : void
		{
			var params : Object = new Object();

			//following login, userId is passed as 0.
			if (userVO && userVO.id > 1) params.uid = userVO.id;
			params.badges = (badges) ? 1 : 0;
			params.mayor = (mayor) ? 1 : 0;

			getData('http://api.foursquare.com/v1/user.xml', function(d : Object) : void
				{
					//dispatch event
					var userEvent:UserEvent = new UserEvent( UserEvent.DETAILS_GOT );
					userEvent.userVO = new UserVO(d.user);
					dispatch( userEvent );		
				}, true, params);
		}

		/**
		 * GET VENUES
		 * geolat - latitude (required)
		 * geolong - longitude (required)
		 * r - radius in miles (optional)
		 * l - limit of results (optional, default 10)
		 * q - keyword search (optional)
		 */
		public function getVenues(geolat : Number, geolong : Number, r : Number=25, l : int=10, q : String=null, onSuccess : Function=null, onError : Function=null) : void
		{
			var params : Object = new Object();
			params.geolat = geolat;
			params.geolong = geolong;
			params.r = r;
			params.l = l;

			if (q != null)
			{
				params.q = q;
			}
			getData('http://api.foursquare.com/v1/venues.xml', function(d : Object) : void
				{
					var o : Array = new Array();

					var v : ArrayCollection = new ArrayCollection();
					if (d.venues == null)
					{
						v = new ArrayCollection();
					}
					//TODO: d.venues.group.source[0].venue was breaking. 
					//temp fix - removed source
					else if (d.venues.group is ArrayCollection)
					{
						v.addItem(d.venues.group[0].venue);
					}
					else if (d.venues.group.venue is ArrayCollection)
					{
						v = d.venues.group.venue as ArrayCollection;
					}
					else
					{
						v = new ArrayCollection([d.venues.group.venue]);
					}


					if (v.source.length > 0)
					{
						v.source.forEach(function(el : Object, index : int, arr : Array) : void
							{
								o.push(new VenueVO(el));
							});
					}

					onSuccess(o);
				}, true, params);
		}

		public function listCities(onSuccess : Function, onError : Function=null) : void
		{
			getData('http://api.foursquare.com/v1/cities.xml', function(data : Object) : void
				{
					var c : Array = data.cities as Array;
					c.map(function(el : Object) : void
						{
							new CityVO(el);
						});
					onSuccess(c);
				});
		}

		private function getData(url : String, onSuccess : Function, authRequired : Boolean=false, requestParams : Object=null) : void
		{
			var request : URLRequest;
			if (!authRequired)
			{
				request = new URLRequest(url);
				if (requestParams != null)
				{
					request.data = requestParams as URLVariables;
				}
			}
			else
			{
				request = oauth.buildRequest(	URLRequestMethod.GET, url, 
												new OAuthToken(model.oauth_token, model.oauth_token_secret),
												requestParams);
			}
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e : IOErrorEvent) : void
				{
					trace(request.url);
					var error : Error = new Error("Couldnt parse XML.  Incorrect username/password or couldnt talk to foursquare :(");
					handleError(error);
				});
			loader.addEventListener(Event.COMPLETE, function(e : Event) : void
				{
					var loader : URLLoader = e.target as URLLoader;
					trace('-- Got XML from ' + request.url);
					trace(loader.data + "\n");
					try
					{
						var parsed : Object = com.foursquare.util.XMLUtil.XMLToObject(loader.data);
					}
					catch (e : Error)
					{
						e.message = e.message + "\n\nStack:\n" + e.getStackTrace(), 'XML Parse Error :(';
						handleError( e );
					}
					onSuccess(parsed);
				});
			loader.load(request);
		}

		private function handleError(error : Error) : void
		{
			var errorEvent:ErrorEvent = new ErrorEvent( ErrorEvent.ERROR);
			errorEvent.error = error;
			dispatch(errorEvent);
		}
	}
}
