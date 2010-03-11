package com.foursquare.models.vo{
	[Bindable]
	public class VenueVO{
		public var id:int;
		public var name:String;
		public var address:String;
		public var crossstreet:String;
		public var geolat:Number;
		public var geolong:Number;
		public var stats:StatsVO;
		
		public function VenueVO(remote:Object=null){
			if(remote){
				this.id = remote.id;
				this.name = remote.name;
				this.address = remote.address;
				this.crossstreet = remote.crossstreet;
				this.geolat = Number(remote.geolat);
				this.geolong = Number(remote.geolong);
				this.stats = (remote.stats) ? new StatsVO(remote.stats) : null;
				
			}
		}
	}
}
