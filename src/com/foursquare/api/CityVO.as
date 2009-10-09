package com.foursquare.api{
	public class CityVO{
	   public var id:int;
	   public var timezone:String;
	   public var name:String;
	   public var geolat:Number;
	   public var geolong:Number;
	   
	   public function CityVO(remote:Object){
	       this.id = remote.id;
	       this.timezone = remote.timezone;
	       this.name = remote.timezone;
	       this.geolat = remote.geolat;
	       this.geolong = remote.geolong;
	   }
	}
}