////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 30, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.events
{
	import com.foursquare.api.VenueVO;
	
	import flash.events.Event;
	
	public class CheckinEvent extends Event
	{
		
		public static const SHOUT:String = "shout";
		public static const READ:String = "read";
		
		public var userId:int;
		public var message:String;
		
		public var venueVO:VenueVO;
		
		public function CheckinEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone() : Event{
			var checkinEvent:CheckinEvent = new CheckinEvent(type);
			checkinEvent.userId = userId;
			checkinEvent.message = message;
			checkinEvent.venueVO = venueVO;
			return checkinEvent;
		}
	}
}