////////////////////////////////////////////////////////////
// Project: Foursquair 
// added by: Seth Hillinger
// Added on: Mar 7, 2010 
////////////////////////////////////////////////////////////

/**
 * Copyright (c) 2009 Rick Winscot www.quilix.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.quilix.maxmind
{
	
	
	
	import com.foursquare.services.IGeoService;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.rpc.events.FaultEvent;
	
	
	
	/**
	 * Utility class used to geocode via captured IP address; a service provided
	 * by MaxMind. If you use this... make sure to give them credit! 
	 * 
	 * @see http://www.maxmind.com
	 * 
	 * @example Typical usage for the Maxmind GeoIP class.
	 * <listing>
	 * 
	 * 
	 * // Call into the static method with your result and fault handlers
	 * GeoIP.getGeospatialInfos( handleResult, handleFault );
	 * 
	 * private function handleResult( xml:XML ):void
	 * {
	 *     // Process XML result here...
	 *     Trace( "Your Region: " + xml.geoip_region );
	 * }
	 * 
	 * private function handleFault():void
	 * {
	 *     // Some fault stuffs here...
	 *     Trace("Maxmind not responding.");
	 * }
	 * 
	 * </listing>
	 */					
	public class GeoIPService implements IGeoService
	{
		
		
		/**
		 * @private
		 * Function reference passed by caller for result return. 
		 */
		private static var _resultCallback:Function = null;
		
		/**
		 * @private
		 * Function reference passed by called for fault return.
		 */
		private static var _faultCallback:Function = null;
		
		
		
		/**
		 * Provides geospatial information (geocode-by-IP) for HTTP traffic. A result
		 * or fault is passed back the caller. 
		 * 
		 * @param resultHandler <code>Function</code> provided by the caller that will be used
		 * as a result handler.
		 * 
		 * @param faultHandler <code>Function</code> provided by the caller that will be used
		 * as a fault handler. 
		 */
		public function getGeospatialInfos( resultHandler:Function, faultHandler:Function = null ):void
		{
			_resultCallback = resultHandler;
			_faultCallback = faultHandler;
			
			var url:String = "http://j.maxmind.com/app/geoip.js";
			
			var req:URLRequest = new URLRequest( url );
			var loader:URLLoader = new URLLoader( req );
			
			loader.addEventListener( Event.COMPLETE, handleRegionInfosLoaded, false, 0, true );
			loader.addEventListener( FaultEvent.FAULT, handleRegionInfosFault, false, 0, true ); 
		}
		
		
		/**
		 * @private
		 * 
		 * MaxMind provides a great service for geocoding by ip. They do
		 * this by dynamically generating JavaScript for remote execution.  
		 * 
		 * Hitting this url...
		 * http://j.maxmind.com/app/geoip.js
		 * 
		 * Produces something like this in a browser window...
		 * 
		 * function geoip_country_code() { return 'US'; }
		 * function geoip_country_name() { return 'United States'; }
		 * function geoip_city()         { return 'State College'; }
		 * function geoip_region()       { return 'PA'; }
		 * function geoip_region_name()  { return 'Pennsylvania'; }
		 * function geoip_latitude()     { return '40.7912'; }
		 * function geoip_longitude()    { return '-77.8746'; }
		 * function geoip_postal_code()  { return '16802'; }
		 * 
		 * ...which can open a sandbox can of worms if you are going to try
		 * remote JavaScript execution. If only this service returned XML!
		 * 
		 * MaxMind already has a crossdomain.xml in place.
		 * 
		 * http://j.maxmind.com/crossdomain.xml
		 * 
		 * So, use a loader to retrieve the JavaScript as text. Given the fact 
		 * that the JavaScript is dynamically generated and that this is an 
		 * established API... it should be safe to use string replacement to
		 * convert the output to XML. My approach yields the following results.
		 * 
		 * <maxmind>
		 * 	  <geoip_country_code value="US"/>
		 * 	  <geoip_country_name value="United States"/>
		 * 	  <geoip_city value="State College"/>
		 * 	  <geoip_region value="PA"/>
		 * 	  <geoip_region_name value="Pennsylvania"/>
		 * 	  <geoip_latitude value="40.7912"/>
		 * 	  <geoip_longitude value="-77.8746"/>
		 * 	  <geoip_postal_code value="16802"/>
		 * 	</maxmind>
		 */
		private static function handleRegionInfosLoaded( event:Event ):void
		{
			event.target.removeEventListener( Event.COMPLETE, handleRegionInfosLoaded );
			event.target.removeEventListener( FaultEvent.FAULT, handleRegionInfosFault );
			
			var result:String = event.target.data as String;
			var rxp:RegExp = new RegExp( "g" );
			result = result.replace( new RegExp( "{ return ", "g" ), "value=" );
			result = result.replace( new RegExp( "function ", "g" ), "<" );
			result = result.replace( new RegExp( "; }", "g" ), "/>" );
			result = result.replace( /\(/g, "" );
			result = result.replace( /\)/g, "" );
			result = "<maxmind>" + result + "</maxmind>";
			
			var xml:XML = new XML( result );
			
			if ( _resultCallback != null )
				_resultCallback( xml );
		}	
		
		
		/**
		 * @private
		 * Give Mr. Scrooge a stale bisquit.
		 */
		private static function handleRegionInfosFault( event:Event ):void
		{
			event.target.removeEventListener( Event.COMPLETE, handleRegionInfosLoaded );
			event.target.removeEventListener( FaultEvent.FAULT, handleRegionInfosFault );
			
			if ( _faultCallback != null )
				_faultCallback();
		}	
		
		
		
	}
	
}