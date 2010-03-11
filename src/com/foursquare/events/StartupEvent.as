////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 23, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.events
{
	import flash.events.Event;
	
	public class StartupEvent extends Event
	{
		
		public static const STARTUP:String = "startup";
		public static const CHECK_NEW_VERSION:String = "checkNewVersion";
		
		public function StartupEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}