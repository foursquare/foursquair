package com.foursquare.api
{
	import com.foursquare.events.LoginEvent;
	import com.foursquare.models.vo.VenueVO;
	import com.foursquare.models.vo.UserVO;

	public interface IFoursquareService_old
	{
		function login(event:LoginEvent):void;
		function checkin(shout : String="", venueVO:VenueVO=null):void;
		//function checkin(vid:int, venue:String='', shout:String='', onSuccess:Function=null, onError:Function=null):void;
		function getCheckins(onSuccess:Function, onError:Function=null):void;
		function getHistory(limit:int, onSuccess:Function, onError:Function=null):void;
		function getUserDetails(userVO:UserVO, badges:Boolean=false, mayor:Boolean=false):void;
		function getVenues(geolat:Number, geolong:Number, r:Number=25, l:int=10, q:String=null, onSuccess:Function=null, onError:Function=null):void;
		function listCities(onSuccess:Function, onError:Function=null):void;
	}
}