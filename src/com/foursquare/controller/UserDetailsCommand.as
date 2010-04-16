////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: April 16, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.events.UserEvent;
	import com.foursquare.models.LibraryModel;
	import com.foursquare.services.IFoursquareService;
	import com.foursquare.views.CheckinMediator;
	
	import org.robotlegs.mvcs.Command;
	
	public class UserDetailsCommand extends Command
	{
		
		[Inject]
		public var event:UserEvent;
		
		[Inject]
		public var foursquareService:IFoursquareService;
		
		[Inject]
		public var libraryModel:LibraryModel;
		
		[Inject]
		public var checkinMediator:CheckinMediator;
		
		public function UserDetailsCommand()
		{
			super();
		}
		
		override public function execute() : void{
			switch(event.type){
				case UserEvent.GET_DETAILS:
					foursquareService.getUserDetails( event.userVO );
					break;
				case UserEvent.DETAILS_GOT:
					checkinMediator.setUserDetails( event.userVO );
					break;
			}
		}
	}
}