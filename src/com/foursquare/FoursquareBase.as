////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 23, 2010 
////////////////////////////////////////////////////////////

package com.foursquare
{
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.LoginEvent;
	import com.foursquare.views.nativeWindows.PurrWindow;
	
	import mx.events.FlexEvent;
	
	import spark.components.WindowedApplication;
	
	public class FoursquareBase extends WindowedApplication
	{
		
		private var _selectedSection:int;
		
		public function FoursquareBase()
		{
			super();
			addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener( LoginEvent.LOGOUT, logout, true);
		}
		
		private function onCreationComplete(event:FlexEvent):void{
			//growl feature.
			var purrWindow:PurrWindow = new PurrWindow(1);
		}
		

		/**
		 * handle shout shouts a message.
		 * 
 		 * @todo (lucas) Link a shout to a venue without actually counting as a checkin? 
		 * ie "Anybody want to check out this bar tonight?"
		 */ 
		public function handleShout( event:CheckinEvent ):void{
			dispatchEvent( event.clone() );
		}
		
		/**
		 * logout 
		 * 
		 */		
		public function logout(event:LoginEvent):void{
			dispatchEvent( event );	
		}


	}
}