////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 15, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views.alert
{
	import flash.display.DisplayObject;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;

	public class Alert
	{
		
		private static var alertPanel:AlertPanel;
		
		public function Alert()
		{
		}
		
		public static function show(parent:DisplayObject, message:String, title:String, modal:Boolean=false):void{
			if(!alertPanel){
				alertPanel = PopUpManager.createPopUp(parent, AlertPanel, modal) as AlertPanel;
				alertPanel.addEventListener( CloseEvent.CLOSE, onCloseClick);
			}else{
				PopUpManager.addPopUp( alertPanel, parent, modal );
			}
			
			PopUpManager.centerPopUp( alertPanel );
			alertPanel.text.text = message;
			alertPanel.title = title;
		}
		
		private static function onCloseClick(event:CloseEvent):void{
			PopUpManager.removePopUp( alertPanel );
		}
	}
}