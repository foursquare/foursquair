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
	import com.foursquare.views.shout.ShoutBox;
	
	import mx.events.FlexEvent;
	
	import spark.components.WindowedApplication;
	
	public class FoursquareBase extends WindowedApplication
	{
		
		public var shoutBox:ShoutBox;
		
		private var _selectedSection:int;
		private var purrWindow:PurrWindow;
		
		public function FoursquareBase()
		{
			super();
			addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener( LoginEvent.LOGOUT, logout, true);
		}
		
		private function onCreationComplete(event:FlexEvent):void{
			//growl feature.
			purrWindow = new PurrWindow(1);
		}
		

		/**
		 * handle shout shouts a message.
		 */ 
		public function handleShout( message:String ):void{
			shoutBox.shoutText.text = "";
			growl("", message);
		}
		
		public function bounceShoutEvent( event:CheckinEvent ):void{
			dispatchEvent( event.clone() );
		}
			
		
		public function growl(title:String, message:String):void{
			purrWindow.addTextNotificationByParams(title, message);
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