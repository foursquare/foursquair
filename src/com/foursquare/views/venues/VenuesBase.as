////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Lucas Hrabovsky, Seth Hillinger
// Created: Nov 16, 2009 
////////////////////////////////////////////////////////////

package com.foursquare.views.venues
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	public class VenuesBase extends Canvas
	{
		
		public var venueSearchSubmit:Button;
		public var venueSearchText:TextInput;
		public var venuesTitle:Label;
		
		private var _venues:ArrayCollection;
		
		public function VenuesBase()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:FlexEvent):void{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			venueSearchSubmit.addEventListener(MouseEvent.CLICK, onVenueSearchClick);
		}
		
		private function onVenueSearchClick(event:MouseEvent):void{
			var venueEvent:VenueEvent = new VenueEvent(VenueEvent.SEARCH);
			venueEvent.searchText = venueSearchText.text;
			dispatchEvent(venueEvent);
		}

		public function get venues():ArrayCollection
		{
			return _venues;
		}

		[Bindable]
		public function set venues(value:ArrayCollection):void
		{
			_venues = value;
		}

	}
}