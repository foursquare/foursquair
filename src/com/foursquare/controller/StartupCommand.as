////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 25, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.api.IFoursquareService;
	import com.foursquare.events.LoginEvent;
	import com.foursquare.models.LibraryModel;
	import com.foursquare.util.XMLUtil;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.iotashan.oauth.OAuthToken;
	import org.robotlegs.mvcs.Command;
	
	public class StartupCommand extends Command
	{
		
		[Inject]
		public var model:LibraryModel;

		[Inject]
		public var foursquareService:IFoursquareService;
		
		public function StartupCommand()
		{
			super();
		}
		
		/**
		 * check to see if an oauth file exists yet. if so, we're auto-logging in and moving on...
		 * 
		 */		
		override public function execute():void{
			
			var oauthFile:File = model.oauthFile;
			
			if(oauthFile.exists) { 
				var stream:FileStream = new FileStream(); 
				stream.open(oauthFile, FileMode.READ); 
				var filedata:String = stream.readUTFBytes(stream.bytesAvailable); 
				stream.close();
				
				var d:Object = XMLUtil.XMLToObject(filedata);
				model.oauth_token = new OAuthToken( d.foursquare.oauth_token_key,
													d.foursquare.oauth_token_secret);
				
				//start off process
				dispatch( new LoginEvent( LoginEvent.LOGIN_SUCCESS ));
				
			}
		}

	}
}