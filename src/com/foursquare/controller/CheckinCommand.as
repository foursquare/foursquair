////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 30, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.services.IFoursquareService;
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.views.CheckinMediator;
	import com.foursquare.views.MainViewMediator;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;

	public class CheckinCommand extends Command
	{
		[Inject]
		public var event:CheckinEvent;
		
		[Inject]
		public var foursquareService:IFoursquareService;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
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
				case CheckinEvent.READ_RETURNED:
					handleCheckins( event.checkins );
					break;
				case CheckinEvent.SHOUT_SUCCESS:
					handleShout(event.message);
					break;
			}
		}
		
		private function createCheckin( event : CheckinEvent ):void{
			if(!event.venueVO)
			{
				foursquareService.checkin( event.message );
			}else{
				foursquareService.checkin( event.message, event.venueVO );
			}
		}
		
		private function getCheckins():void{
			foursquareService.getCheckins();
		}
		
		private function handleCheckins( checkins: ArrayCollection ):void{
			checkinMediator.setCheckins( checkins );
		}
		
		private function handleShout( message:String ):void{
			mainViewMediator.handleShout( message );
			getCheckins();
		}

		private function onCheckinSuccess( success:Boolean ):void{
			getCheckins();
		}
	}
}