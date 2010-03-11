////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 23, 2010 
////////////////////////////////////////////////////////////

package com.foursquare
{
	import air.update.ApplicationUpdaterUI;
	
	import com.adobe.air.notification.AbstractNotification;
	import com.adobe.air.notification.Notification;
	import com.adobe.air.notification.NotificationClickedEvent;
	import com.adobe.air.notification.Purr;
	import com.foursquare.api.*;
	import com.foursquare.commands.UpdateApplicationCommand;
	import com.foursquare.events.LoginEvent;
	import com.foursquare.util.XMLUtil;
	import com.foursquare.views.checkins.CheckinView;
	import com.foursquare.views.history.History;
	import com.foursquare.views.login.LoginView;
	import com.foursquare.views.venues.VenueEvent;
	import com.foursquare.views.venues.Venues;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.*;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.ViewStack;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.Image;
	import mx.controls.LinkButton;
	import mx.controls.SWFLoader;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.effects.Parallel;

	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.LoginEvent;
	import com.foursquare.views.nativeWindows.PurrWindow;
	import com.foursquare.views.shout.ShoutBox;
	
	import mx.events.FlexEvent;
	
	import spark.components.WindowedApplication;
	
	public class FourSquareBase_old extends WindowedApplication
	{

		public var foursquare:FoursqaureService = new FoursqaureService('266d5934f6cb223fcd5ffc75eeb0a99404acf504c', '6265da6ce9bd8cb2c69632ae51836327');
		
		private var checkins:ArrayCollection;
		private var venues:ArrayCollection = new ArrayCollection();
		private var history:ArrayCollection = new ArrayCollection();
		
		[Bindable] public var actor:UserVO;
		[Bindable] public var currentVersion:String;
		
		/*mxml components*/
		public var viewStack:ViewStack;
		public var debug:TextArea;
		
		public var loginView:LoginView;
		public var historyView:History;
		public var venueView:Venues;
		public var checkinView:CheckinView;
		
		public var friendsLoadingIndicator:SWFLoader;
		public var loginLoadingIndicator:SWFLoader;
		public var searchLoadingIndicator:SWFLoader;
		public var shoutLoadingIndicator:SWFLoader;
		
		public var shoutBox:ShoutBox;
		
		[Bindable] public var shoutSubmit:Button;
		public var shoutText:TextInput;
		public var username:TextInput;
		
		public var debugButton:LinkButton;

		/*move effect*/
		public var ViewStackTransitionEffectStart:Move;
		public var ViewStackTransitionEffectEnd:Move;
		[Bindable] public var viewStackTransitionEffect:Parallel;
		
		private var updateCheckTimer:Timer;
		
		//private var purr:Purr = new Purr(1);
		//private const iconURL: String = "assets/images/notification_dude.png";
		//private var bmp: Bitmap = null;
		private var outGoing:DisplayObject;

		private var logText:String;
		
		private var appUpdater:ApplicationUpdaterUI;
		
		public function FourSquareBase_old()
		{
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
			addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onStateChange);
		}
		
		private function onCreationComplete(event:FlexEvent):void{
			//growl feature.
			purrWindow = new PurrWindow(1);
		}
		

		/**
		 * handle shout shouts a message.
		 */ 
		public function handleShout( message:String ):void{
			shoutBox.shoutText.text = "";
			growl("", message);
		}
		
		public function error(e:Object):void{
			var error:Error = e as Error;
			if(e is Error){
				error = e.data as Error;
			}
			else{
				error = new Error(e);
			}
			debug.text += "ERROR: "+e.message+"\n";
			debug.text += e.getStackTrace()+"\n";
			trace("ERROR: "+e.message);
			trace(e.getStackTrace());
			
			debug.validateNow();
			debug.verticalScrollPosition = debug.maxVerticalScrollPosition;
		}
		
		private function init(event:FlexEvent):void{
			
			log('creation complete called');
			log('starting up appUpdater');
			
			//assign icon to "growl-like" notifications
			/*var i:Image = new Image;
			i.addEventListener(Event.COMPLETE, function(event:Event):void{
				bmp = Bitmap(Image(event.target).content);
				purr.setIcons([bmp.bitmapData], "foursquair: all the cool kids are doing it.");
				
				var m: NativeMenu = new NativeMenu();
				m.addItem(new NativeMenuItem('Exit'));
				purr.setMenu(m);
				
			});
			i.load(iconURL);*/
			
			//check for oauth
			/*log('checking oauth keys');
			oauthFile = File.applicationStorageDirectory; 
			oauthFile = oauthFile.resolvePath("Preferences/oauth_debug_2.txt");
			if(oauthFile.exists) { 
				log('oauth keys there');
				var stream:FileStream = new FileStream(); 
				stream.open(oauthFile, FileMode.READ); 
				var filedata:String = stream.readUTFBytes(stream.bytesAvailable); 
				stream.close();
				
				var d:Object = com.foursquare.util.XMLUtil.XMLToObject(filedata);
				foursquare.oauth_token = d.foursquare.oauth_token;
				foursquare.oauth_token_secret = d.foursquare.oauth_token_secret;
				
				bootstrap();
				
			} else { 
				log('oauth keys not there');
				firstRun();
			} */
		}
		
		private function firstRun():void { 
			// do stuff..
			currentState = 'Login';
			appUpdater.checkNow();
		}
		
		public function bounceShoutEvent( event:CheckinEvent ):void{
			dispatchEvent( event.clone() );
		}
			
		
		public function growl(title:String, message:String):void{
			purrWindow.addTextNotificationByParams(title, message);
		}
		
		/**
		 * logout 
		 * 
		 */		
		private function onStateChange(event:StateChangeEvent):void{
			if(!debugButton.hasEventListener(MouseEvent.CLICK))
				debugButton.addEventListener(MouseEvent.CLICK, handleDebugClick);

			switch(event.newState){
				case "Main":
					if(!buttonBar.hasEventListener(IndexChangeEvent.CHANGING))
						buttonBar.addEventListener(IndexChangeEvent.CHANGING, onIndexChange);

					/*Pass ArrayCollections into Views*/
					historyView.history = history;
					venueView.venues = venues;
					venueView.addEventListener( VenueEvent.SHOUT, onVenueShout);
					checkinView.checkins = checkins;
					break;
				
				case "Login":
					loginView.addEventListener( LoginEvent.LOGIN, handleLogin);
					break;
			} 
		}
		
		public function logout(event:LoginEvent):void{
			dispatchEvent( event );	
		}

		
		public function checkForUpdates(...rest):void{
			log('checking for updates');
			showIndicator(checkinView.friendsLoadingIndicator);
			
			status = 'Checking for updates...';
			foursquare.getCheckins(
				function(c:Array):void{
					var lastKnown:CheckinVO = checkins.getItemAt(0) as CheckinVO;
					if(lastKnown.id < c[0].id){
						var toAdd:Array = new Array();
						c.reverse().forEach(function(el:Object, index:int, arr:Array):void{
							if(el.id > lastKnown.id){
								toAdd.push(el);
							}
						});
						addCheckins(toAdd);
						status = toAdd.length+' updates added!';
					}
					else{
						status = 'No new updates :(';
					}
					hideIndicator(checkinView.friendsLoadingIndicator);
				}
			);
		}
		
		private function addCheckins(c:Array, notify:Boolean=true):void{
			log('adding checkins to display');
			try{
				if(c.length > 0){
					var notifyCheckins:Array = new Array();
					
					c.forEach(function(el:Object, index:int, arr:Array):void{
						var check:CheckinVO = CheckinVO(el);
						if(check.user.id != actor.id){
							notifyCheckins.push(check);
						}
					});
					notifyCheckins.reverse();
					
					checkins.addAllAt(new ArrayCollection(c), 0);
					if(notify==true && notifyCheckins.length > 0){
						var n:Notification = new Notification('Foursquair', notifyCheckins.length+' new checkins!', AbstractNotification.TOP_RIGHT, 3, bmp);

						//if notification clicked
						n.addEventListener(NotificationClickedEvent.NOTIFICATION_CLICKED_EVENT, 
							function(e:NotificationClickedEvent):void{
								AbstractNotification(e.target).close();
								//nativeWindow.activate();
							});
						purr.addNotification(n);
					}
				}
			}
			catch(e:Error){
				error(e);
			}
			
		}
		
		private function showIndicator(indicator:SWFLoader):void{
			indicator.visible = true;
			indicator.includeInLayout = true;
		}
		
		private function hideIndicator(indicator:SWFLoader):void{
			indicator.visible = false;
			indicator.includeInLayout = false;
		}
		
		public function bootstrap():void{
			log('boostrapping');
			try{
				showIndicator(checkinView.friendsLoadingIndicator);
			}
			catch(e:Error){}
			
			updateCheckTimer = new Timer((60000*5));
			updateCheckTimer.addEventListener(TimerEvent.TIMER, checkForUpdates);
			updateCheckTimer.start();
			
			checkins = new ArrayCollection();
			
			status = 'Loading up.... Please wait';
			log('getting user details');
			try{
				foursquare.getUserDetails(
					0, 
					function(u:UserVO):void{
						actor = foursquare.actor = u;
						log('getting checkins');
						try{
							foursquare.getCheckins(function(c:Array):void{
								addCheckins(c);
								currentState = 'Main';
								status = '';
								hideIndicator(checkinView.friendsLoadingIndicator);
							});
							
							foursquare.getHistory(20, function(h:Array):void{
								history.addAll(new ArrayCollection(h));
							});
						}
						catch(e:Error){
							error(e);
						}
						log('getting popular nearby venues');
						try{
							foursquare.getVenues(actor.city.geolat, actor.city.geolong, 25, 25, '', function(v:Array):void{
								venues = new ArrayCollection(v);
							});
						}
						catch(e:Error){
							error(e);
						}
					}, 
					null, 
					true, 
					false
				);
			}
			catch(e:Error){
				error(e);
			}
		}
		
		private function handleLogin(event:LoginEvent):void{
			showIndicator(loginView.loginLoadingIndicator);
			
			status = 'Loggin in...';
			foursquare.authExchange(
				event.username, 
				event.password, 
				/*function():void{
					if(event.rememberMe){
						var d:Object = new Object();
						d.oauth_token = foursquare.oauth_token;
						d.oauth_token_secret = foursquare.oauth_token_secret;
						var contents:String = com.foursquare.util.XMLUtil.objectToXML(d).toXMLString();
						
						var stream:FileStream = new FileStream(); 
						stream.open(oauthFile, FileMode.WRITE);
						stream.writeUTFBytes(contents); 
						stream.close(); 
					}
					status = '';
					hideIndicator(loginView.loginLoadingIndicator);
					bootstrap();
				}, 
				function(e:Error):void{
					status = 'Error trying to do auth exchange';
					error(e);
					hideIndicator(loginView.loginLoadingIndicator);
				}*/
			);
		}
		/**
		 * @todo (lucas) Link a shout to a venue without actually counting as a checkin? 
		 * ie 
		 * "Anybody want to check out this bar tonight?"
		 * 
		 * <a>Details on LIC Bar</a>
		 */ 
		public function handleShout():void{
			showIndicator(shoutLoadingIndicator);
			status = 'Shouting...';
			shoutSubmit.enabled = false;
			foursquare.checkin(0,'',shoutText.text,function(c:CheckinVO):void{
				shoutSubmit.enabled = true;
				checkForUpdates();
				status = '';
				shoutText.text = '';
				hideIndicator(shoutLoadingIndicator);
			});
		}
		
		private function handleVenueSearch(event:VenueEvent):void{
			showIndicator(searchLoadingIndicator);
			venues.removeAll();
			status = 'Searching...';
			venueView.venueSearchSubmit.enabled = false;
			try{
				foursquare.getVenues(
					actor.city.geolat, 
					actor.city.geolong, 
					10, 
					50, 
					event.searchText, 
					function(v:Array):void{
						venueView.venuesTitle.text = 'Search results for '+event.searchText;
						venues.addAll(new ArrayCollection(v));
						venueView.venueSearchSubmit.enabled = true;
						status = '';
						hideIndicator(searchLoadingIndicator);
					}
				);
			}
			catch(e:Error){
				mx.controls.Alert.show(e.message, 'Error getting venues');
				status = '';
				venueView.venueSearchSubmit.enabled = true;
				hideIndicator(searchLoadingIndicator);
			}
		}
		
		private function handleDebugClick(event:MouseEvent):void{
			debug.text = logText;
			debug.visible=!debug.visible;
			debug.includeInLayout=!debug.includeInLayout;
		}
		
		private function resolveXFromIn(e:*):Number{
			trace(viewStack.selectedIndex);
			trace(viewStack.getChildIndex(e.target));
			return viewStack.width;
		}
		private function resolveXToOut(e:Event):Number{
			return 0-viewStack.width;
		}

	}
}