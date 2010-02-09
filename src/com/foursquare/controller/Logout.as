////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 31, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.models.LibraryModel;
	
	import flash.filesystem.File;
	
	import org.robotlegs.mvcs.Command;
	
	public class Logout extends Command
	{
		
		[Inject]
		public var model:LibraryModel;
		
		public function Logout()
		{
			super();
		}
		
		override public function execute() : void{
			var oauthFile:File = model.oauthFile;
			oauthFile.deleteFile();
		}

	}
}