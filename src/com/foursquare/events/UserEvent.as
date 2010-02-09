////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 7, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.events
{
	import com.foursquare.api.UserVO;
	
	import flash.events.Event;
	
	public class UserEvent extends Event
	{
		
		public static const GET_DETAILS:String = "getDetails";
		public static const DETAILS_GOT:String = "detailsGot";
		
		public var userVO:UserVO;
		
		public function UserEvent(type:String)
		{
			super(type);
		}
	}
}