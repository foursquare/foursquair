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
		public static var CONSUMER_SECRET:String = '6265da6ce9bd8cb2c69632ae51836327';
		public static var CONSUMER_KEY:String = '266d5934f6cb223fcd5ffc75eeb0a99404acf504c';
		private var oauth:IOAuth;
		private var oauth_token:String;
		private var oauth_token_secret:String;
		
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
		
		public function getCheckins(onSuccess:Function, onError:Function=null):void{
			getJSON(
			    'http://api.foursquare.com/v1/checkins.json', 
			    function(d:Object):void{
			    	var checkins:Array = [d.checkins];
			    	var o:Array = new Array();
			    	checkins.forEach(function(el:Object, index:int, arr:Array){
			    		o.push(new CheckinVO(el.checkin));
			    	});
			    	onSuccess(o);
			    }, 
			    onError,
			    true
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
                }
            );
            loader.addEventListener(
                Event.COMPLETE, 
                function(e:Event):void{
                    var loader:URLLoader = e.target as URLLoader;
                    trace('GOT JSON');
                    trace(loader.data);
                    onSuccess(JSON.decode(loader.data));
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