////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Lucas Hrabovsky, Seth Hillinger
// Created: Nov 16, 2009 
////////////////////////////////////////////////////////////

package com.foursquare.views.checkins
{
	
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.models.vo.CheckinVO;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.SkinnableContainer;
	
	public class CheckinViewBase extends SkinnableContainer
	{
		
		private var _checkins:ArrayCollection;
		private var checkinsChanged:Boolean;
		
		public function CheckinViewBase()
		{
			super();
		}
		
		override protected function commitProperties() : void{
			super.commitProperties();
			
			if( checkinsChanged ){
				checkinsChanged = true;
				
				removeAllElements();
				
				for each(var checkin:CheckinVO in _checkins){
					var checkinItem:CheckinItem = new CheckinItem();
					checkinItem.data = checkin;
					addElement( checkinItem );
				}
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