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

		public var searchText:String;
		
		public function VenueEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}