////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 21, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views.history
{
	import flash.utils.Dictionary;
	
	import mx.formatters.DateFormatter;
	
	import spark.components.SkinnableContainer;
	import spark.layouts.VerticalLayout;
	
	
	/**
	 * takes a historyDictionary and creates a list of SingleDay items 
	 * @author seth
	 * 
	 */	
	public class HistoryView extends SkinnableContainer
	{
		
		private var _history:Dictionary;
		private var historyChanged:Boolean;
		
		public function HistoryView()
		{
			super();
			this.layout = new VerticalLayout();
			this.layout.clipAndEnableScrolling = true;
		}
		
		override protected function commitProperties() : void{
			super.commitProperties();
			
			if( historyChanged ){
				historyChanged = false;
				createHistory();
			}
		}
		
		/**
		 * creates history items 
		 * 
		 */		
		private function createHistory():void{
			
			var dateFormatter:DateFormatter = new DateFormatter();
			
			for(var time:String in _history){
				//create new day
				var historyItem:SingleDay = new SingleDay();
				historyItem.date = time;
				historyItem.checkins = _history[time];

				var date:Date = new Date( dateFormatter.format(time) );
				historyItem.time = date.time;
				
				//since history is NOT returned sorted
				//we need to sort each day by date
				addElementAt( historyItem, findIndex(historyItem) );
			}
		}
		
		/**
		 * helper to sort day by date. 
		 * @param item
		 * @return 
		 * 
		 */		
		private function findIndex(item:SingleDay):int{
			var index:int;
			
			if(numElements==0){
				index = 0;
			}else{
				for(var i:int=0; i<numElements; i++){
					if( item.time > (getElementAt(i) as SingleDay).time){
						index = i;
						break;
					}
					index = numElements;
				}
			}
			
			return index;
		}
		
		public function get history():Dictionary
		{
			return _history;
		}
		
		public function set history(value:Dictionary):void
		{
			_history = value;
			historyChanged = true;
			invalidateProperties();
		}
	}
}