package com.foursquare.api{
	public class BadgeVO{
	   [Bindable] public var id:int;
	   [Bindable] public var name:String;
	   [Bindable] public var icon:String;
	   [Bindable] public var description:String;
	   
	   public function BadgeVO(remote:Object):void{
	   	   this.id = remote.id;
	   	   this.name = remote.name;
	   	   this.icon = remote.icon;
	   	   this.description = remote.description;
	   }	
	}
}