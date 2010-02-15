////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 15, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.events
{
	import flash.events.Event;
	
	public class ErrorEvent extends Event
	{
		public static const ERROR:String = "error";
		
		public var error:Error;
		
		public function ErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone() : Event
		{
			var errorEvent:ErrorEvent = new ErrorEvent(this.type);
			errorEvent.error = error;
			return errorEvent;
		}
	}
}