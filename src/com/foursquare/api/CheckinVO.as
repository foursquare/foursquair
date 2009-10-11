package com.foursquare.api{
	import com.foursquare.util.TimeAgoInWords;
	
	public class CheckinVO{
		public var id:int;
		public var user:UserVO;
		public var venue:VenueVO;
		public var display:String;
		public var shout:String;
		public var created:Date;
		public var created_in_words:String;
		
		public function CheckinVO(remote:Object){
			this.id = remote.id;
			this.user = new UserVO(remote.user);
			this.venue = new VenueVO(remote.venue);
			this.display = remote.display;
			this.shout = remote.shout || '';
			
			//        SAT, DAY MONTH YEAR TIME OFF
            // KEY: (\w{3}+)(\,+) (\d{2}+) (\w{3}+) (\d{2}+) (\d{2}:\d{2}:\d{2}+) (\+|\-+)(\d{4}+)
            // Comes in like this
            // Sat, 10 Oct 09 00:43:06 +0000
            // Needs to be 
            // Sat Oct 10 00:43:06 GMT+0000 2009
            
			var cleaned:String = String(remote.created).replace(/(\w{3}+)(.{1}+) (\d{2}+) (\w{3}+) (\d{2}+) (\d{2}:\d{2}:\d{2}+) (\+|\-+)(\d{4}+)/g, "$1 $4 $3 $6 GMT$7$8 20$5");
            var then:Date = new Date();
            then.setTime(Date.parse(cleaned));
			
			this.created = then;
			this.created_in_words = TimeAgoInWords.format(then)+' ago';
		}
	}
}