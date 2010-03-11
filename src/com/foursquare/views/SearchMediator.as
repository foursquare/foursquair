////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Mar 7, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
	import com.foursquare.events.SearchEvent;
	import com.foursquare.models.vo.CityVO;
	import com.foursquare.views.search.SearchView;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	
	
	public class SearchMediator extends Mediator
	{

		[Inject]
		public var searchView:SearchView;
	
		public function SearchMediator()
		{
			super();
		}
		
		override public function onRegister() : void{
			eventMap.mapListener( searchView, SearchEvent.QUERY, doQuery );
		
			getUserLocation();
		}
		
		private function getUserLocation():void{
			eventDispatcher.dispatchEvent( new SearchEvent(SearchEvent.GET_USER_LOCATION) );
		}
		
		public function setUserLocation(cityVO:CityVO):void{
			searchView.setCity( cityVO );	
		}
		
		public function setQueryResults( results: ArrayCollection ):void{
			searchView.results = results;
		}
		
		private function doQuery(event:SearchEvent):void{
			eventDispatcher.dispatchEvent( event.clone() );
		}
	}
}