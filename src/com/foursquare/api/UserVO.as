package com.foursquare.api{
	public class UserVO{
		
		public var id:int;
		public var firstname:String;
		public var lastname:String;
		public var photo:String;
		public var gender:String;
		public var badges:Array = new Array();
		
		public function UserVO(remote:Object){
			this.id = remote.id;
			this.firstname = remote.firstname;
			this.lastname = remote.lastname;
			this.gender = remote.gender;
			if(remote.photo){
			    this.photo = remote.photo;
			}
			else{
				this.photo = (this.gender=="male") ? 'http://playfoursquare.s3.amazonaws.com/userpix_thumbs/blank_boy.png' : 'http://playfoursquare.s3.amazonaws.com/userpix_thumbs/blank_girl.png';
			}
			if(remote.badges){
			   var b:Array = remote.badges as Array;
			   b.forEach(function(el:Object, index:int, arr:Array){
			       badges.push(new BadgeVO(el));
			   });
			}
			
		}
	}
}