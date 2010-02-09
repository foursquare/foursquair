////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Nov 18, 2009 
////////////////////////////////////////////////////////////

package com.foursquare.views.venues
{
	import flash.events.Event;
	
	public class VenueEvent extends Event
	{
		public static const SEARCH:String = "search";
		public static const SHOUT:String = "shout";

		public var searchText:String;
		public var shoutText:String;
		
		public function VenueEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}