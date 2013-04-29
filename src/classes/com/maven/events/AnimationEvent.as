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
	
	public class AnimationEvent extends Event{
		public static const ANIMATE_IN        : String = "animateIn";
		public static const ANIMATE_OUT       : String = "animateOut";
		public static const ANIMATE_START     : String = "animateBegin";
		public static const ANIMATE_IN_START  : String = "animateInStart";
		public static const ANIMATE_OUT_START : String = "animateOutStart";
		public static const ANIMATE_FINISH    : String = "animateFinish";
		public static const ANIMATE_COMPLETE    : String = "animateComplete";
		public static const ANIMATE_CANCEL    : String = "animateCancel";
		
		
		public var clip : *;
		
		public function AnimationEvent($type:String, $clip:* = null){
			super($type);
			clip = $clip;
		}

	}
}