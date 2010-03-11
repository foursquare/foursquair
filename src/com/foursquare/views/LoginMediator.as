////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 30, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
	import com.foursquare.events.LoginEvent;
	import com.foursquare.views.login.LoginView;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LoginMediator extends Mediator
	{
		
		[Inject]
		public var loginView:LoginView;
		
		public function LoginMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener( loginView, LoginEvent.LOGIN, handleLogin );
		}
		
		private function handleLogin(event:LoginEvent):void{
			eventDispatcher.dispatchEvent( event );
		}
		
		public function get rememberMe():Boolean{
			return loginView.rememberMe.selected;
		}
		
	}
}