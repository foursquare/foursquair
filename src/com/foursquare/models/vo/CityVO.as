package com.foursquare.models.vo{
	public class CityVO{
	   public var id:int;
	   public var timezone:String;
	   public var name:String;
	   public var geolat:Number;
	   public var geolong:Number;
	   
	   public function CityVO(remote:Object){
		   if(remote){
		       this.id = remote.id;
		       this.timezone = remote.timezone;
		       this.name = remote.timezone;
		       this.geolat = remote.geolat;
		       this.geolong = remote.geolong;
		   }
	   }
	}
}