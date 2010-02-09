package com.foursquare.api{
	import mx.collections.ArrayCollection;
	
	public class UserVO{
		
		[Bindable] public var id:int;
		[Bindable] public var firstname:String;
		[Bindable] public var lastname:String;
		[Bindable] public var name_with_initial:String;
		[Bindable] public var photo:String;
		[Bindable] public var gender:String;
		[Bindable] public var badges:Array = new Array();
		[Bindable] public var city:CityVO;
		
		public function UserVO(remote:Object){
			this.id = remote.id;
			this.firstname = remote.firstname;
			this.lastname = remote.lastname;
			this.name_with_initial = this.firstname +' '+ ((remote.lastname && remote.lastname != null) ? this.lastname.substr(0,1) : '');
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