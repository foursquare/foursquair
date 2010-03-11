package com.foursquare.services
{
	public interface IGeoService
	{
	
		function getGeospatialInfos( resultHandler:Function, faultHandler:Function = null ):void;
		
	}
}