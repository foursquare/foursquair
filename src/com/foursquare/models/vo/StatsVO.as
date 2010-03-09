////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Mar 9, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.models.vo
{
	public class StatsVO
	{
		public var herenow:String;
		
		public function StatsVO(remote:Object=null){
			if(remote){
				this.herenow = remote.herenow;
			}
		}
	}
}