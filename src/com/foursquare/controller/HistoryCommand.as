////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 21, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.api.IFoursquareService;
	import com.foursquare.events.HistoryEvent;
	
	import org.robotlegs.mvcs.Command;
	
	public class HistoryCommand extends Command
	{

		[Inject]
		public var event:HistoryEvent;
		
		[Inject]
		public var foursquareService:IFoursquareService;
		
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
					onReturn_getHistory( event.history );
					break;
			}
		}
		
		private function getHistory():void{
			foursquareService.getHistory(
		}
	}
}