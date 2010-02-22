////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 21, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.api.IFoursquareService;
	import com.foursquare.events.HistoryEvent;
	import com.foursquare.models.Constants;
	import com.foursquare.views.HistoryMediator;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;
	
	public class HistoryCommand extends Command
	{

		[Inject]
		public var event:HistoryEvent;
		
		[Inject]
		public var foursquareService:IFoursquareService;
		
		[Inject]
		public var historyMediator:HistoryMediator;
		
		public function HistoryCommand()
		{
			super();
		}
		
		override public function execute():void{
			switch(event.type){
				case HistoryEvent.READ:
					getHistory();
					break;
				case HistoryEvent.READ_RETURNED:
					historyReturned( event.history );
					break;
			}
		}
		
		private function getHistory():void{
			foursquareService.getHistory( Constants.historyLimit );
		}
		
		private function historyReturned( value:ArrayCollection ):void{
			historyMediator.setHistory( value );
		}
	}
}