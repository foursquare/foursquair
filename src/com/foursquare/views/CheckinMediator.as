////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 31, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.views.checkins.CheckinView;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class CheckinMediator extends Mediator
	{
		
		[Inject]
		public var checkinView:CheckinView;
		
		public function CheckinMediator()
		{
			super();
		}
		
		override public function onRegister() : void{
			eventMap.mapListener( checkinView, CheckinEvent.READ, getCheckins );
			
			getCheckins( new CheckinEvent( CheckinEvent.READ ) );			
		}
		
		public function setCheckins( checkins: ArrayCollection ):void{
			checkinView.checkins = checkins;
		}
		
		private function getCheckins(event:CheckinEvent):void{
			eventDispatcher.dispatchEvent( event.clone() );
		}
	}
}