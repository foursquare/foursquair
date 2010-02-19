////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 30, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.events
{
	import com.foursquare.api.VenueVO;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class CheckinEvent extends Event
	{
		
		public static const SHOUT:String = "shout";
		public static const SHOUT_SUCCESS:String = "shoutSuccess";
		
		public static const READ:String = "read";
		public static const READ_RETURNED:String = "readReturned";
		
		
		public var userId:int;
		public var message:String;
		
		public var venueVO:VenueVO;
		public var checkins:ArrayCollection;
		
		public function CheckinEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone() : Event{
			var checkinEvent:CheckinEvent = new CheckinEvent(type);
			checkinEvent.userId = userId;
			checkinEvent.message = message;
			checkinEvent.venueVO = venueVO;
			checkinEvent.checkins = checkins;
			return checkinEvent;
		}
	}
}