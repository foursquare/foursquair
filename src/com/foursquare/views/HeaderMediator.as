////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Mar 9, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
	import com.foursquare.events.UserEvent;
	import com.foursquare.models.LibraryModel;
	import com.foursquare.views.header.HeaderView;
	
	import org.robotlegs.mvcs.Mediator;

	public class HeaderMediator extends Mediator
	{
		[Inject]
		public var headerView:HeaderView;
		
		[Inject]
		public var model:LibraryModel;
		
		public function HeaderMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener( eventDispatcher, UserEvent.MY_DETAILS_GOT, onMyDetailsGot );
			
			if(model.currentUser){
				showUser(model.currentUser.firstname, model.currentUser.lastname, model.currentUser.photo);
			}
		}
		
		/**
		 * display
		 * 
		 * @param firstName
		 * @param lastName
		 * @param photo
		 * 
		 */		
		private function showUser(firstName:String, lastName:String, photo:String):void{
			headerView.userName.text = firstName +" "+ lastName;
			headerView.userImage.source = photo;
		}
		
		/**
		 * recieve user details
		 * @param event
		 * 
		 */		
		private function onMyDetailsGot(event:UserEvent):void{
			var lastName:String;
			event.userVO.lastname ? lastName = event.userVO.lastname : lastName = "";
			showUser(event.userVO.firstname, lastName, event.userVO.photo);
		}
	}
}