package com.foursquare.api{
	public class BadgeVO{
	   public var id:int;
	   public var name:String;
	   public var icon:String;
	   public var description:String;
	   
	   public function BadgeVO(remote:Object):void{
	   	   this.id = remote.id;
	   	   this.name = remote.name;
	   	   this.icon = remote.icon;
	   	   this.description = remote.description;
	   }	
	}
}