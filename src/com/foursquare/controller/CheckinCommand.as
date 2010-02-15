////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 30, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.api.IFoursquareService;
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.views.CheckinMediator;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;

	public class CheckinCommand extends Command
	{
		[Inject]
		public var event:CheckinEvent;
		
		[Inject]
		public var foursquareService:IFoursquareService;
		
		[Inject]
		public var checkinMediator:CheckinMediator;

		public function CheckinCommand()
		{
			super();
		}
		
		override public function execute():void{
			switch(event.type){
				case CheckinEvent.CREATE:
					//foursquareService.checkin( 
					break;
				case CheckinEvent.READ:
					foursquareService.getCheckins( handleCheckins );
					break;
			}
		}
		
		private function handleCheckins( checkins: ArrayCollection ):void{
			checkinMediator.setCheckins( checkins );
		}
	}
}