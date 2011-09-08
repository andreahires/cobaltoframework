package com.cobalto.components.slider
{
	import com.cobalto.api.ISlider;
	import gs.*;
	import com.greensock.easing.*;
	import com.cobalto.components.buttons.PrimitiveButton;
	
	public class ConcreteSlider extends AbstractSlider implements ISlider
	{
		public function ConcreteSlider(dragButton:PrimitiveButton,railButton:PrimitiveButton,objectEquation:Object,direction:String="vertical")
		{
			super(dragButton,railButton,objectEquation,direction);
		}
		
		override public function transitionIn():void
		{
			TweenMax.to(_railButton,0.3,{scaleY:1,delay:0.3,ease:Expo.easeOut});
			TweenMax.to(_dragButton,0.3,{y:0,roundProps:[y],alpha:1,delay:0.3,ease:Expo.easeOut,onComplete:transitionInEnd});
		
		}
		
		override public function transitionOut():void
		{
			
			TweenMax.to(_railButton,0.3,{scaleY:0,delay:0.3,ease:Expo.easeOut});
			TweenMax.to(_dragButton,0.3,{y:300,roundProps:[y],alpha:0,delay:0.3,ease:Expo.easeOut,onComplete:transitionOutEnd});
		
		}
		
		override protected function addElements():void
		{
			
			super.addElements();
			//_railButton.scaleY=0;
			//_dragButton.y=300;
			//_dragButton.alpha=1;
		
		}
	}
}