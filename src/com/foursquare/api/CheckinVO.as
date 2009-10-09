package com.foursquare.api{
	public class CheckinVO{
		public var id:int;
		public var user:UserVO;
		public var venue:VenueVO;
		public var display:String;
		public var shout:String;
		public var created:String;
		public function CheckinVO(remote:Object){
			this.id = remote.id;
			this.user = new UserVO(remote.user);
			this.venue = new VenueVO(remote.venue);
			this.display = remote.display;
			this.shout = remote.shout;
			this.created = remote.created;
		}
	}
}