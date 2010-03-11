////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Mar 9, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
	import com.foursquare.events.UserEvent;
	import com.foursquare.views.header.HeaderView;
	
	import org.robotlegs.mvcs.Mediator;

	public class HeaderMediator extends Mediator
	{
		[Inject]
		public var headerView:HeaderView;
		
		public function HeaderMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener( eventDispatcher, UserEvent.DETAILS_GOT, onUserDetailsGot );
		}
		
		/**
		 * show username, in header. 
		 * @param event
		 * 
		 */		
		private function onUserDetailsGot(event:UserEvent):void{
			var lastName:String;
			event.userVO.lastname ? lastName = event.userVO.lastname : lastName = "";
			headerView.userName.text = event.userVO.firstname +" "+ lastName;
			headerView.userImage.source = event.userVO.photo;
		}
	}
}