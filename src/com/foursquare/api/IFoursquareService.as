package com.foursquare.api
{
	import com.foursquare.events.LoginEvent;

	public interface IFoursquareService
	{
		function login(event:LoginEvent):void;
		function checkin(shout : String="", venueVO:VenueVO=null):void;
		function getCheckins():void;
		function getHistory(limit:int):void;
		function getUserDetails(userVO:UserVO, badges:Boolean=false, mayor:Boolean=false):void;
		function getVenues(geolat:Number, geolong:Number, r:Number=25, l:int=10, q:String=null):void;
		function listCities():void;	
	}
}