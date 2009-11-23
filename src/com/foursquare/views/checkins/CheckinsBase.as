////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Lucas Hrabovsky, Seth Hillinger
// Created: Nov 16, 2009 
////////////////////////////////////////////////////////////

package com.foursquare.views.checkins
{
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	
	public class CheckinsBase extends Canvas
	{
		
		private var _checkins:ArrayCollection;
		
		public function CheckinsBase()
		{
			super();
		}

		[Bindable]
		public function get checkins():ArrayCollection
		{
			return _checkins;
		}

		public function set checkins(value:ArrayCollection):void
		{
			_checkins = value;
		}

	}
}