
package com.maven.draw
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.utils.*;
	import flash.geom.*;
	
	/**
	 * ...
	 * @author Won J. You
	 */
	public class  CamDraw extends MovieClip
	{
		private var _host:MovieClip;
		
		private var video:Video;
		
		private var intervalId:uint;
		
		private var output:Bitmap;
		
		private var camInit:Boolean = false;
		private var cam:Camera;
		
		private var camFPS:Number = 30;		
		private var camW	:Number 	= 320;
		private var camH	:Number 	= 240;
		
		private var now	:BitmapData;
		private var out	:BitmapData;
		private var diff	:BitmapData;
		private var prev	:BitmapData;
		
		private var checkY:Array;
		
		
		public function CamDraw() : void
		{
			trace("CamDraw constructed");
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event = null) : void
		{
			trace("CamDraw: init called");
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_host = this;
			
			initCam();
		}
		
	
		public function initCam ( evt:Event = null ) : void
		{
			trace("initCam called");
		
			if (camInit == true){
				trace("The motion cam is already initialized");
				return;
			}
			else{
				camInit = true;
			}

			try{				
				
				cam = Camera.getCamera();
				cam.setMode(camW, camH, camFPS);
				
				if (cam == null) {
					
				} 
				else {
					
					video = new Video(camW, camH);

					video.attachCamera(cam);
					video.deblocking = 2; 
					
					_host.addChild(video);
					
					//video.width = camW; 
					//video.height = camH; 
					
					video.x = 0; 
					video.y = 0; 
					
					trace("motioncamming");
					
					diff = new BitmapData(video.width, video.height);
					prev = new BitmapData(video.width, video.height);
					
					now = new BitmapData(video.width, video.height);
					out = new BitmapData(video.width, video.height);
	
					output = new Bitmap(out)
					_host.addChild(output);
					output.x = 0; 
					output.y = 0;
					
					intervalId = setInterval(render, 100);
					
					/*
					//creating array of y values to check in left and right areas
					checkY = new Array();
					checkYClick = new Array();
					for (var i:int = 0; i < density; i++) {
						checkY[i] = video.height/density * (i+1);
						checkYClick[i] = video.width/3 + (i+1)/15;
					}
					*/					
				
				}
			}
			catch (e:Error){
				trace("Error: failed at MotionCam with error " + e);
			}
		}
		

		private function render () : void 
		{
		
			if (!cam.currentFPS) return;
			
			now.draw(video);
			diff.draw(video);
			diff.draw(prev, null, null, "difference");
			
			out.fillRect(new Rectangle(0,0, diff.width, diff.height ),0xFF000000);
			out.threshold(diff,new Rectangle(0,0, diff.width, diff.height), new Point(0,0),'>',0xff111111,0xffffffff);
			prev.draw(video);
			/*		
			checkTimer.addEventListener(TimerEvent.TIMER, renderTick);
			checkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			checkTimer.reset();
			checkTimer.start();
			*/
		}
		
	}
	
}