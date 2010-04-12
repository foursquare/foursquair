////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 30, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.models.Constants;
	import com.foursquare.models.vo.CheckinVO;
	import com.foursquare.services.IFoursquareService;
	import com.foursquare.views.CheckinMediator;
	import com.foursquare.views.MainViewMediator;
	import com.foursquare.views.SettingsMediator;
	
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
				case CheckinEvent.CHANGE_POLL_INTERVAL:
					checkinMediator.pollInterval = (event as CheckinEvent).interval;
					break;
				case CheckinEvent.TOGGLE_GROWL_MESSAGING:
					mainViewMediator.showGrowl =  (event as CheckinEvent).useGrowl;
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
			
			if( !checkinMediator.firstRead && mainViewMediator.showGrowl){
				var newCheckins:ArrayCollection = findNewCheckins( checkins );
				for each(var checkin:CheckinVO in newCheckins){
					mainViewMediator.growl( checkin );
				}
			}

			checkinMediator.checkins = checkins;
				
		}
		
		/**
		 * checks for new checkins since last timerEvent...
		 * @param currentCheckin
		 * @param newCheckin
		 * @return 
		 * 
		 */		
		private function findNewCheckins(checkins:ArrayCollection):ArrayCollection{
			
			var timeFromLastPoll:Number = new Date().time - checkinMediator.pollInterval;
			var newCheckins:ArrayCollection = new ArrayCollection();
			
			for each(var checkin:CheckinVO in checkins){
				if( checkin.created.time > timeFromLastPoll){
					newCheckins.addItem( checkin );
				}else{
					break;
				}
			}
			return newCheckins;			
		}
		
		private function startPolling():void{
			checkinMediator.startPolling();
		}

		private function stopPolling():void{
			checkinMediator.stopPolling();
		}
		
		private function handleShout( message:String ):void{
			mainViewMediator.handleShout( message );
			getCheckins();
		}

	}
}