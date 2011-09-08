package com.cobalto.components.scroller
{
	import com.cobalto.api.IScroller;
	import com.cobalto.api.ISlider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gs.*;
	import com.greensock.easing.*;
	import com.cobalto.components.arrows.AbstractArrowNav;
	
	public class AbstractScrollerButtons extends AbstractScroller implements IScroller
	{
		protected var arrowNavigation:AbstractArrowNav;
		
		private var _numSteps:uint;
		
		private var _altezzaClip:Number;
		
		public function AbstractScrollerButtons(classSlider:ISlider,object:Object,classContent:Sprite,k:Number,classMask:Sprite,directionClass:String,arrowNav:AbstractArrowNav,resize:String="false")
		{
			
			_altezzaClip = k;
			
			super(classSlider,object,classContent,_altezzaClip,classMask,directionClass,resize);
			
			arrowNavigation = arrowNav;
			arrowNavigation.addEventListener(AbstractArrowNav.ARROW_BACK_CLICK,arrowBackClick);
			arrowNavigation.addEventListener(AbstractArrowNav.ARROW_NEXT_CLICK,arrowNextClick);
			
			if(_maskNeeded == true)
			{
				this.addChild(arrowNavigation);
			}
		
		}
		
		override protected function sliderDragDraggedListener(e:Event):void
		{
			
			super.sliderDragDraggedListener(e);
			
			arrowNavigation.activeId = Math.floor(e.target.percentage * _numSteps);
			arrowNavigation.dealWithScroller();
		
		}
		
		protected function arrowBackClick(e:Event=null):void
		{
			slider.move(arrowNavigation.activeId / (_numSteps - 1));
		}
		
		protected function arrowNextClick(e:Event=null):void
		{
			slider.move(arrowNavigation.activeId / (_numSteps - 1));
		}
		
		/////////////////////////// SETTERS AND GETTERS
		
		public function set numSteps(k:uint):void
		{
			_numSteps = k;
			arrowNavigation.itemLength = _numSteps;
		}
		
		public function get numSteps():uint
		{
			return _numSteps;
		}
	
	}
}