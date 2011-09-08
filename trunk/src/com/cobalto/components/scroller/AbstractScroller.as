package com.cobalto.components.scroller
{
	
	import com.cobalto.api.IScroller;
	import com.cobalto.api.ISlider;
	
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import gs.*;
	import com.greensock.easing.*;
	import com.cobalto.components.slider.AbstractSlider;
	
	public class AbstractScroller extends Sprite implements IScroller
	{
		
		protected var slider:ISlider;
		protected var content:Sprite;
		protected var masked:Sprite;
		protected var direction:String;
		protected var _maskNeeded:Boolean = false;
		protected var _objectEquation:Object;
		public var _altezzaContenuto:Number;
		
		public var differenza:Number;
		
		public static const TRANSITION_OUT_END:String = "transition_out_end";
		public static const TRANSITION_IN_END:String = "transition_in_end";
		
		private var _resize:String;
		
		public function AbstractScroller(classSlider:ISlider,object:Object,classContent:Sprite,altezzaContenuto:Number,classMask:Sprite,directionClass:String,resize:String="false")
		//public function AbstractScroller(classSlider:ISlider,object:Object,classContent:Sprite,classMask:Sprite,directionClass:String)
		{
			
			_resize = resize;
			_altezzaContenuto = altezzaContenuto;
			
			super();
			slider = classSlider;
			_objectEquation = object;
			
			// make it default false in case the content is small than the mask
			//(slider as AbstractSlider).visible=false;
			content = classContent;
			masked = classMask;
			
			//masked.visible=false;
			
			direction = directionClass;
			
			if(direction == "vertical")
			{
				
				//if(content.height > masked.height)
				if(_altezzaContenuto > masked.height)
				{
					
					_maskNeeded = true;
					(slider as AbstractSlider).visible = true;
					
				}
				
			}
			else
			{
				
				if(content.width > masked.width)
				{
					
					_maskNeeded = true;
					(slider as AbstractSlider).visible = true;
					
				}
				
			}
			
			addElements();
		}
		
		protected function addElements():void
		{
			
			addChild(content);
			addChild(masked);
			
			masked.visible = false;
			
			//if(_maskNeeded == true)
			//{
			
			addChild(slider as AbstractSlider);
			(slider as AbstractSlider).transitionIn();
			//}
		
		}
		
		private function addSliderListeners():void
		{
			
			//if(_maskNeeded)
			//{
			
			//(slider as AbstractSlider).addEventListener(AbstractSlider.DRAGBUTTON_DRAGGED,sliderDragDraggedListener);
			(slider as AbstractSlider).addEventListener(AbstractSlider.DRAGBUTTON_DRAGGED,sliderTargetReached);
			(slider as AbstractSlider).addEventListener(AbstractSlider.RAILBUTTON_MOVE,sliderRailMoveListener);
			(slider as AbstractSlider).addEventListener(AbstractSlider.DRAGBUTTON_TARGET_REACHED,sliderTargetReached);
		
			//}
		}
		
		private function removeSliderListeners():void
		{
			
			if(_maskNeeded)
			{
				
				(slider as AbstractSlider).removeEventListener(AbstractSlider.DRAGBUTTON_DRAGGED,sliderDragDraggedListener);
				(slider as AbstractSlider).removeEventListener(AbstractSlider.RAILBUTTON_MOVE,sliderRailMoveListener);
				(slider as AbstractSlider).removeEventListener(AbstractSlider.DRAGBUTTON_TARGET_REACHED,sliderTargetReached);
				
			}
		
		}
		
		protected function sliderTargetReached(e:Event):void
		{
			
			if(direction == "vertical")
			{
				
				if(_resize == "false")
				{
					TweenMax.to(content,_objectEquation.time,{y:-e.target.percentage * (_altezzaContenuto - masked.height) + differenza,roundProps:[y],ease:_objectEquation.equation,overwrite:true});
				}
				else
				{
					TweenMax.to(content,_objectEquation.time,{y:-e.target.percentage * (content.height - masked.height) + differenza,roundProps:[y],ease:_objectEquation.equation,overwrite:true});
					
				}
				
					//TweenMax.to(content,_objectEquation.time,{y:-e.target.percentage * (content.height - masked.height) + differenza,roundProps:[y],ease:_objectEquation.equation,overwrite:true});
					//TweenMax.to(content,_objectEquation.time,{y:-e.target.percentage * (_altezzaContenuto - masked.height) + differenza,roundProps:[y],ease:_objectEquation.equation,overwrite:true});
			}
			else
			{
				
				TweenMax.to(content,_objectEquation.time,{x:-e.target.percentage * (content.width - masked.width),roundProps:[x],ease:_objectEquation.equation,overwrite:true});
				
			}
		
		}
		
		protected function sliderDragDraggedListener(e:Event):void
		{
			
			var perc:Number = e.target.percentage;
			
			if(direction == "vertical")
			{
				
				//TweenMax.to(content,_objectEquation.time,{y:-e.target.percentage * (content.height - masked.height) + differenza,roundProps:[y],ease:_objectEquation.equation,overwrite:true});
				TweenMax.to(content,_objectEquation.time,{y:-e.target.percentage * (_altezzaContenuto - masked.height) + differenza,roundProps:[y],ease:_objectEquation.equation,overwrite:true});
			}
			else
			{
				
					//TweenMax.to(content,_objectEquation.time,{x:-e.target.percentage * (content.width - masked.width),roundProps:[x],ease:_objectEquation.equation,overwrite:true});
				
			}
		
		}
		
		protected function sliderRailMoveListener(e:Event):void
		{
		
		}
		
		public function transitionIn():void
		{
			
			throw new IllegalOperationError("transitionIn called from an Abstract Scroller Class should be overrided");
		
		}
		
		public function transitionOut():void
		{
			
			throw new IllegalOperationError("transitionOut called from an Abstract Scroller Class should be overrided");
		
		}
		
		protected function transitionOutEnd():void
		{
			
			dispatchEvent(new Event(AbstractScroller.TRANSITION_OUT_END,true));
			removeSliderListeners();
		
		}
		
		protected function transitionInEnd():void
		{
			
			dispatchEvent(new Event(AbstractScroller.TRANSITION_IN_END,true));
			(slider as AbstractSlider).addListeners();
			addSliderListeners();
		
		}
		
		public function activeMask(k:Boolean):void
		{
			
			if(k)
			{
				
				(masked as Sprite).cacheAsBitmap = true;
				content.mask = masked;
				masked.alpha = .4;
				masked.visible = true;
				
			}
			else
			{
				
				masked.visible = false;
				
			}
		
		}
		
		public function get maskOfScroller():Sprite
		{
			return masked
		}
		
		public function get maskedContent():Sprite
		{
			return content;
		}
	
		// just for vertical 
	
	}
}