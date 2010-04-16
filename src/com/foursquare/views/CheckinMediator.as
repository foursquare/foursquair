////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 31, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.UserEvent;
	import com.foursquare.events.VenueEvent;
	import com.foursquare.models.Constants;
	import com.foursquare.models.vo.UserVO;
	import com.foursquare.views.checkins.CheckinView;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import mx.collections.ArrayCollection;

	import org.robotlegs.mvcs.Mediator;

	public class CheckinMediator extends Mediator
	{

		[Inject]
		public var checkinView : CheckinView;

		private var _checkins : ArrayCollection;

		/**
		 * flag for when to start polling
		 */
		private var _firstRead : Boolean = true;
		/**
		 * delay between timer events in milliseconds
		 */
		private var _pollInterval : int = Constants.defaultPollInterval;

		private var timer : Timer;

		public function CheckinMediator()
		{
			super();
		}

		override public function onRegister() : void
		{
			eventMap.mapListener(checkinView, CheckinEvent.READ, getCheckins);
			eventMap.mapListener(checkinView, UserEvent.GET_DETAILS, getUserDetails);
			eventMap.mapListener(checkinView, VenueEvent.GET_VENUE_DETAILS, getVenueDetails);

			getCheckins();
		}

		public function startPolling() : void
		{
			if (!timer)
			{
				timer = new Timer(_pollInterval);
				timer.addEventListener(TimerEvent.TIMER, getCheckins);
			}
			timer.start();
		}

		public function stopPolling() : void
		{
			timer.stop();
		}

		public function setUserDetails(userVO : UserVO) : void
		{
			checkinView.openUserDetails(userVO);
		}

		public function set checkins(value : ArrayCollection) : void
		{
			_checkins = value;
			checkinView.checkins = _checkins;

			if (_firstRead)
			{
				_firstRead = false;
				startPolling();
			}
		}

		public function get checkins() : ArrayCollection
		{
			return _checkins;
		}

		private function getCheckins(event : TimerEvent=null) : void
		{
			eventDispatcher.dispatchEvent(new CheckinEvent(CheckinEvent.READ));
		}

		private function getUserDetails(event : UserEvent) : void
		{
			eventDispatcher.dispatchEvent(event.clone());
		}

		private function getVenueDetails(event : VenueEvent) : void
		{
			eventDispatcher.dispatchEvent(event.clone());
		}

		public function get firstRead() : Boolean
		{
			return _firstRead;
		}

		public function set pollInterval(interval : int) : void
		{
			_pollInterval = interval;
			timer.delay = _pollInterval;
			timer.reset();
		}

		public function get pollInterval() : int
		{
			return _pollInterval;
		}
	}
}