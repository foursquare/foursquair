////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Lucas Hrabovsky, Seth Hillinger
// Created: Nov 16, 2009 
////////////////////////////////////////////////////////////

package com.foursquare.views.history
{
	import com.foursquare.util.TimeAgoInWords;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Text;
	
	public class HistoryBase extends Canvas
	{
		public var timeAgo:Text;
		private var t:Timer;
		
		private var _history:ArrayCollection;
		
		public function HistoryBase()
		{
			super();
		}
		
		private function creationComplete():void{
			if(t==null && data!=null){
				t = new Timer(60000);
				t.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void{
					timeAgo.text = TimeAgoInWords.format(data.created)+' ago';
				});
				t.start();
			}
		}

		public function get history():ArrayCollection
		{
			return _history;
		}

		[Bindable]
		public function set history(value:ArrayCollection):void
		{
			_history = value;
		}

	}
}