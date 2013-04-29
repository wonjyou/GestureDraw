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
	
	public class PhotoEvent extends Event{

		public static const PHOTO_UPDATE  : String = "photoUpdate";
		public static const NEXT_PHOTO  : String = "nextPhoto";
		public static const PREV_PHOTO  : String = "prevPhoto";
		
		public var arg:*;
		
		public function PhotoEvent($type:String, ... $arg:*){
			
			//trace("PhotoEvent");
			super($type);
			arg = $arg;
		};

		public override function clone():Event{
			return new PhotoEvent(type, arg);
		};
	};
};