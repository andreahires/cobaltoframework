
// started 3.2.2010
// andrea
// todo:
//        set up the ease from outside and animation things
//         use signals for all the events so it's easier to remove
//         study how not to cut the letter of a word
//         move function according to new equation and time or standard

// questions : what if i dont want the rail?

package com.cobalto.components.slider
{
	import com.cobalto.api.ISlider;
	
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	import gs.*;
	import com.greensock.easing.*;
	import com.pixelbreaker.ui.osx.MacMouseWheel;
	import com.cobalto.components.buttons.PrimitiveButton;
	

	
	
	public class AbstractSlider extends Sprite implements ISlider
	{
		
		// PRIVATE VARS
		private var _direction:String;
		protected var _dragButton:PrimitiveButton;
		protected var _railButton:PrimitiveButton;
		private var _pathLength:Number;
		private var _deltaWheel:Number;
		private var _percentage:Number;
		private var _objectEquation:Object;
		
		// to get from outside the coordinates of the mouse on the rai
		private var _mouseXrail:Number;
		private var _mouseYrail:Number;
		private var yOffset:Number;
		private var yMin:Number;
		private var yMax:Number;
		

		// PUBLIC VARS
		
		// CONST VARS
		public static const TRANSITION_OUT_END:String = "transition_out_end";
		public static const TRANSITION_IN_END:String = "transition_in_end";
		
		public static const DRAGBUTTON_OVER:String = "dragbutton_over";
		public static const DRAGBUTTON_OUT:String = "dragbutton_out";
		public static const DRAGBUTTON_CLICK:String = "dragbutton_click";
		
		public static const DRAGBUTTON_MOVE:String = "dragbutton_move";
		public static const DRAGBUTTON_DRAGGED:String = "dragbutton_move";
		public static const DRAGBUTTON_TARGET_REACHED:String = "dragbutton_target_reached";
		
		public static const RAILBUTTON_OVER:String = "railbutton_over";
		public static const RAILBUTTON_OUT:String = "railbutton_out";
		public static const RAILBUTTON_CLICK:String = "railbutton_click";
		
		public static const RAILBUTTON_MOVE:String = "railbutton_move";
		public static const DELTA_MOVE:String = "delta_move";
		
		//dispatchEvent(new Event(AbstractSlider.TRANSITION_OUT_,true));
		
		public function AbstractSlider(dragButton:PrimitiveButton,railButton:PrimitiveButton,objectEquation:Object,direction:String="vertical")
		{
			super();
			
			_direction = direction;
			_dragButton = dragButton;
			_railButton = railButton;
			_objectEquation = objectEquation;
			_pathLength = returnPathLength();
			
			addElements();
			
			addEventListener(Event.ADDED,addedListener);
			addEventListener(Event.REMOVED,removedListener);
		
		}
		
		public function move(perc:Number):void
		{
			
			if(_direction == "vertical")
			{
				
				_percentage = perc;
				TweenMax.to(_dragButton,_objectEquation.time,{y:perc * _pathLength,roundProps:[y],ease:_objectEquation.equation,onComplete:dispatchTargetReached});
			}
			else
			{
				
				TweenMax.to(_dragButton,_objectEquation.time,{x:perc * _pathLength,roundProps:[x],ease:_objectEquation.equation,onComplete:dispatchTargetReached});
			}
		
		}
		
		private function addedListener(e:Event):void
		{
			
			if(this.stage != null)
			{
				
				this.stage.addEventListener(Event.MOUSE_LEAVE,mouseLeave);
			}
		
		/* if ( this.stage != null )
		   {
		   MacMouseWheel.setup( this.stage );
		 } */
		
		}
		
		private function mouseLeave(e:Event):void
		{
			
			//_dragButton.hit.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			
			_dragButton.stopDrag();
		}
		
		private function removedListener(e:Event):void
		{
			
			removeAllListeners();
		
		}
		
		private function removeAllListeners():void
		{
			
			_dragButton.hit.buttonMode = false;
			//_railButton.hit.buttonMode=false;
			_railButton.removeEventListener(PrimitiveButton.BUTTON_OVER,railOverListener);
			_railButton.removeEventListener(PrimitiveButton.BUTTON_OUT,railOutListener);
			_railButton.removeEventListener(PrimitiveButton.BUTTON_CLICKED,railClickedListener);
			_railButton.removeEventListener(PrimitiveButton.BUTTON_UP_OUTSIDE,railClickedListener);
			
			_dragButton.removeEventListener(PrimitiveButton.BUTTON_OVER,dragOverListener);
			_dragButton.removeEventListener(PrimitiveButton.BUTTON_OUT,dragOverListener);
			_dragButton.removeEventListener(PrimitiveButton.BUTTON_CLICKED,dragClickedListener);
			_dragButton.removeEventListener(PrimitiveButton.BUTTON_UP_OUTSIDE,dragClickedListener);
			
			_dragButton.hit.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragButton.hit.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		
			//_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelListener, true); 
		
		}
		
		private function returnPathLength():Number
		{
			
			if(_direction == "vertical")
			{
				
				return _railButton.height - _dragButton.height;
				
			}
			else
			{
				
				return _railButton.width - _dragButton.width;
				
			}
		}
		
		public function addListeners():void
		{
			
			
			
			_dragButton.hit.buttonMode = true;
			_railButton.addEventListener(PrimitiveButton.BUTTON_OVER,railOverListener);
			_railButton.addEventListener(PrimitiveButton.BUTTON_OUT,railOutListener);
			_railButton.addEventListener(PrimitiveButton.BUTTON_CLICKED,railClickedListener);
			_railButton.addEventListener(PrimitiveButton.BUTTON_UP_OUTSIDE,railClickedListener);
			
			_dragButton.addEventListener(PrimitiveButton.BUTTON_OVER,dragOverListener);
			_dragButton.addEventListener(PrimitiveButton.BUTTON_OUT,dragOverListener);
			_dragButton.addEventListener(PrimitiveButton.BUTTON_CLICKED,dragClickedListener);
			_dragButton.addEventListener(PrimitiveButton.BUTTON_UP_OUTSIDE,dragClickedListener);
			
			_dragButton.hit.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			
			//_dragButton.hit.addEventListener(MouseEvent.MOUSE_UP, dragUpHandler);
			if(stage)
			{
				
				
				MacMouseWheel.setup(stage );
				
				stage.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
				stage.addEventListener(Event.MOUSE_LEAVE,mouseLeave);
				
				stage.addEventListener( MouseEvent.MOUSE_WHEEL, wheelListener );
				
				//stage.addEventListener(MouseEvent.MOUSE_WHEEL,wheelListener,true);
			}
			//_railButton.hit.removeEventListener(MouseEvent.MOUSE_MOVE,railMoveListener);
		
			//_dragButton.hit.removeEventListener(MouseEvent.MOUSE_MOVE,dragMoveXListener);
			//_dragButton.hit.removeEventListener(MouseEvent.MOUSE_MOVE,dragMoveYListener);
		
			//this.stage.addEventListener(MouseEvent.MOUSE_WHEEL,wheelListener,true);
		
		}
	
		protected function addElements():void
		{
			
			// setting from outside?
			_railButton.hit.buttonMode = false;
			_dragButton.hit.buttonMode = false;
			addChild(_railButton);
			addChild(_dragButton);
			
		
		}
		
		protected function wheelListener(e:MouseEvent):void
		{

            // trace(e.delta);
            
            _deltaWheel = e.delta;
            
            if(this.visible==true)
            {
               	
               	dealWithWheel(_deltaWheel);
            	
            }
				
			
             
		
		}
		
		protected function dealWithWheel(k:int):void
		{
			//trace("quantità mouse scroller "+k);
			
			switch(_direction)
			{
				case "vertical":
				    
				   // moveButtonToYRailCoordinates(Math.floor(k));
				   
				   
				   if((_dragButton.y-(k*10))<=0)
				   {
				   	
				   	  moveButtonToYRailCoordinates(0);
				   	
				   }else
				   
				   {
				   	
				   	 moveButtonToYRailCoordinates(_dragButton.y-(k*10));
				   	
				   }

				    
				    break;
				    
				    
				default:

				
			}

			
		}
		
		protected function railOverListener(e:Event):void
		{
			_railButton.hit.addEventListener(MouseEvent.MOUSE_MOVE,railMoveListener);
		}
		
		protected function railOutListener(e:Event):void
		{
			_railButton.hit.removeEventListener(MouseEvent.MOUSE_MOVE,railMoveListener);
		}
		
		protected function railClickedListener(e:Event):void
		{
			
			switch(_direction)
			{
				
				case "vertical":
					moveButtonToYRailCoordinates(Math.floor(this.mouseY));
					
					break;
				
				default:
					moveButtonToXRailCoordinates(Math.floor(_mouseXrail));
			
			}
		
		}
		
		protected function dragOverListener(e:Event):void
		{
		
		}
		
		protected function dragOutListener(e:Event):void
		{
		
		}
		
		protected function dragClickedListener(e:Event):void
		{
		
		}
		
		protected function dragDownHandler(e:MouseEvent):void
		{
			
			TweenMax.killTweensOf(_dragButton);
			
			switch(_direction)
			{
				
				case "vertical":
					_dragButton.startDrag(false,new Rectangle(0,0,0,_railButton.height - _dragButton.height));
					
					//_dragButton.hit.addEventListener(MouseEvent.MOUSE_MOVE,dragMoveYListener);
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE,dragMoveYListener);
					
					break;
				
				default:
					_dragButton.startDrag(false,new Rectangle(0,0,_railButton.width - _dragButton.width,0));
					
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE,dragMoveXListener);
			
				//_dragButton.hit.addEventListener(MouseEvent.MOUSE_MOVE,dragMoveXListener);
			
			}
		
		}
		
		protected function dragUpHandler(e:MouseEvent):void
		{
			
			if(_direction == "vertical")
			{
				
				//_dragButton.hit.removeEventListener(MouseEvent.MOUSE_MOVE,dragMoveYListener);
				if(stage)
					this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,dragMoveYListener);
				
			}
			else
			{
				
				//_dragButton.hit.removeEventListener(MouseEvent.MOUSE_MOVE,dragMoveXListener);
				
				if(stage)
					this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,dragMoveXListener);
				
			}
			
			_dragButton.stopDrag();
		
		}
		
		private function dragMoveXListener(e:MouseEvent):void
		{
			
			_percentage = _dragButton.x / _pathLength;
			//dispatchDragButtonMove();
			dispatchDragButtonDragged();
			e.updateAfterEvent();
		
		}
		
		private function dragMoveYListener(e:MouseEvent):void
		{
			
			_percentage = _dragButton.y / _pathLength;
			//dispatchDragButtonMove();
			dispatchDragButtonDragged();
			
			e.updateAfterEvent();
		
		}
		
		private function dispatchDragButtonMove():void
		{
			
			// while the drag button is moving 
			
			dispatchEvent(new Event(AbstractSlider.DRAGBUTTON_MOVE,true));
		
		}
		
		private function dispatchDragButtonDragged():void
		{
			
			dispatchEvent(new Event(AbstractSlider.DRAGBUTTON_DRAGGED,true));
		
		}
		
		public function moveButtonToYRailCoordinates(targetY:Number):void
		{
			
			if(_objectEquation.equation == null && _objectEquation.time == null && _objectEquation.delay == null)
			{
				
				throw new IllegalOperationError("the object passed to the constustor must have the equation and time properties");
				
			}
			
			var finalTarget:Number;
			
			(targetY > _pathLength) ? finalTarget = Math.floor(_pathLength) : finalTarget = Math.floor(targetY);
			
			var differenceDistance:Number = Math.abs(targetY - _dragButton.y);
			var perc:Number = _pathLength / differenceDistance;
			var time:Number = _objectEquation.time / perc;
			
			_percentage = finalTarget / _pathLength;
			
			//TweenMax.to(_dragButton,time,{y:finalTarget+differenza,roundProps:[y],ease:_objectEquation.equation,delay:_objectEquation.delay,onComplete:dispatchTargetReached,onUpdate:dispatchDragButtonMove});
			TweenMax.to(_dragButton,time,{y:finalTarget,roundProps:[y],ease:_objectEquation.equation,delay:_objectEquation.delay,onComplete:dispatchTargetReached,onUpdate:dispatchDragButtonMove});
		
		}
		
		public function resetToOrigin():void
		{
		
			//TweenMax.to(_dragButton,2,{y:0,roundProps:[y],ease:_objectEquation.equation,delay:_objectEquation.delay,onComplete:dispatchTargetReached,onUpdate:dispatchDragButtonMove});
		
		}
		
		private function moveButtonToXRailCoordinates(targetX:Number):void
		{
			
			if(_objectEquation.equation == null && _objectEquation.time == null && _objectEquation.delay == null)
			{
				
				throw new IllegalOperationError("the object passed to the constustor must have the equation and time properties");
				
			}
			
			var finalTarget:Number;
			
			(targetX > _pathLength) ? finalTarget = Math.floor(_pathLength) : finalTarget = Math.floor(targetX);
			
			var differenceDistance:Number = Math.abs(targetX - _dragButton.x);
			var perc:Number = _pathLength / differenceDistance;
			var time:Number = _objectEquation.time / perc;
			
			_percentage = finalTarget / _pathLength;
			
			TweenMax.to(_dragButton,time,{x:finalTarget,roundProps:[x],delay:_objectEquation.delay,ease:_objectEquation.equation,onComplete:dispatchTargetReached,onUpdate:dispatchDragButtonMove});
		
		}
		
		private function dispatchTargetReached():void
		{
			// use signals later on
			dispatchEvent(new Event(AbstractSlider.DRAGBUTTON_TARGET_REACHED,true));
		}
		
		private function railMoveListener(e:MouseEvent):void
		{
			_mouseXrail = _railButton.mouseX;
			_mouseYrail = _railButton.mouseY;
			e.updateAfterEvent();
			dispatchEvent(new Event(AbstractSlider.RAILBUTTON_MOVE,true));
		}
		
		public function transitionIn():void
		{
			throw new IllegalOperationError("transitionIn called from an Abstract Slider Class should be overrided");
		}
		
		public function transitionOut():void
		{
			throw new IllegalOperationError("transitionOut called from an Abstract Slider Class should be overrided");
		}
		
		protected function transitionOutEnd():void
		{
			removeAllListeners();
			// replace with signals later on
			dispatchEvent(new Event(AbstractSlider.TRANSITION_OUT_END,true));
		}
		
		protected function transitionInEnd():void
		{
			
			// replace with signals later on
			//addListeners()
			dispatchEvent(new Event(AbstractSlider.TRANSITION_IN_END,true));
		
		}
		
		// GETTER AND SETTERS
		
		public function get percentage():Number
		{
			
			return _percentage
		
		}
		
		public function get railX():Number
		{
			
			return _mouseXrail;
		
		}
		
		public function get railY():Number
		{
			
			return _mouseYrail;
		
		}
		
		public function get deltaWheel():Number
		{
			
			return _deltaWheel;
		
		}
		
		public function updateDragger(k:Number):void
		{
			_dragButton.y = k * _pathLength;
			//TweenMax.to(_dragButton,_objectEquation.time,{y:k*_pathLength,roundProps:[y],ease:_objectEquation.equation,onComplete:dispatchTargetReached});
		}
		
		public function percentageDraggerRail():Number
		{
			if(_direction == "vertical")
			{
				
				//return _railButton.height/_dragButton.y;
				
				//return _pathLength/_dragButton.y;
				
				return _dragButton.y / _pathLength;
				
			}
			else
			{
				//return _pathLength/ _dragButton.y;
				//return _railButton.width/_dragButton.x;
				
				return _dragButton.x / _pathLength;
				
			}
		
		}
		
		// nuova funzione solo per fare l'update del rail secondo lo stage
		
		public function updateRailTwo(dimensione:Number,dimensione2:Number):void
		{
			if(_direction == "vertical")
			{
				//_railButton.skin.height=dimensione;
				var rapporto2:Number = _dragButton.y / _pathLength;
				_railButton.height = dimensione;
				_dragButton.height = dimensione2;
				
				_pathLength = returnPathLength();
				_dragButton.y = rapporto2 * _pathLength;
					//_percentage=_dragButton.y/_pathLength;
				
			}
		}
		
		public function updateDraggerY(k:Number):void
		{
			
			//_dragButton.y=_pathLength*k;
			
			_dragButton.y = _dragButton.y * k;
			//_dragButton.y=percentageDraggerRail()*k;
		
		}
		
		public function updateRail(dimensione:Number):void
		{
			
			if(_direction == "vertical")
			{
				_railButton.skin.height = dimensione;
				_railButton.height = dimensione;
				_railButton.hit.height = dimensione;
				_pathLength = returnPathLength();
				
			}
			else
			{
				_railButton.skin.width = dimensione;
				_railButton.width = dimensione;
				_railButton.hit.width = dimensione;
				_pathLength = returnPathLength();
				
			}
		
		}
	
	}
}