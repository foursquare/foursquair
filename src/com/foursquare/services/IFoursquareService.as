package com.foursquare.services
{
	import com.foursquare.events.LoginEvent;
	import com.foursquare.models.vo.VenueVO;
	import com.foursquare.models.vo.UserVO;

	public interface IFoursquareService
	{
		function login(event:LoginEvent):void;
		function checkin(shout : String="", venueVO:VenueVO=null):void;
		function getCheckins():void;
		function getHistory(limit:int):void;
		function getMyDetails(userVO:UserVO):void;
		function getUserDetails(userVO:UserVO, badges:Boolean=false, mayor:Boolean=false):void;
		function getVenues(geolat:Number, geolong:Number, r:Number=25, l:int=10, q:String=null):void;
		function listCities():void;	
	}
}