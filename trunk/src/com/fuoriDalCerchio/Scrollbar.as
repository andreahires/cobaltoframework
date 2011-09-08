package com.fuoriDalCerchio
{
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	
	public class Scrollbar extends Sprite
	{
		
		private var _dragged:*;
		private var _mask:*;
		private var _ruler:*;
		private var _background:*;
		private var _hitarea:*;
		private var _blurred:Boolean;
		private var _YFactor:Number;
		
		private var _initY:Number;
		
		private var minY:Number;
		private var maxY:Number;
		private var percentuale:uint;
		private var contentstarty:Number;
		private var bf:BlurFilter;
		
		protected var _uniqueName:String;
		
		private var initialized:Boolean = false;
		
		public function Scrollbar(dragged:*,maskclip:*,ruler:Sprite,background:*,hitarea:*,blurred:Boolean=false,yfactor:Number=4)
		{
			super();
			
			this.tabChildren=false;
			this.tabEnabled=false;
			
			_dragged = dragged;
			_mask = maskclip;
			_ruler = ruler;
			_background = background;
			_hitarea = hitarea;
			_blurred = blurred;
			_YFactor = yfactor;
			
			_ruler.name = 'ScrollDragger';
			_background.name = 'ScrollTrack';
			_dragged.name = 'contentHolder';
			_hitarea.name = 'Hitarea';
			
			this.name = 'scrollContentArea';
		}
		
		private function checkPieces():void
		{
			var ok:Boolean = true;
			
			if(!_dragged)
				throw new IllegalOperationError("dragged content not set");
			
			if(!_mask)
				throw new IllegalOperationError("mask not set");
			
			if(!_ruler)
				throw new IllegalOperationError("ruler not set");
			
			if(!_background)
				throw new IllegalOperationError("background not set");
			
			if(!_hitarea)
				throw new IllegalOperationError("hitArea not set");
		}
		
		public function init(e:Event=null):void
		{
			checkPieces();
			
			if(initialized == true)
			{
				reset();
			}
			bf = new BlurFilter(0,0,1);
			this._dragged.filters = new Array(bf);
			this._dragged.mask = this._mask;
			this._dragged.cacheAsBitmap = true;
			
			this.minY = _background.y;
			
			this._ruler.buttonMode = true;
			
			this.contentstarty = _dragged.y;
			
			_ruler.addEventListener(MouseEvent.MOUSE_DOWN,clickHandle);
			stage.addEventListener(MouseEvent.MOUSE_UP,releaseHandle);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,wheelHandle,true);
			this.addEventListener(Event.ENTER_FRAME,enterFrameHandle);
			
			initialized = true;
		
		}
		
		protected function clickHandle(e:MouseEvent):void
		{
			var rect:Rectangle = new Rectangle(_ruler.x,minY,0,maxY);
			_ruler.startDrag(false,rect);
		}
		
		protected function releaseHandle(e:MouseEvent):void
		{
			_ruler.stopDrag();
		}
		
		protected function wheelHandle(e:MouseEvent):void
		{
			if(this._hitarea.hitTestPoint(stage.mouseX,stage.mouseY,false))
			{
				scrollData(e.delta);
			}
		}
		
		protected function enterFrameHandle(e:Event):void
		{
			positionContent();
		}
		
		public function scrollData(q:int):void
		{
			var d:Number;
			var rulerY:Number;
			
			var quantity:Number = this._ruler.height / 5;
			
			d = -q * Math.abs(quantity);
			
			if(d > 0)
			{
				rulerY = Math.min(maxY,_ruler.y + d);
			}
			
			if(d < 0)
			{
				rulerY = Math.max(minY,_ruler.y + d);
			}
			
			_ruler.y = rulerY;
			
			positionContent();
		}
		
		public function moveDragger(offset:int):void
		{
			var tempValue:Number = offset;
			//_ruler.y = offset;
			//(tempValue>0) ? _ruler.y += offset : _ruler.y = 0;
			_ruler.y+= offset
			positionContent();
		}
		
		public function positionContent():void
		{
			var upY:Number;
			var downY:Number;
			var curY:Number;
			
			/* thanks to Kalicious (http://www.kalicious.com/) */
			this._ruler.height = (this._mask.height / this._dragged.height) * this._background.height;
			this.maxY = this._background.height - this._ruler.height;
			/*	*/
			
			var limit:Number = this._background.height - this._ruler.height;
			
			if(this._ruler.y > limit)
			{
				this._ruler.y = limit;
			}
			
			checkContentLength();
			
			percentuale = (100 / maxY) * _ruler.y;
			
			upY = 0;
			downY = _dragged.height - (_mask.height / 2);
			
			var fx:Number = contentstarty - (((downY - (_mask.height / 2)) / 100) * percentuale);
			
			var curry:Number = _dragged.y;
			var finalx:Number = fx;
			
			if(curry != finalx)
			{
				var diff:Number = finalx - curry;
				curry += diff / _YFactor;
				
				var bfactor:Number = Math.abs(diff) / 8;
				bf.blurY = bfactor / 2;
				
				if(_blurred == true)
				{
					_dragged.filters = new Array(bf);
				}
			}
			
			_dragged.y = curry;
		}
		
		public function checkContentLength():void
		{
			
			if(_dragged.height < _mask.height)
			{
				_ruler.visible = false;
				reset();
			}
			else
			{
				_ruler.visible = true;
			}
		}
		
		public function reset():void
		{
			_dragged.y = contentstarty;
			_ruler.y = 0;
		}
		public function removeMaskForPrint(isTrue:Boolean):void
		{
			_ruler.y=0;
			_dragged.y=0;
			
			positionContent();
			
			if(isTrue)
			{
				this._dragged.mask = null;
				this._mask.visible=false;
				
			}else
			{
				this._mask.visible=true;
				this._dragged.mask = this._mask;
			
			}
		}
		public function set dragged(v:*):void
		{
			_dragged = v;
		}
		
		public function set maskclip(v:*):void
		{
			_mask = v;
		}
		
		public function set ruler(v:*):void
		{
			_ruler = v;
		}
		
		public function set background(v:*):void
		{
			_background = v;
		}
		
		public function set hitarea(v:*):void
		{
			_hitarea = v;
		}
		
		public function set hitAreaWidth(w:int):void
		{
			_hitarea.width = w;
		}
		
		public function set setUniqueName(value:String):void
		{
			this.name = value;
			_uniqueName = value;
		}
		
		public function get getUniqueName():String
		{
			return _uniqueName;
		}
	
		
	}
}