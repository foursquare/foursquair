////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 7, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.api.IFoursquareService;
	import com.foursquare.events.UserEvent;
	
	import org.robotlegs.mvcs.Command;
	
	public class UserCommand extends Command
	{
		
		[Inject]
		public var event:UserEvent;
		
		[Inject]
		public var foursquareService:IFoursquareService;
		
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
					break;
			}
		}
	}
}