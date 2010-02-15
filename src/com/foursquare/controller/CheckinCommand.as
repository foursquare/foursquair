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
				case CheckinEvent.SHOUT:
					createCheckin( event ); 
					break;
				case CheckinEvent.READ:
					getCheckins();
					break;
			}
		}
		
		private function createCheckin( event : CheckinEvent ):void{
			if(!event.venueVO)
			{
				foursquareService.checkin( 0, "", event.message, onCheckinSuccess );
			}else{
				foursquareService.checkin( event.venueVO.id, event.venueVO.name, event.message, onCheckinSuccess );
			}
		}
		
		private function getCheckins():void{
			foursquareService.getCheckins( handleCheckins );
		}
		
		private function handleCheckins( checkins: ArrayCollection ):void{
			checkinMediator.setCheckins( checkins );
		}
		
		private function onCheckinSuccess( success:Boolean ):void{
			getCheckins();
		}
	}
}