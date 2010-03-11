////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 7, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.events.UserEvent;
	import com.foursquare.models.LibraryModel;
	import com.foursquare.services.IFoursquareService;
	
	import org.robotlegs.mvcs.Command;
	
	public class UserCommand extends Command
	{
		
		[Inject]
		public var event:UserEvent;
		
		[Inject]
		public var foursquareService:IFoursquareService;

		[Inject]
		public var libraryModel:LibraryModel;
		
		public function UserCommand()
		{
			super();
		}
		
		override public function execute() : void{
			switch(event.type){
				case UserEvent.GET_DETAILS:
					foursquareService.getUserDetails( event.userVO );
					break;
				case UserEvent.DETAILS_GOT:
					libraryModel.currentUser = event.userVO;
					break;
			}
		}
	}
}