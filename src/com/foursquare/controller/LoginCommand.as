////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 30, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.api.IFoursquareService;
	import com.foursquare.events.LoginEvent;
	import com.foursquare.events.NavigationEvent;
	import com.foursquare.events.UserEvent;
	import com.foursquare.models.LibraryModel;
	import com.foursquare.models.Section;
	import com.foursquare.util.XMLUtil;
	
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.robotlegs.mvcs.Command;
	
	public class LoginCommand extends Command
	{
		
		[Inject]
		public var event:LoginEvent;
		
		[Inject]
		public var foursquareService:IFoursquareService;
		
		[Inject]
		public var model:LibraryModel;
		
		public function LoginCommand()
		{
			super();
		}
		
		override public function execute():void{
			switch( event.type ){
				case LoginEvent.LOGIN:
					foursquareService.login( event );
					break;
				case LoginEvent.LOGIN_SUCCESS:
					loginSuccess( event );
					break;
			}
		}
		
		private function loginSuccess( event:LoginEvent ):void{
			if(event.rememberMe){
				var d:Object = new Object();
				d.oauth_token = model.oauth_token;
				d.oauth_token_secret = model.oauth_token_secret;
				var contents:String = XMLUtil.objectToXML(d).toXMLString();
				
				var stream:FileStream = new FileStream(); 
				stream.open(model.oauthFile, FileMode.WRITE);
				stream.writeUTFBytes(contents); 
				stream.close(); 
			}
			
			//fire off getUserDetails
			var userEvent:UserEvent = new UserEvent( UserEvent.GET_DETAILS );
			dispatch( userEvent );
			
			//navigate to Checkin.
			var navigationEvent:NavigationEvent = new NavigationEvent( NavigationEvent.CHANGE );
			navigationEvent.section = Section.CHECKIN;
			dispatch( navigationEvent );
		}
	}
}