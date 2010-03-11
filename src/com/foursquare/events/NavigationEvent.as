////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 31, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.events
{
	import flash.events.Event;
	
	public class NavigationEvent extends Event
	{
		
		public static const CHANGE:String = "change";
		
		public var section:String;
		
		public function NavigationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone() : Event
		{
			var navigationEvent:NavigationEvent = new NavigationEvent(this.type);
			navigationEvent.section = section;
			
			return navigationEvent;
		}
	}
}