////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 21, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views.history
{
	import mx.collections.ArrayCollection;
	
	import spark.components.SkinnableContainer;
	
	public class HistoryViewBase extends SkinnableContainer
	{
		
		private var _history:ArrayCollection;
		private var historyChanged:Boolean;
		
		public function HistoryViewBase()
		{
			super();
		}
		
		override protected function commitProperties() : void{
			super.commitProperties();
			
			if( historyChanged ){
				historyChanged = true;
				createHistory();
			}
		}
		
		private function createHistory():void{
			//addElement(historyItems);
		}
		
		[Bindable]
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