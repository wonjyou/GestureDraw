// 
// Maven Interactive
// 
// Copyright (c) 2008 Won You, All rights reserved.
// 
// THIS FILE AND THE SOFTWARE OF WHICH IT IS A CONSTITUENT ("THE SOFTWARE") IS
// PROPRIETARY AND CONFIDENTIAL.  YOU MAY ONLY USE THE SOFTWARE IN ACCORDANCE
// WITH ITS LICENSE AND ANY APPLICABLE AGREEMENTS.
// 
// Unless required by applicable law or agreed to in writing, The Software
// is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied.
// 
// Development by Won J. You
// maven-interactive.com
// 

package com.maven.events{
	
	import flash.events.Event;
	
	public class SiteEvent extends Event{
		public static const LOAD_FINISH         : String = "loadFinish";
		public static const LOAD_START         : String = "loadStart";
		public static const LOAD_COMPLETE         : String = "loadComplete";
		
		public static const OVER_SOUND         : String = "overSound";
		public static const OFF_SOUND         : String = "offSound";
		
		public static const SOUND_ON         : String = "soundOn";
		public static const SOUND_OUT         : String = "soundOut";
		
		public static const RECORD_START : String = "recordStart";
		public static const RECORD_STOP : String = "recordStop";
		
		public static const MOVE_UP         : String = "moveUp";
		public static const MOVE_DOWN         : String = "moveDown";
		public static const MOVE_LEFT         : String = "moveLeft";
		public static const MOVE_RIGHT         : String = "moveRight";
		
		public static const NEXT_PHOTO         : String = "nextPhoto";
		public static const PREV_PHOTO         : String = "prevPhoto";
		
		public static const NEXT_PROJECT         : String = "nextPhoto";
		public static const PREV_PROJECT         : String = "prevProject";
		
		public static const CLOSE_DETAIL      : String = "closeDetail";
		
		public static const XML_PARSED         : String = "xmlParsed";
		
		public static const SHOW_OVERLAY  : String = "showOverlay";
		public static const HIDE_OVERLAY  : String = "hideOverlay";
		
		public static const JUMP_INIT  : String = "jumpInit";

		public static const STAGE_RESIZE  : String = "resize";

		
		public function SiteEvent($type:String){
			
			//trace("SiteEvent");
			super($type);			
		};

		public override function clone():Event{
			return new SiteEvent(type);
		};
	};
};