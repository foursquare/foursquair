////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Mar 7, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views.search
{
	import mx.collections.ArrayCollection;
	
	import spark.components.List;
	import spark.components.SkinnableContainer;
	
	public class SearchViewBase extends SkinnableContainer
	{
		
		public var searchList:List;
		private var _results:ArrayCollection;
		private var resultsChanged:Boolean;
		
		public function SearchViewBase()
		{
			super();
		}
		
		override protected function commitProperties() : void{
			super.commitProperties();
			if(resultsChanged){
				resultsChanged = false;
				searchList.dataProvider = _results;
			}
		}

		public function get results():ArrayCollection
		{
			return _results;
			
		}

		public function set results(value:ArrayCollection):void
		{
			_results = value;
			resultsChanged = true;
			invalidateProperties();
		}

	}
}