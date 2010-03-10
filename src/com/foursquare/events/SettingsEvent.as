////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Mar 10, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.events
{
	import flash.events.Event;
	
	public class SettingsEvent extends Event
	{
		
		public static const CHANGE_POLL_TIME:String = "changePollTime";
		
		public var pollTime:int;
		
		public function SettingsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}