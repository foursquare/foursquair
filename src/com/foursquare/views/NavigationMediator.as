////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 9, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
	import com.foursquare.events.LoginEvent;
	import com.foursquare.events.NavigationEvent;
	import com.foursquare.views.navigation.Navigation;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class NavigationMediator extends Mediator
	{
		
		[Inject]
		public var navigation:Navigation;
		
		public function NavigationMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			//listen for a click
			eventMap.mapListener( navigation, NavigationEvent.CHANGE, bounceEvent );

			eventMap.mapListener( eventDispatcher, LoginEvent.LOGOUT, onLogout );
		}

		private function onLogout(event:LoginEvent):void{
			navigation.buttonBar.selectedIndex = 0;
		}
		
		//make robotlegs aware of the change.
		private function bounceEvent(event:NavigationEvent):void{
			eventDispatcher.dispatchEvent( event );
		}
		
	}
}