////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 21, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
	import com.foursquare.events.HistoryEvent;
	import com.foursquare.views.history.HistoryView;
	
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.Mediator;
	
	
	public class HistoryMediator extends Mediator
	{

		[Inject]
		public var historyView:HistoryView;
		
		public function HistoryMediator()
		{
			super();
		}
		
		override public function onRegister() : void{
			getHistory( new HistoryEvent( HistoryEvent.READ ) );			
		}
		
		override public function onRemove() : void{
			super.onRemove();
		}
		
		public function setHistory( history: Dictionary ):void{
			historyView.history = history;
		}
		
		private function getHistory(event:HistoryEvent):void{
			eventDispatcher.dispatchEvent( event.clone() );
		}
	}
}