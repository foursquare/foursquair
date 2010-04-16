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
	import com.foursquare.views.CheckinMediator;
	
	import org.robotlegs.mvcs.Command;
	
	public class MyDetailsCommand extends Command
	{
		
		[Inject]
		public var event:UserEvent;
		
		[Inject]
		public var foursquareService:IFoursquareService;

		[Inject]
		public var libraryModel:LibraryModel;
		
		public function MyDetailsCommand()
		{
			super();
		}
		
		override public function execute() : void{
			switch(event.type){
				case UserEvent.GET_MY_DETAILS:
					foursquareService.getMyDetails( event.userVO );
					break;
				case UserEvent.MY_DETAILS_GOT:
					libraryModel.currentUser = event.userVO;
					break;
			}
		}
	}
}