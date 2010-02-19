////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 23, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.models
{
	import flash.filesystem.File;
	
	import org.iotashan.oauth.OAuthToken;
	import org.robotlegs.mvcs.Actor;
	
	public class LibraryModel extends Actor
	{
		
		/**
		 * log for service results 
		 */		
		private var _log:String;
		
		/**
		 * current version of users app 
		 */		
		public var currentVersion:String;
		
		/**
		 * oauth file 
		 */		
		public var oauthFile:File;
		
		/**
		 * oauth token 
		 */		
		public var oauth_token : OAuthToken;
		
		/**
		 * used during login 
		 */		
		public var rememberMe:Boolean;
		
		public function LibraryModel()
		{
			super();
			//instantiate oauthFile
			oauthFile = File.applicationStorageDirectory.resolvePath("user/oauth_token.xml");
		}
		
		public function log(value:String):void{
			_log = value;
		}
		
	}
}