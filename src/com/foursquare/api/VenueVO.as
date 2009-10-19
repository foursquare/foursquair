package com.foursquare.api{
	public class VenueVO{
		[Bindable] public var id:int;
		[Bindable] public var name:String;
		[Bindable] public var address:String;
		[Bindable] public var crossstreet:String;
		[Bindable] public var geolat:Number;
		[Bindable] public var geolong:Number;
		
		public function VenueVO(remote:Object){
			this.id = remote.id;
			this.name = remote.name;
			this.address = remote.address;
			this.crossstreet = remote.crossstreet;
			this.geolat = Number(remote.geolat);
			this.geolong = Number(remote.geolong);
		}
	}
}
