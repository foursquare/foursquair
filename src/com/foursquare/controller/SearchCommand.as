////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Mar 7, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.events.ErrorEvent;
	import com.foursquare.events.SearchEvent;
	import com.foursquare.models.LibraryModel;
	import com.foursquare.models.vo.CityVO;
	import com.foursquare.models.vo.UserVO;
	import com.foursquare.services.IFoursquareService;
	import com.foursquare.services.IGeoService;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;
	
	
	public class SearchCommand extends Command
	{
		[Inject]
		public var event:SearchEvent;
		
		[Inject]
		public var foursquareService:IFoursquareService;
		
		[Inject]
		public var maxmindService:IGeoService;
		
		[Inject]
		public var libraryModel:LibraryModel;
		
		public function SearchCommand()
		{
			super();
		}
		
		override public function execute():void{
			switch(event.type){
				case SearchEvent.GET_USER_LOCATION:
					getLocation(); 
					break;
				case SearchEvent.QUERY:
					query(event.keyword);
					break;
				case SearchEvent.QUERY_RETURNED:
					handleQuery(event.results);
					break;
			}
		}
		
		/**
		 * pings a service and returns the user's long/lat 
		 * 
		 */		
		private function getLocation():void{
			maxmindService.getGeospatialInfos(handleLocation, faultLocation);
		}
		
		/**
		 * queries foursquare and returns venue's nearby 
		 * @param keywords (optional) search
		 * 
		 */		
		private function query(keywords:String=null):void{
			var currentUser:UserVO = libraryModel.currentUser;
			foursquareService.getVenues(	currentUser.city.geolat, 
											currentUser.city.geolong,
										 	25, 10, keywords );
		}
		
		/**
		 * callback for geocoding results.
		 * set the currentUser's cityVO 
		 * @param xml
		 * 
		 */		
		private function handleLocation(xml : XML):void{
			var cityVO:CityVO = new CityVO(null);
			cityVO.geolat = xml.geoip_latitude.@value;
			cityVO.geolong = xml.geoip_longitude.@value;

			//set to currentUser
			var currentUser:UserVO = libraryModel.currentUser;
			currentUser.city = cityVO;
			
			//do first query
			query();
		}
		
		private function faultLocation():void{
			var errorEvent:ErrorEvent = new ErrorEvent( ErrorEvent.ERROR );
			errorEvent.error = new Error("could not get your location");
			dispatch(errorEvent);
		}
		
		/**
		 * handles query results 
		 * @param results
		 * 
		 */		
		private function handleQuery(results : ArrayCollection):void{
			
		}
	}
}