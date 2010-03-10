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
				historyChanged = true;
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
				var historyItem:SingleDay = new SingleDay();
				historyItem.date = time;
				historyItem.checkins = _history[time];

				var date:Date = new Date( dateFormatter.format(time) );
				historyItem.time = date.getTime();
				
				if(numElements==0){
					addElement( historyItem );
				}else{
					for(var i:int=0; i<numElements; i++){
						if( historyItem.time > (getElementAt(i) as SingleDay).time){
							addElementAt( historyItem, i );
							break;
						}
						addElement( historyItem );
					}
				}
				
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