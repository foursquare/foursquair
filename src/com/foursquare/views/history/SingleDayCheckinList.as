////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 28, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views.history
{
	import com.foursquare.models.vo.CheckinVO;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.VGroup;
	
	public class SingleDayCheckinList extends VGroup
	{
		public function SingleDayCheckinList()
		{
			super();
		}
		
		private var _dataProvider:ArrayCollection;
		private var dataChanged:Boolean;

		override protected function commitProperties() : void{
			super.commitProperties();
			
			if(dataChanged){
				dataChanged = false;
				createList();
			}
		}
		
		private function createList():void{
			for each(var checkin:CheckinVO in _dataProvider){
				var historyItem:SingleDayListItem = new SingleDayListItem();
				historyItem.checkin = checkin;
				addElement( historyItem );
			}
		}
		
		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}

		public function set dataProvider(value:ArrayCollection):void
		{
			_dataProvider = value;
			dataChanged = true;
			invalidateProperties();
		}

	}
}