
package com.maven.ui
{
    import flash.display.*;
    import flash.events.*;
	import flash.geom.*;

	
	import com.maven.events.*;

    public class Slider extends MovieClip
    {
       private var _host:MovieClip;

	   private var goalPos:Number = 0;
	   private var marginError:Number = -1;
		
		private var _rect:Rectangle;
		
		//________________________________________________________________ Constructor
		
		public function Slider( $host:MovieClip)
        {
			trace("\nSlider constructed");			
			
			try{				
				_host = $host;
				
				init();
			}
			catch(e:Error){
				trace("Error: failed at Slider with " + e);
			}
		}
	
		private function init() : void 
		{
			trace("\nSlider: init called");
			//trace(_contentMC);

			_host.dragMC.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_host.dragMC.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_host.dragMC.addEventListener(Event.MOUSE_LEAVE, onOut);
			
			_host.dragMC.addEventListener(MouseEvent.MOUSE_DOWN, initDrag);			
			_host.dragMC.addEventListener(MouseEvent.MOUSE_UP, removeDrag);
			_host.dragMC.addEventListener(Event.MOUSE_LEAVE, removeDrag);
			
			_host.dragMC.buttonMode = true;
			_host.dragMC.mouseChildren = false;
			
			_host.trackMC.addEventListener(MouseEvent.CLICK, trackClick);
			_host.trackMC.buttonMode = true;
			
			setContentClip();
			
		}
		
		private function onOver( evt:Event = null ) : void
		{
			trace("onOver called");
			
			//TweenLite.to(_host.dragMC, 0.4, {tint:0xfffffff});
		}
		
		private function onOut( evt:Event = null ) : void
		{
			trace("onOut called");
			//TweenLite.to(_host.dragMC, 0.4, {tint:null});
		}
		
		private function trackClick( evt:Event = null ) : void
		{
			goalPos = Math.min((_host.trackMC.width - _host.dragMC.width), Math.max(0, (_host.mouseX - (_host.dragMC.width / 2))));
			
			_host.dragMC.x = goalPos;
				
		//	TweenLite.to(_host.SliderMC.dragMC, 0.6, {y:goalPos});
			
			slideToCurrent();
		
		}
		
		public function onMouseWheel ( evt:MouseEvent ) : void
		{
			trace("onMouseWheel called");
			
			if (_host.dragMC.visible != false){
				if (evt.delta <=0 ){
					scrollDown();
				}
				else if (evt.delta >= 0){
					scrollUp();
				}
			}
		}
		
		private function initDrag(evt:Event = null) : void
		{
			trace("initDrag called");
			_rect = new Rectangle(_host.trackMC.x, _host.trackMC.y, (_host.trackMC.x + _host.trackMC.width - _host.dragMC.width), _host.trackMC.y);
			
			_host.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);		
			
			_host.dragMC.startDrag( false, _rect );
			watchScroll(); 	
		}

		public function setDragX( $xPos:Number ) : void
		{
			trace("setDragX called");
			trace("$xPos: " + $xPos);
			
			_host.dragMC.x = $xPos;
		}
		

		private function scrollUp( evt:Event = null) : void
		{
			 //trace("scrollUp called");
			 
			 var scroll_increment:Number = 20;
			 var trackLimit:Number = _host.trackMC.x;
			 
			if (_host.dragMC.x > trackLimit + scroll_increment){
				_host.dragMC.x -= Math.round(scroll_increment);
				slideToCurrent();
			}
			else{
				_host.dragMC.xy = Math.round(trackLimit);
				slideToCurrent();
			}			
	   }
		
	  private function scrollDown(evt:Event = null ) : void
	  {
			//trace("scrollDown called");
			
			 var scroll_increment:Number = 20;
			 var trackLimit:Number = _host.trackMC.x + _host.trackMC.width - _host.dragMC.width;
			 
			if (_host.dragMC.x < trackLimit-scroll_increment){
				_host.dragMC.x += Math.round(scroll_increment);
			}
			else{
				_host.dragMC.x = Math.round(trackLimit);
			}
			
			slideToCurrent();
			
	  }	

	private function onUp(evt:MouseEvent) : void
	{	
		
		removeDrag();
		_host.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
	
	}
		
		private function removeDrag( evt:Event = null ) : void
		{
			
			_host.dragMC.stopDrag();  
			endScroll();  
		}
		
	  public function setContentClip() : void 
	  {
		  trace("setContentClip called");

			initContent();

	  }
	  
	  private function initContent() : void
	  {    

			_host.dragMC.x = Math.round(_host.trackMC.x);    
	  }
	  
	  
	  public function scrollToTop( evt:Event = null ) : void 
	  {    
		_host.dragMC.x = Math.round(_host.trackMC.x);
		slideToCurrent();
	  }
	  
	  
	 private function slideToCurrent( evt:Event = null ) : void 
	 {
		var dy:Number;
		var diff:Number;
		var offSet:Number = 0;
		var scrProp = (_host.dragMC.x - offSet) / ( _host.trackMC.width - _host.dragMC.width);
		var scrPos  = scrProp;
	
		dispatchEvent(new UpdateEvent (UpdateEvent.ITEM_UPDATE, scrPos));
		
		//_contentMC.scaleX = _contentMC.scaleY = scrPos;
		
		
	 }	  
	  
	 private function watchScroll() : void 
	 {		
		
		_host.addEventListener(Event.ENTER_FRAME, slideToCurrent);
		
	 }
		 
	 private function endScroll() : void 
	 {
		_host.removeEventListener(Event.ENTER_FRAME, slideToCurrent);
	 }
	  
	}
}