
package com.maven.events{
	
	import flash.events.Event;
	
	public class UpdateEvent extends Event{

		public static const ITEM_UPDATE  : String = "itemUpdate";
		
		public var arg:*;
		
		public function UpdateEvent($type:String, ... $arg:*){
			
			//trace("UpdateEvent");
			super($type);
			arg = $arg;
		};

		public override function clone():Event{
			return new UpdateEvent(type, arg);
		};
	};
};