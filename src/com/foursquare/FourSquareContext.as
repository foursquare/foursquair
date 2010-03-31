////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 23, 2010 
////////////////////////////////////////////////////////////

package com.foursquare
{
	import com.foursquare.controller.CheckinCommand;
	import com.foursquare.controller.HistoryCommand;
	import com.foursquare.controller.LoginCommand;
	import com.foursquare.controller.Logout;
	import com.foursquare.controller.SearchCommand;
	import com.foursquare.controller.StartupCommand;
	import com.foursquare.controller.UserCommand;
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.HistoryEvent;
	import com.foursquare.events.LoginEvent;
	import com.foursquare.events.SearchEvent;
	import com.foursquare.events.StartupEvent;
	import com.foursquare.events.UserEvent;
	import com.foursquare.models.LibraryModel;
	import com.foursquare.services.FoursquareService;
	import com.foursquare.services.IFoursquareService;
	import com.foursquare.services.IGeoService;
	import com.foursquare.views.CheckinMediator;
	import com.foursquare.views.HeaderMediator;
	import com.foursquare.views.HistoryMediator;
	import com.foursquare.views.LoginMediator;
	import com.foursquare.views.MainViewMediator;
	import com.foursquare.views.NavigationMediator;
	import com.foursquare.views.SearchMediator;
	import com.foursquare.views.SettingsMediator;
	import com.foursquare.views.checkins.CheckinView;
	import com.foursquare.views.header.HeaderView;
	import com.foursquare.views.history.HistoryView;
	import com.foursquare.views.login.LoginView;
	import com.foursquare.views.navigation.Navigation;
	import com.foursquare.views.search.SearchView;
	import com.foursquare.views.settings.SettingsView;
	import com.quilix.maxmind.GeoIPService;
	
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
			commandMap.mapEvent( CheckinEvent.SHOUT_SUCCESS, CheckinCommand, CheckinEvent );
			commandMap.mapEvent( CheckinEvent.READ, CheckinCommand, CheckinEvent );
			commandMap.mapEvent( CheckinEvent.READ_RETURNED, CheckinCommand, CheckinEvent );
			//settings event also handled by CheckinCommand
			commandMap.mapEvent( CheckinEvent.CHANGE_POLL_INTERVAL, CheckinCommand, CheckinEvent );
			commandMap.mapEvent( CheckinEvent.TOGGLE_GROWL_MESSAGING, CheckinCommand, CheckinEvent );
			
			commandMap.mapEvent( HistoryEvent.READ, HistoryCommand, HistoryEvent );
			commandMap.mapEvent( HistoryEvent.READ_RETURNED, HistoryCommand, HistoryEvent );

			commandMap.mapEvent( SearchEvent.GET_USER_LOCATION, SearchCommand, SearchEvent );
			commandMap.mapEvent( SearchEvent.QUERY, SearchCommand, SearchEvent );
			commandMap.mapEvent( SearchEvent.QUERY_RETURNED, SearchCommand, SearchEvent );
			
			commandMap.mapEvent( LoginEvent.LOGIN, LoginCommand, LoginEvent );
			commandMap.mapEvent( LoginEvent.LOGOUT, Logout, LoginEvent );
			commandMap.mapEvent( LoginEvent.LOGIN_SUCCESS, LoginCommand, LoginEvent );
			
			commandMap.mapEvent( UserEvent.GET_DETAILS, UserCommand, UserEvent );
			commandMap.mapEvent( UserEvent.DETAILS_GOT, UserCommand, UserEvent );
			
			
			
			//map model
			injector.mapSingleton( LibraryModel );
			
			//map service
			injector.mapSingletonOf( IFoursquareService, FoursquareService );
			injector.mapSingletonOf( IGeoService, GeoIPService );
			
			//map view
			mediatorMap.mapView( Navigation, NavigationMediator );
			mediatorMap.mapView( LoginView, LoginMediator );
			mediatorMap.mapView( SettingsView, SettingsMediator );
			mediatorMap.mapView( CheckinView, CheckinMediator, null, true, false );
			mediatorMap.mapView( HistoryView, HistoryMediator, null, true, false );
			mediatorMap.mapView( SearchView, SearchMediator, null, true, false );
			mediatorMap.mapView( HeaderView, HeaderMediator );
			mediatorMap.mapView( Foursquair, MainViewMediator );

			//app starts by checking for updates.
			dispatchEvent( new StartupEvent(StartupEvent.STARTUP) );
		}
	}
}