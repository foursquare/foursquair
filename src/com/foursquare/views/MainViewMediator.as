////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 31, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
	import com.foursquare.events.LoginEvent;
	import com.foursquare.events.NavigationEvent;
	import com.foursquare.events.UserEvent;
	import com.foursquare.models.Section;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MainViewMediator extends Mediator
	{
		
		[Inject]
		public var mainView:FoursquairNew;

		public function MainViewMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener( eventDispatcher, NavigationEvent.CHANGE, navigateToSection );
			eventMap.mapListener( eventDispatcher, UserEvent.DETAILS_GOT, onUserDetailsGot );
			eventMap.mapListener( mainView, LoginEvent.LOGOUT, logout );
		}
		
		/**
		 * sets the currentState of the app 
		 * @param navigationEvent
		 * 
		 */		
		private function navigateToSection(navigationEvent:NavigationEvent):void{
			if(!mainView.hasState( navigationEvent.section )){
				throw new Error("missing state "+navigationEvent.section);
				return;
			}else{
				mainView.setCurrentState(navigationEvent.section);
			}
		}
		
		private function onUserDetailsGot(event:UserEvent):void{
			mainView.header.userName.text = event.userVO.firstname +" "+ event.userVO.lastname;
		}
		
		private function logout(event:LoginEvent):void{
			dispatch( event.clone() );
			mainView.setCurrentState(Section.LOGIN);
		}
		
		}
}