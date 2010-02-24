////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 21, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views.history
{
	import com.foursquare.api.CheckinVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.SkinnableContainer;
	
	public class HistoryViewBase extends SkinnableContainer
	{
		
		private var _history:ArrayCollection;
		private var historyChanged:Boolean;
		
		//stores dates
		// key:Date=month+day+year
		// value:Array of CheckinVOs on that date
		private var dateDictionary:Dictionary;
		
		public function HistoryViewBase()
		{
			super();
		}
		
		override protected function commitProperties() : void{
			super.commitProperties();
			
			if( historyChanged ){
				historyChanged = true;
				createHistoryBuckets();
				createHistory();
			}
		}
		
		/**
		 * sorts the history by date 
		 */		
		private function createHistoryBuckets():void{
			dateDictionary = new Dictionary();

			//bucket checkins by date
			var i:int=0;
			while(i < _history.length){
				var date:Date = (_history[i] as CheckinVO).created;
				
				//create key
				var dateKey:String = new Date(date.fullYear,date.month, date.date).time.toString();
				
				//if dictionary key doesn't exist, create new arraycollection
				if(!dateDictionary[dateKey]) dateDictionary[dateKey] = new ArrayCollection();
				
				//add checkinVO to dictionary.
				(dateDictionary[dateKey] as ArrayCollection).addItem( _history[i]);
				
				i++;
			}
		}
		
		/**
		 * creates history items 
		 * 
		 */		
		private function createHistory():void{
			for(var time:String in dateDictionary){
				var historyItem:HistoryItem = new HistoryItem();
				historyItem.date = new Date(Number(time));
				historyItem.checkins = dateDictionary[time];
				addElement( historyItem );
			}
		}
		
		public function get history():ArrayCollection
		{
			return _history;
		}
		
		public function set history(value:ArrayCollection):void
		{
			_history = value;
			historyChanged = true;
			invalidateProperties();
		}
	}
}