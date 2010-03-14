////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 25, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views.nativeWindows
{
	import com.adobe.air.notification.Purr;
	import com.foursquare.models.Constants;
	
	import flash.display.Bitmap;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	
	import mx.controls.Image;
	
	public class PurrWindow extends Purr
	{
		override public function PurrWindow(idleThreshold:uint)
		{
			super(idleThreshold);
			
			//assign icon to "growl-like" notifications
			//TODO Seth: doesnt look good. need to figure out how to pass in the checkinUsers.image.
			/*var i:Image = new Image;
			i.addEventListener(Event.COMPLETE, function(event:Event):void{
				var bmp: Bitmap = Bitmap(Image(event.target).content);
				setIcons([bmp.bitmapData], "foursquair: all the cool kids are doing it.");
				
				var m: NativeMenu = new NativeMenu();
				m.addItem(new NativeMenuItem('Exit'));
				setMenu(m);
				
			});
			i.load( Constants.iconURL );*/
		}
	}
}