////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Mar 7, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views.search
{
	import mx.collections.ArrayCollection;
	
	import spark.components.SkinnableContainer;
	
	public class SearchViewBase extends SkinnableContainer
	{
		
		private var _results:ArrayCollection;
		
		public function SearchViewBase()
		{
			super();
		}

		public function get results():ArrayCollection
		{
			return _results;
		}

		public function set results(value:ArrayCollection):void
		{
			_results = value;
		}

	}
}