package com.foursquare.util{
	public class TimeAgoInWords{
		public static function format(toTime:Date, fromTime:Date=null, includeSeconds:Boolean=true):String{
		  if(fromTime==null){
		  	fromTime = new Date();
		  }
		  var fromSeconds:Number = fromTime.getTime();
		  var toSeconds:Number = toTime.getTime();
		  var distanceInSeconds:Number = Math.round(Math.abs(fromSeconds - toSeconds) / 1000)
		  var distanceInMinutes:Number = Math.round(distanceInSeconds / 60)
		  if (distanceInMinutes <= 1) {
		    if (!includeSeconds)
		      return (distanceInMinutes == 0) ? 'less than a minute' : '1 minute'
		    if (distanceInSeconds < 5)
		      return 'less than 5 seconds'
		    if (distanceInSeconds < 10)
		      return 'less than 10 seconds'
		    if (distanceInSeconds < 20)
		      return 'less than 20 seconds'
		    if (distanceInSeconds < 40)
		      return 'half a minute'
		    if (distanceInSeconds < 60)
		      return 'less than a minute'
		    return '1 minute'
		  }
		  if (distanceInMinutes < 45)
		    return distanceInMinutes + ' minutes'
		  if (distanceInMinutes < 90)
		    return "about 1 hour" 
		  if (distanceInMinutes < 1440)
		    return "about " + (Math.round(distanceInMinutes / 60)) + ' hours'
		  if (distanceInMinutes < 2880)
		    return "1 day" 
		  if (distanceInMinutes < 43200)
		    return (Math.round(distanceInMinutes / 1440)) + ' days'
		  if (distanceInMinutes < 86400)
		    return "about 1 month" 
		  if (distanceInMinutes < 525600)
		    return (Math.round(distanceInMinutes / 43200)) + ' months'
		  if (distanceInMinutes < 1051200)
		    return "about 1 year" 
		  return "over " + (Math.round(distanceInMinutes / 525600)) + ' years'

		}
	}
}