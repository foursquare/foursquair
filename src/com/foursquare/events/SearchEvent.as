////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Mar 7, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class SearchEvent extends Event
	{
		public static const GET_USER_LOCATION:String = "getUserLocation";
		public static const USER_LOCATION_RETURNED:String = "userLocationReturned";
		
		public static const QUERY:String = "query";
		public static const QUERY_RETURNED:String = "queryReturned";
		
		public var keyword:String;
		public var results:ArrayCollection;
		
		public function SearchEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone() : Event{
			var searchEvent:SearchEvent = new SearchEvent(type);
			searchEvent.keyword = keyword;
			return searchEvent;
		}
	}
}