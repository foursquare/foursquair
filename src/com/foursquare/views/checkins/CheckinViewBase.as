////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Lucas Hrabovsky, Seth Hillinger
// Created: Nov 16, 2009 
////////////////////////////////////////////////////////////

package com.foursquare.views.checkins
{
	
	import com.foursquare.events.CheckinEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.components.List;
	import spark.components.SkinnableContainer;
	
	public class CheckinViewBase extends SkinnableContainer
	{
		
		public var checkinList:List;
		
		private var _checkins:ArrayCollection;
		private var checkinsChanged:Boolean;
		
		public function CheckinViewBase()
		{
			super();
			addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:FlexEvent):void{
		}
		
		override protected function commitProperties() : void{
			super.commitProperties();
			
			if( checkinsChanged ){
				checkinsChanged = true;
				checkinList.dataProvider = _checkins;
			}
		}

		public function getCheckins():void{
			var checkinEvent:CheckinEvent = new CheckinEvent( CheckinEvent.READ );
			dispatchEvent( checkinEvent );
		}
		
		[Bindable]
		public function get checkins():ArrayCollection
		{
			return _checkins;
		}

		public function set checkins(value:ArrayCollection):void
		{
			_checkins = value;
			checkinsChanged = true;
			invalidateProperties();
		}

	}
}