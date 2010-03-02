////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 21, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views.history
{
	import flash.utils.Dictionary;
	
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
				historyChanged = true;
				createHistory();
			}
		}
		
		/**
		 * creates history items 
		 * 
		 */		
		private function createHistory():void{
			
			//TODO Seth: sort history by date first.
			
			for(var time:String in _history){
				var historyItem:SingleDay = new SingleDay();
				historyItem.date = time;
				historyItem.checkins = _history[time];
				addElement( historyItem );
			}
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