package com.maven	
{
	import flash.events.*;
	import flash.display.*;
	import flash.utils.*;
	import flash.ui.Keyboard;
	
	import com.maven.nav.GestureNav;
	import com.foxaweb.ui.gesture.*;
	
	import caurina.transitions.*;
	
	/**
	 * ...
	 * @author Won J. You
	 */
	public class  GestureFoxy extends MovieClip
	{
		
		private var _nav:MouseGesture;
		
		private var _textMC:MovieClip;
		
		public var fiab_mc:MovieClip;
		public var draw_mc:MovieClip;
		
		private var timer:Timer;
		
		private var totalBoxes:Number = 100;
		private var _currID:Number = 0;
		private var _currRow:Number = 0;
			
		private var _lastArea:Number = 0;  //The area of the container when there was a drawing within it
		private var _lastWidth:Number = 0;
		private var _lastHeight:Number = 0;
		
		private var _boxArray:Array;
		
		private var _increment:Number = 1;
		
		private var topLimit:Number = 0;
		private var bottomLimit:Number = 0;
		private var rightLimit:Number = 0;
		private var leftLimit:Number = 0;
		
		private var goalX:Number = 0;
		private var goalY:Number = 0;
		
		private var rowLimit:Number = 9;
		private var rowCount:Number = 0;
		
		private var _holderMC:MovieClip;
		
		private var _animTime:Number = 0.6;
		
		private static const DEFAULT_LEN:Number = 300;
		private static const DEFAULT_AREA:Number = 32000;
		
		private static const BOX_WIDTH:Number = 300;
		private static const BOX_HEIGHT:Number = 300;
		
		public function GestureFoxy() : void
		{
			trace("GestureFoxy constructed");
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init ( evt:Event = null ) : void
		{
			trace("init called");
			
			//  Stage settings
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;				
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initBoxes();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyClick);			
			
			stage.addEventListener(Event.RESIZE, reposition);
			
			_nav =new MouseGesture(stage);
			
			//_nav.addGesture("ROTATE_90_CCW", "43210");
			//_nav.addGesture("ROTATE_90_CW", "01234");
			
			_nav.addGesture("MOVE_LL", "3");
			_nav.addGesture("MOVE_LR", "1");
			_nav.addGesture("MOVE_UL", "5");
			_nav.addGesture("MOVE_UR", "7");
			
			_nav.addGesture("MOVE_LEFT", "4");
			_nav.addGesture("MOVE_LEFT", "31");
			
			_nav.addGesture("MOVE_RIGHT", "0");
			_nav.addGesture("MOVE_RIGHT", "13");
			
			_nav.addGesture("MOVE_UP", "6");
			_nav.addGesture("MOVE_UP", "71");
			
			_nav.addGesture("MOVE_DOWN", "2");
			_nav.addGesture("MOVE_DOWN", "17");
			
			_nav.addEventListener(GestureEvent.GESTURE_MATCH, matchHandler);
			_nav.addEventListener(GestureEvent.NO_MATCH, noMatchHandler);
			
			_nav.addEventListener(GestureEvent.START_CAPTURE, startHandler);
			_nav.addEventListener(GestureEvent.STOP_CAPTURE, stopHandler);
			

		}
		
		private function initBoxes() : void
		{
			trace("initBoxes called");
			
			_holderMC = new MovieClip();
			
			addChild(_holderMC);
			
			_textMC = new textMC();
			_textMC.x = 5;
			_textMC.y = 5;
			addChild(_textMC);
			
			fiab_mc = new MovieClip();
			
			addChild(fiab_mc);
			
			draw_mc = new MovieClip();
			
			addChild(draw_mc);			
			
			var xPos:Number  =  0;
			var yPos:Number  =  0;
			var counter:Number = 0;
			
			_boxArray = new Array();
			
			for (var i:Number = 0; i < totalBoxes; i++) {
				
				var mc:MovieClip = new boxMC();
				mc.ID = i;
				mc.rowCount = rowCount;
				mc.x = xPos;
				mc.y = yPos;
				
				mc.displayTxt.text = i;
				
				_holderMC.addChild(mc);
				
				_boxArray.push(mc);
				
				if (counter >= rowLimit) {
					counter = 0;
					xPos = 0;
					yPos += BOX_HEIGHT;
					rowCount++;
				}
				else {
					xPos += BOX_WIDTH;
					counter++;
				}
				
				//mc.addEventListener(MouseEvent.CLICK, onClick);
				
			}
			
			rightLimit = -( _holderMC.width - BOX_WIDTH);
			bottomLimit = -(_holderMC.height - BOX_HEIGHT);
			
			trace("rightLimit: " + rightLimit);
			trace("bottomLimit: " + bottomLimit);
		}
		
		
		private function onKeyClick(evt:KeyboardEvent) : void
		{
			trace("onKeyClick called");
			
			switch (evt.keyCode) {
				case Keyboard.RIGHT:
					moveRight();
					break;
				case Keyboard.LEFT:
					moveLeft();
					break;
				case Keyboard.UP:
					moveUp();
					break;
				case Keyboard.DOWN:
					moveDown();
					break;
				default:
					trace("Unknown key");
					break;
				
			}
			
		}
		
		
		/**
		* match gesture handler
		*/
		protected function matchHandler(e:GestureEvent) : void
		{
			//trace("matchHandler called");
			trace("e.datas: " + e.datas);
			draw_mc.graphics.clear();
			
			_textMC.statusMC.displayTxt.text = "";
			
			switch (e.datas) {
				case "ROTATE_90_CW" :
					rotate(90);
					break;
					
				case "ROTATE_90_CCW" :
					rotate(-90);
					break;
				
				case "MOVE_LL" :

					diagonal( -1, -1);
					break;
					
				case "MOVE_LR" :
					diagonal( 1, -1);
					break;

				case "MOVE_UR" :
					diagonal( 1, 1);
					break;
					
				case "MOVE_UL" :
					diagonal( -1, 1);
					break;
					
				case "MOVE_LEFT":
					moveLeft();
					break;
					
				case "MOVE_RIGHT":
					moveRight();
					break;
					
				case "MOVE_UP":
					moveUp();
					break;
					
				case "MOVE_DOWN":
					moveDown();
					break;
					
				default:
					trace("Unknown case");
					break;
					
			}
			
			//_textMC.statusMC.displayTxt.text = e.datas;

		}
		
		/**
		* no match handler 
		*/	
		protected function noMatchHandler(e:GestureEvent):void{
			draw_mc.graphics.clear();
		}
		
		/**
		* start capturing phase handler
		*/
		protected function startHandler(e:GestureEvent):void{
			
			fiab_mc.alpha=1;
			
			draw_mc.graphics.clear();
			draw_mc.alpha=1;
			draw_mc.graphics.lineStyle(1, 0xFF0000);
			draw_mc.graphics.moveTo(mouseX, mouseY);
			addEventListener(Event.ENTER_FRAME, capturingHandler);
		}
		
				
		/**
		* stop capturing phase handler
		*/
		protected function stopHandler(e:GestureEvent) : void 
		{			
			removeEventListener(Event.ENTER_FRAME, capturingHandler);
			
			_lastArea = _lastWidth * _lastHeight;
		}
		
		/**
		* capturing handler
		*/
		protected function capturingHandler(e:Event) : void
		{
			//trace("draw_mc.width: " + draw_mc.width);
			//trace("draw_mc.height: " + draw_mc.height);
			
			draw_mc.graphics.lineTo(mouseX, mouseY);
			
			_lastWidth = draw_mc.width;
			_lastHeight = draw_mc.height;
			
		}

		public function calcScale() : Number
		{
			//trace("\ncalcScale called");
			
			//trace("_lastArea: " + _lastArea);
			
			var scaleFactor:Number = Math.round(_lastArea / DEFAULT_AREA);
			
			scaleFactor = Math.max(1, scaleFactor);
			
			trace("scaleFactor: " + scaleFactor);
			
			return scaleFactor;
		}
		
		private function calcLen() : Number
		{
			trace("calcLen called");
			
			var len:Number = Math.sqrt(_lastWidth*_lastWidth + _lastHeight*_lastHeight);
			
			trace("len: " + len);
			
			var scaleFactor:Number = Math.round(len / DEFAULT_LEN);
			
			scaleFactor = Math.max(1, scaleFactor);
			
			trace("scaleFactor: " + scaleFactor);
			
			return scaleFactor;
			
		}
		
		//___________________________________________________________Directional handlers
		
		private function rotate( deg:Number ) : void
		{
			trace("rotate called");
			trace("deg: " + deg);

			var goalX:Number;
			var goalY:Number;
			
			var tempRotation:Number = _holderMC.rotation + deg;
			
			trace("tempRotation: " + tempRotation);
			
			if (tempRotation == 0) {
				goalX = 0;
				goalY = _holderMC.height;
			}
			else if ( tempRotation < 0) {
				goalX = _holderMC.x;
				goalY = _holderMC.height;
			}
			else {
				goalX = _holderMC.width;
				goalY = 0;
			}
			
			Tweener.addTween(_holderMC, {rotation:deg, x:goalX, y:goalY,  time: _animTime, transition:"easeOutQuad"} );
		}		
		
		private function diagonal( dirX:Number, dirY:Number) : void
		{
			trace("diagonal called");
			
			trace("dirX: " + dirX);
			trace("dirY: " + dirY);			
			
			var currX:Number = goalX;
			var currY:Number = goalY;
			
			var len:Number = calcLen();
			
			goalX = currX + -(len*dirX) * BOX_WIDTH;
			goalY = currY + (len* dirY) *  BOX_HEIGHT;
			
			if (goalX > leftLimit) {
				goalX = leftLimit;
			}			
			if (goalX < rightLimit) {
				goalX = rightLimit;
			}
			
			if (goalY > topLimit) {
				goalY = topLimit;
			}
			if (goalY < bottomLimit) {
				goalY = bottomLimit;
			}
			
			trace("goalX: " + goalX);
			trace("goalY: " + goalY);
			
			Tweener.addTween(_holderMC, {x:goalX, y:goalY, time: _animTime, transition:"easeOutQuad"} );
		}
		
		private function moveUp(evt:Event=null) : void
		{
			trace("moveUp called");
			
			_increment = calcScale();
			
			var tempNum:Number = _currRow - _increment;
			
			if (tempNum < 0) {
				trace("at the top");
				_currRow = 0;
			}
			else {
				_currRow = tempNum;
			}			
			
			goalY = -_currRow * BOX_HEIGHT;
			
			Tweener.addTween(_holderMC, {y:goalY, time: _animTime, transition:"easeOutQuad"} );
		}
		
		private function moveDown(evt:Event = null) : void
		{
			trace("moveDown called");
			
			_increment = calcScale();
			
			var tempNum:Number = _currRow + _increment;
			
			if (tempNum >= rowCount) {
				trace("at the bottom");
				_currRow = rowCount - 1;
			}
			else {
				_currRow = tempNum;
			}			
			
			goalY = -_currRow * BOX_HEIGHT;
			
			Tweener.addTween(_holderMC, { y:goalY, time:_animTime, transition:"easeOutQuad"} );
		}
		
		private function moveLeft(evt:Event = null) : void
		{
			trace("moveLeft called");
		
			_increment = calcScale();
			
			var tempNum:Number = _currID - _increment;
			
			if (tempNum < 0){
				trace("at the left edge");
				_currID = 0;
			}
			else {
				_currID = tempNum;
			}
			
			goalX = -_currID * BOX_WIDTH;
			
			Tweener.addTween(_holderMC, { x:goalX, time:_animTime, transition:"easeOutQuad"} );
		}
		
		private function moveRight(evt:Event=null) : void
		{
			trace("moveRight called");
			
			_increment = calcScale();		
			
			var tempNum:Number = _currID + _increment;
			
			if (tempNum > rowLimit) {
				trace("prevent overrun");
				_currID = rowLimit;
			}			
			else if (tempNum%(rowLimit+1) == 0){
				trace("at the end");
			}
			else {
				_currID = tempNum;
			}			
			
			goalX = -_currID * BOX_WIDTH;
			
			Tweener.addTween(_holderMC, { x:goalX, time:_animTime, transition:"easeOutQuad"} );
		}
		
		private function reposition( evt:Event = null ) : void
		{
			trace("reposition called");
			

		}
	}
	
}