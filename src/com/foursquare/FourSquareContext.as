////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 23, 2010 
////////////////////////////////////////////////////////////

package com.foursquare
{
	import com.foursquare.api.FoursquareService;
	import com.foursquare.api.IFoursquareService;
	import com.foursquare.controller.CheckinCommand;
	import com.foursquare.controller.LoginCommand;
	import com.foursquare.controller.Logout;
	import com.foursquare.controller.StartupCommand;
	import com.foursquare.controller.UserCommand;
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.LoginEvent;
	import com.foursquare.events.StartupEvent;
	import com.foursquare.events.UserEvent;
	import com.foursquare.models.LibraryModel;
	import com.foursquare.views.CheckinMediator;
	import com.foursquare.views.LoginMediator;
	import com.foursquare.views.MainViewMediator;
	import com.foursquare.views.NavigationMediator;
	import com.foursquare.views.checkins.CheckinView;
	import com.foursquare.views.login.LoginView;
	import com.foursquare.views.navigation.Navigation;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	public class FourSquareContext extends Context
	{
		public function FourSquareContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			//map controller
			commandMap.mapEvent( StartupEvent.STARTUP, StartupCommand, StartupEvent );
		
			commandMap.mapEvent( CheckinEvent.SHOUT, CheckinCommand, CheckinEvent );
			commandMap.mapEvent( CheckinEvent.READ, CheckinCommand, CheckinEvent );
			
			commandMap.mapEvent( LoginEvent.LOGIN, LoginCommand, LoginEvent );
			commandMap.mapEvent( LoginEvent.LOGOUT, Logout, LoginEvent );
			commandMap.mapEvent( LoginEvent.LOGIN_SUCCESS, LoginCommand, LoginEvent );
			
			commandMap.mapEvent( UserEvent.GET_DETAILS, UserCommand, UserEvent );
			commandMap.mapEvent( UserEvent.DETAILS_GOT, UserCommand, UserEvent );
			
			//map model
			injector.mapSingleton( LibraryModel );
			
			//map service
			injector.mapSingletonOf( IFoursquareService, FoursquareService );
			
			//map view
			mediatorMap.mapView( Navigation, NavigationMediator );
			mediatorMap.mapView( LoginView, LoginMediator );
			mediatorMap.mapView( CheckinView, CheckinMediator );
			mediatorMap.mapView( FoursquairNew, MainViewMediator );

			//app starts by checking for updates.
			dispatchEvent( new StartupEvent(StartupEvent.STARTUP) );
		}
	}
}