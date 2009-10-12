package com.foursquare.api{
	import com.adobe.serialization.json.*;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	import mx.utils.ObjectUtil;
	
	import org.flaircode.oauth.*;
	import org.iotashan.oauth.*;
	
	
	
	public class FoursqaureService{
        public var actor:UserVO;
		private var oauth:IOAuth;
		public var oauth_token:String;
		public var oauth_token_secret:String;
		
		public function FoursqaureService(consumerKey:String, consumerSecret:String){
			oauth = new OAuth(consumerKey, consumerSecret);
		}
		
		public function authExchange(username:String, password:String, onSuccess:Function, onError:Function=null):void{
			var request:URLRequest = oauth.buildRequest(
			    URLRequestMethod.POST, 
			    'http://api.foursquare.com/v1/authexchange', 
			    null,
			    {fs_username: username,fs_password: password}
			);
			request.method = URLRequestMethod.POST;
			
            
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(
                IOErrorEvent.IO_ERROR, 
                function(e:IOErrorEvent):void{
                    trace('ERROR in auth exchange: '+e.toString());
                    
                    var error:Error = new Error("Incorrect username/password or couldnt talk to foursquare :(");
                    onError(error);
                }
            );
            loader.addEventListener(
                Event.COMPLETE, 
                function(e:Event):void{
                    var loader:URLLoader = e.target as URLLoader;
                    try{
	                    var xml:XML = new XML(loader.data);
	                    oauth_token = xml.descendants('oauth_token').toString();
	                    oauth_token_secret = xml.descendants('oauth_token_secret').toString();
	                    onSuccess.apply(this);
                    }
                    catch(e:Error){
                    	var error:Error = new Error("Couldnt parse XML.  Incorrect username/password or couldnt talk to foursquare :(");
                        if(onError != null){
                        	onError(error);
                        }
                        else{
                        	mx.controls.Alert.show(error.message, "error");
                        }
                    }
                }
            );
            loader.load(request);
		}
		/**
		 * vid - (optional, not necessary if you are 'shouting' or have a venue name). ID of the venue where you want to check-in.
		 * venue - (optional, not necessary if you are 'shouting' or have a vid) if you don't have a venue ID, pass the venue name as a string using this parameter. foursquare will attempt to match it on the server-side
		 * shout - (optional) a message about your check-in
		 * private - (optional, defaults to the user's setting). "1" means "don't show your friends". "0" means "show everyone"
		 * twitter - (optional, default to the user's setting). "1" means "send to twitter". "0" means "don't send to twitter"
		 * geolat - (optional, but recommended)
		 * geolong - (optional, but recommended)
		*/
		public function checkin(vid:int, venue:String='', shout:String='', onSuccess:Function=null, onError:Function=null):void{
			var params:Object = new Object();
			if(vid > 0){
				params.vid = vid;
			}
			if(venue.length > 1){
				params.venue = venue;
			}
			if(shout.length > 1){
				params.shout = shout;
			}
			getJSON(
                'http://api.foursquare.com/v1/checkin.json', 
                function(d:Object):void{
                	var c:Object = d.checkin;
                	d.user = actor;
                	d.shout = shout;
                	d.created = new Date();
                	onSuccess(new CheckinVO(d));
                },
                onError,
                true,
                params
            );
		}
		
		public function getCheckins(onSuccess:Function, onError:Function=null):void{
			getJSON(
			    'http://api.foursquare.com/v1/checkins.json', 
			    function(d:Object):void{
			    	var o:Array = new Array();
			    	if(d.checkins instanceof Array){
				    	var checkins:Array = [d.checkins];
				    	for(var i:int=0; i<d.checkins.length; i++){
				    		var c:Object = d.checkins[i];
		                    if(d.checkins[i].checkin){
		                        c = d.checkins[i].checkin;
		                    }
		                    o.push(new CheckinVO(c));
				    	}
                    }
                    else{
                    	o.push(new CheckinVO(d.checkins.checkin));
                    }
        
			    	onSuccess(o);
			    }, 
			    onError,
			    true
			);
		}
		
		public function getHistory(limit:int, onSuccess:Function, onError:Function=null):void{
			getJSON(
                'http://api.foursquare.com/v1/history.json', 
                function(d:Object):void{
                	var o:Array = new Array();
                    var checkins:Array = d.checkins as Array;
                    checkins.forEach(function(el:Object, index:int, arr:Array){
                    	el.user = actor;
                        o.push(new CheckinVO(el));
                    });
                    onSuccess(o);
                }, 
                onError,
                true,
                {l: limit}
            );
		}
		
		public function getUserDetails(uid:Number, onSuccess:Function, onError:Function=null, badges:Boolean=false, mayor:Boolean=false):void{
			var params:Object = new Object();
			
			if(uid > 1){
				params.uid = uid;
			}
			params.badges = (badges) ? 1 : 0;
			params.mayor = (mayor) ? 1 : 0;
			
			getJSON(
                'http://api.foursquare.com/v1/user.json', 
                function(d:Object):void{
                    onSuccess(new UserVO(d.user));
                }, 
                onError,
                true,
                params
            );
		}
		/**
		 * geolat - latitude (required)
         * geolong - longitude (required)
         * r - radius in miles (optional)
         * l - limit of results (optional, default 10)
         * q - keyword search (optional)
         */
		public function getVenues(geolat:Number, geolong:Number, r:Number=25, l:int=10, q:String=null, onSuccess:Function=null, onError:Function=null):void{
		    var params:Object = new Object();
		    params.geolat = geolat;
		    params.geolong = geolong;
		    params.r = r;
		    params.l = l;
		    
		    if(q!=null){
		    	params.q = q;
		    }
		    getJSON(
                'http://api.foursquare.com/v1/venues.json', 
                function(d:Object):void{
                    var o:Array = new Array();
                    
                    var venues:Array;
                    if(d.venues.group){
                    	venues = d.venues.group as Array;
                    }
                    else{
                        venues = d.venues[0] as Array;
                    }
                    
                    venues.forEach(function(el:Object, index:int, arr:Array){
                        o.push(new VenueVO(el));
                    });
                    onSuccess(o);
                },
                onError,
                true,
                params
            );
		}
		
		public function getJSON(url:String, onSuccess:Function, onError:Function=null, authRequired:Boolean=false, requestParams:Object=null):void{
			var request:URLRequest;
			if(!authRequired){
			    request = new URLRequest(url);
			    if(requestParams!=null){
			    	request.data = requestParams as URLVariables;
			    }
			}
			else{
				request = oauth.buildRequest(
	                URLRequestMethod.GET, 
	                url, 
	                new OAuthToken(oauth_token, oauth_token_secret),
	                requestParams
	            );
			}
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(
                IOErrorEvent.IO_ERROR, 
                function(e:IOErrorEvent):void{
                	var error:Error = new Error("Couldnt parse XML.  Incorrect username/password or couldnt talk to foursquare :(");
                	if(onError != null){
                        onError(error);
                    }
                    else{
                        mx.controls.Alert.show(error.message, "error");
                    }
                    var loader:URLLoader = e.target as URLLoader;
                    trace('GOT JSON');
                    trace(loader.data);
                }
            );
            loader.addEventListener(
                Event.COMPLETE, 
                function(e:Event):void{
                    var loader:URLLoader = e.target as URLLoader;
                    trace('GOT JSON');
                    trace(loader.data);
                    try{
                    var parsed:Object = JSON.decode(String(loader.data));
                    onSuccess(parsed);
                    }
                    catch(e:JSONParseError){
                    	mx.controls.Alert.show(e.message, 'JSON Parse Error :(');
                    }
                }
            );
            loader.load(request);
		}
		
		public function listCities(onSuccess:Function, onError:Function=null):void{
		    getJSON(
		        'http://api.foursquare.com/v1/cities.json', 
		        function(data:Object):void{
		        	var c:Array = data.cities as Array;
		            c.map(function(el:Object):void{
		               new CityVO(el);
		            });
		            trace(c.length);
		            trace(ObjectUtil.toString(c));
		            onSuccess(c);
		        }
		    );
		}
	}
}