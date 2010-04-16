package com.foursquare.models.vo{
	import mx.collections.ArrayCollection;
	
	public class UserVO{
		
		public var id:int;
		public var firstname:String;
		public var lastname:String;
		public var name_with_initial:String;
		public var email:String;
		public var twitter:String;
		public var facebook:String;
		public var photo:String;
		public var gender:String;
		public var badges:Array = new Array();
		public var city:CityVO;
		
		public function UserVO(remote:Object){
			this.id = remote.id;
			this.firstname = remote.firstname;
			this.lastname = remote.lastname;
			this.name_with_initial = this.firstname +' '+ ((remote.lastname && remote.lastname != null) ? this.lastname.substr(0,1) : '');
			
			if(remote.email) this.email = remote.email;
			if(remote.twitter) this.twitter = remote.twitter;
			if(remote.facebook) this.facebook = remote.facebook;
			this.gender = remote.gender;

			if(remote.photo){
			    this.photo = remote.photo;
			}
			else{
				this.photo = (this.gender=="male") ? 'http://playfoursquare.s3.amazonaws.com/userpix_thumbs/blank_boy.png' : 'http://playfoursquare.s3.amazonaws.com/userpix_thumbs/blank_girl.png';
			}
			
			if(remote.badges){
				var b:ArrayCollection;
			    if(remote.badges.badge){
				    b = remote.badges.badge as ArrayCollection;
			    }
			    else{
			    	b = new ArrayCollection(remote.badges);
			    }
			    b.source.forEach(function(el:Object, index:int, arr:Array):void{
			        badges.push(new BadgeVO(el));
			    });
			}
			this.city = ((remote.city) ? new CityVO(remote.city) : null);
		}
	}
}