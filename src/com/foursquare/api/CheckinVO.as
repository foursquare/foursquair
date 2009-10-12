package com.foursquare.api{
	import com.foursquare.util.TimeAgoInWords;
	
	public class CheckinVO{
		public var id:int = 0;
		public var user:UserVO;
		public var venue:VenueVO;
		public var display:String;
		public var shout:String;
		public var created:Date;
		public var created_in_words:String;
		public var is_shout_only:Boolean = false;
		
		public function CheckinVO(remote:Object){
			this.id = remote.id;
			this.user = new UserVO(remote.user);
			this.venue = (remote.venue && remote.venue!= null) ? new VenueVO(remote.venue) : null;
			this.display = remote.display;
			this.shout = remote.shout || '';
			
			this.is_shout_only = this.venue==null;
			
			//        SAT, DAY MONTH YEAR TIME OFF
            // KEY: (\w{3}+)(\,+) (\d{2}+) (\w{3}+) (\d{2}+) (\d{2}:\d{2}:\d{2}+) (\+|\-+)(\d{4}+)
            // Comes in like this
            // Sat, 10 Oct 09 00:43:06 +0000
            // Needs to be 
            // Sat Oct 10 00:43:06 GMT+0000 2009
            var then:Date = new Date();
            var isDate:Boolean = remote.created instanceof Date;
            if(isDate==false){
            	var cleaned:String = String(remote.created).replace(/(\w{3}+)(.{1}+) (\d{2}+) (\w{3}+) (\d{2}+) (\d{2}:\d{2}:\d{2}+) (\+|\-+)(\d{4}+)/g, "$1 $4 $3 $6 GMT$7$8 20$5");
                then.setTime(Date.parse(cleaned));
            }
			this.created = then;
			this.created_in_words = TimeAgoInWords.format(then)+' ago';
		}
	}
}