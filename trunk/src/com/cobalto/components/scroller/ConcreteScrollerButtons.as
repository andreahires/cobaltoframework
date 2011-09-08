package com.cobalto.components.scroller
{
	import com.cobalto.api.IScroller;
	import com.cobalto.api.ISlider;
	
	import flash.display.Sprite;
	
	import gs.*;
	import com.greensock.easing.*;
	import com.cobalto.components.slider.AbstractSlider;
	import com.cobalto.components.arrows.AbstractArrowNav;
	
	public class ConcreteScrollerButtons extends AbstractScrollerButtons implements IScroller
	{
		
		public function ConcreteScrollerButtons(classSlider:ISlider,object:Object,classContent:Sprite,altezzaClip:Number,classMask:Sprite,directionClass:String,arrowNav:AbstractArrowNav,resize:String="false")
		{
			super(classSlider,object,classContent,altezzaClip,classMask,directionClass,arrowNav,resize);
			content.alpha = 0;
			//masked.scaleY=0;
		}
		
		override public function activeMask(k:Boolean):void
		{
			super.activeMask(k);
		}
		
		override public function transitionIn():void
		{
			TweenMax.to(content,0.5,{alpha:1,ease:_objectEquation.equation,overwrite:true,onComplete:transitionInEnd});
			//TweenMax.to(masked,0.5,{scaleY:1,ease:_objectEquation.equation,overwrite:true,onComplete:transitionInEnd});
			//transitionInEnd();
		}
		
		override public function transitionOut():void
		{
		}
		
		public function update():void
		{
			if(direction == "vertical")
			{
				
				if(content.height > masked.height)
				{
					_maskNeeded = true;
					(slider as AbstractSlider).visible = true;
					/* TweenMax.to(slider,_objectEquation.time,{alpha:1,ease:_objectEquation.equation,overwrite:true,onComplete:function():void
					   {
					   (slider as AbstractSlider).visible = true
					 }});  */
					/* TweenMax.to(arrowNavigation,_objectEquation.time,{alpha:1,ease:_objectEquation.equation,overwrite:true,onComplete:function():void
					   {
					   arrowNavigation.visible = true
					 }}); */
					
						//(slider as AbstractSlider).visible=true;					
				}
				else
				{
					_maskNeeded = false;
					(slider as AbstractSlider).visible = false;
					/* TweenMax.to(slider,_objectEquation.time,{alpha:0,ease:_objectEquation.equation,overwrite:true,onComplete:function():void
					   {
					   (slider as AbstractSlider).visible = false
					 }});  */
					/* TweenMax.to(arrowNavigation,_objectEquation.time,{alpha:0,ease:_objectEquation.equation,overwrite:true,onComplete:function():void
					   {
					   arrowNavigation.visible = false
					 }}); */
					
					//(slider as AbstractSlider).moveButtonToYRailCoordinates(0);
					(slider as AbstractSlider).resetToOrigin();
					
						//(slider as AbstractSlider).visible=false;
				}
			}
		
		}
		
		public function destroy():void
		{
			
			slider = null;
			this.removeChild(content);
			content = null;
		
		}
	
	}

}