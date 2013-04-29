
package com.maven.nav
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.Timer;
		
	import com.maven.events.*;
	
	/**
	 * ...
	 * @author Won J. You
	 */
	public class GestureNav extends MovieClip
	{
		private var _container:MovieClip;
		private var _timer:Timer;
		private var _drawTimer:Timer;
		
		private var _segmentArray:Array;
		
		private var _startPoint:Point;
		private var _endPoint:Point;
		
		private var _pointsArray:Array;
		
		private var _timeStep:Number = 60; //it's best if this isn't too low. 
		private var _drawStep:Number = 50;
		
		private var _lastArea:Number = 0;  //The area of the container when there was a drawing within it
		
		private static const MARGIN_ERROR:Number = 5;		
		private static const DEFAULT_AREA:Number = 32000;
		
		
		public function GestureNav() : void
		{
			trace("GestureNav constructed");
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init( evt:Event = null) : void
		{
			trace("GestureNav: init called");
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_pointsArray = new Array();
			
			_startPoint = new Point(mouseX, mouseY);
			
			_container = new MovieClip();
			
			addChild(_container);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, recordStart);
			stage.addEventListener(MouseEvent.MOUSE_UP, recordStop);			
			
			_timer = new Timer(_timeStep);
            _timer.addEventListener(TimerEvent.TIMER, capturePoints);

			_drawTimer = new Timer(_drawStep);
			_drawTimer.addEventListener(TimerEvent.TIMER, drawStart);
			
		}
		
		private function recordStart( evt:Event ) : void
		{
			//trace("recordStart called");
			
			_pointsArray = new Array();
			
			_container.graphics.lineStyle(1, 0xFF0000);
			_container.graphics.moveTo(stage.mouseX, stage.mouseY);
			
			_startPoint = new Point(stage.mouseX, stage.mouseY);
			
			_timer.start();
			_drawTimer.start();			
		}
		
		private function capturePoints(evt:TimerEvent) : void
		{			
			_pointsArray.push(new Point(stage.mouseX, stage.mouseY));
		}
		
		private function recordStop( evt:Event) : void
		{
			trace("recordStop called");
			
			//trace("_container.width: " + _container.width);
			//trace("_container.height: " + _container.height);
			
			_lastArea = _container.width * _container.height;
			
			_container.graphics.clear();
			
			_endPoint = new Point(stage.mouseX, stage.mouseY);
			
			_timer.stop();
			_drawTimer.stop();
			
			matchShape();
		}		
		
		public function drawStart(evt:TimerEvent) : void
		{
			//trace("drawStart called");

			_container.graphics.lineTo(stage.mouseX, stage.mouseY);			
			
		}
		
		private function matchShape( evt:Event = null ) : void
		{
			trace("matchShape called");
			
			_segmentArray = new Array();
			
			var max:Number = _pointsArray.length;
			var i:Number;
			
			/*
			for (i= 0; i < max; i++) {
				trace(i + ": " + _pointsArray[i].x + ", " + _pointsArray[i].y);			
			}
			*/
			
			//reset i
			i = 0;
			
			var prevDelta:Array = new Array(0, 0);
			var currDelta:Array = new Array(0, 0);
			
			var lastPoint:Point;
			
			lastPoint = _startPoint;
			
			var tempArray:Array = new Array();
			tempArray.push(lastPoint);
			
			//currDelta = comparePoints(_pointsArray[0], _pointsArray[1]);
			
			while (i < max - 1) {
				
				currDelta = comparePoints(_pointsArray[i], _pointsArray[i + 1]);
				
				if ((currDelta[0] != 0 && currDelta[0] != prevDelta[0]) || 
					(currDelta[1] != 0 && currDelta[1] != prevDelta[1]) ) {
				
					tempArray.push(_pointsArray[i + 1]);
				}
				
				prevDelta = currDelta;
				
				i++;
			}
			
			max = tempArray.length;
			
			if (max <= 1 ) {
				trace("ERROR: We don't have enough points in the segment");
				return;
			}
			
			trace("total points in segments: " + max);
			
			i = 0;
			
			while (i < max-1){
				var obj:Object = new Object();
				
				obj.startPoint = tempArray[i];
				obj.endPoint = tempArray[i + 1];
				
				obj.dx = obj.endPoint.x - obj.startPoint.x;
				obj.dy = obj.endPoint.y - obj.startPoint.y;
				
				if (obj.dx >0 && obj.dy>0) {
					obj.dir = "tr";
				}
				else if (obj.dx > 0 && obj.dy < 0) {
					obj.dir = "br";
				}
				else if (obj.dx < 0 && obj.dy > 0) {
					obj.dir = "tl";
				}
				else if (obj.dx < 0 && obj.dy < 0) {
					obj.dir = "bl";
				}				
				
				_segmentArray.push(obj);
				
				//trace("_segmentArray[" + i + "].dx: "  + _segmentArray[i].dx);
				//trace("_segmentArray[" + i + "].dy: "  + _segmentArray[i].dy);
				//trace("_segmentArray[" + i + "].dir: "  + _segmentArray[i].dir);
				
				i++;
			}
			
			
			compareSegments();

		}
		
		private function comparePoints (pt1:Point, pt2:Point) : Array
		{
			//trace("comparePoints called");
			//trace("pt1: " + pt1.x + ", " + pt1.y);
			//trace("pt2: " + pt2.x + ", " + pt2.y);
			
			var dx:Number = pt2.x - pt1.x;
			var dy:Number = pt2.y - pt1.y;
			
			if (dx > 0) {
				dx = 1;
			}
			else if ( dx < 0){
				dx = -1;
			}
			else {
				dx = 0;
			}
			
			if (dy > 0) {
				dy = 1;
			}
			else if (dy<0){
				dy = -1;
			}
			else {
				dy = 0;
			}
			
			//trace("[" + dx + ", " + dy + "]");
			return [dx, dy];
			
		}
		
		private function compareSegments() : void
		{
			trace("compareSegments called");

			var dir1:String;
			var dir2:String;
			
			if (_segmentArray.length == 1) {
				dir1 = _segmentArray[0].dir;
				
				if (dir1 == "tr" || dir1 == "br" ) {
					moveRight() 
				}
				else if ( dir1 == "tl" || dir1 == "bl") {
					moveLeft();
				}
				
			}			
			else if (_segmentArray.length >= 2) {   //currently set to ignore segments past 2
				
				dir1 = _segmentArray[0].dir;
				dir2 = _segmentArray[1].dir;
				
				trace("dir1: " + dir1);
				trace("dir2: " + dir2);
				
				if (dir1 == "bl" && dir2 == "br") {
					moveLeft();
				}
				else if (dir1 == "br" && dir2 == "bl") {
					moveRight() 
				}
				else if (dir1== "tr" && dir2=="tl"){
					moveRight() 
				}
				else if (dir1 == "tl" && dir2 == "tr") {
					moveLeft();
				}
				else if (dir1 == "tr" && dir2 == "br") {
					moveUp();
				}
				else if (dir1 == "br" && dir2 == "tr") {
					moveDown();
				}
				else if (dir1 == "tl" && dir2 == "bl") {
					moveUp();
				}
				else if (dir1 == "bl" && dir2 == "tl") {
					moveDown();
				}
			}
		}
		
		//____________________________________________________________ Directional Event Dispatch
		
		private function moveRight() : void
		{
			trace("GestureNav: moveRight called");
			
			dispatchEvent(new SiteEvent(SiteEvent.MOVE_RIGHT));
		}
	
		private function moveLeft() : void
		{
			trace("GestureNav: moveLeft called");
			
			dispatchEvent(new SiteEvent(SiteEvent.MOVE_LEFT));
		}
		
		private function moveUp() : void
		{
			trace("GestureNav: moveUp called");
			
			dispatchEvent(new SiteEvent(SiteEvent.MOVE_UP));
		}
		
		private function moveDown() : void
		{
			trace("GestureNav: moveDown called");
			
			dispatchEvent(new SiteEvent(SiteEvent.MOVE_DOWN));
		}
		
		
		//____________________________________________________________Calculate area of the shape
		
		public function calcScale() : Number
		{
			trace("\ncalcScale called");
			
			/*
			var max:Number = _pointsArray.length;			
			var i:Number;
			
			var leftX:Number = 0;
			var rightX:Number = 0;
			
			var topY:Number = 0;
			var bottomY:Number = 0;
			
			var tempArray:Array = new Array();			

			tempArray = _pointsArray.slice();
			
			tempArray.sort();
			
			trace("left Point: " + tempArray[0]);
			
			tempArray.sortOn("y");
			
			for (i= 0; i < max; i++) {
				trace("tempArray[i]: "+ tempArray[i]);
			}
			
			*/
			
			trace("_lastArea: " + _lastArea);
			
			var scaleFactor:Number = Math.round(_lastArea / DEFAULT_AREA);
			
			scaleFactor = Math.max(1, scaleFactor);
			
			trace("scaleFactor: " + scaleFactor);
			
			return scaleFactor;
		}
		
		//____________________________________________________________ Getters and Setters
		
		public function get pointsArray() : Array
		{
			return _pointsArray;
		}
		
	}
	
}