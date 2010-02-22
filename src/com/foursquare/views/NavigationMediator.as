////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 9, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
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
			eventMap.mapListener( navigation, NavigationEvent.CHANGE, bounceEvent );
		}
		
		//make robotlegs aware of the change.
		private function bounceEvent(event:NavigationEvent):void{
			eventDispatcher.dispatchEvent( event );
		}
	}
}