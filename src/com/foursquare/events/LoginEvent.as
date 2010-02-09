////////////////////////////////////////////////////////////
// Project: foursquair
// Author: Seth Hillinger
// Created: Jan 17, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.events
{
	import flash.events.Event;
	
	public class LoginEvent extends Event
	{
		
		public static const LOGIN:String="login";
		public static const LOGOUT:String="logout";
		public static const LOGIN_SUCCESS:String="loginSuccess";
		
		public var username:String;
		public var password:String;
		public var rememberMe:Boolean;
		
		public function LoginEvent(type:String):void
		{
			super(type, false, false);
		}
		
		override public function clone() : Event
		{
			var loginEvent:LoginEvent = new LoginEvent(this.type);
			loginEvent.username = username;
			loginEvent.password = password;
			loginEvent.rememberMe = rememberMe;

			return loginEvent;
		}
	}
}