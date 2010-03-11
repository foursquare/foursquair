////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 21, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.events
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class HistoryEvent extends Event
	{
		
		public static const READ:String = "read";
		public static const READ_RETURNED:String = "readReturned";
		
		//dictionary of CheckinVOs keyed by date
		public var history:Dictionary;
		
		public function HistoryEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone() : Event{
			return new HistoryEvent(type);
		}
	}
}