

	//////////////////////////////////////////////////////////////////////
	//																	\\
	//  SCROLLBAR CORE CODE ~ by Andrea* | Class ~ Zulu*				//---------/////////
	//\\ 																\\
	//////////////////////////////////////////////////////////////////////



package com.cobalto.components.scrollbar
{
	import com.cobalto.components.arrows.AbstractArrowNav;
	import com.cobalto.components.scroller.AbstractScroller;
	import com.cobalto.components.arrows.ConcreteArrowNavigation;
	import com.cobalto.components.scroller.ConcreteScrollerButtons;
	import com.cobalto.components.slider.ConcreteSlider;
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.api.IScroller;
	import com.cobalto.api.ISlider;
	import com.cobalto.display.Drawer;
	import com.cobalto.text.TextBuilder;
	import com.cobalto.utils.AssetManager;
	import com.cobalto.utils.Draggable;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import style.Styles;

	public class ScrollBar extends Sprite
	{
		protected var slider 	: ISlider;
		protected var dragger 	: PrimitiveButton;
		protected var track 		: PrimitiveButton;
		protected var arrowNav 	: AbstractArrowNav;
		protected var scroller 	: IScroller;
		protected var scrollerContent : InteractiveObject;
		protected var draggable : Draggable;

		protected var draggerSkin : Sprite;
		
		protected var backSkin 	: MovieClip;
		protected var nextSkin 	: MovieClip;
		
		protected var scrollerContentContainer :  Sprite;
		
		protected var maskee : Sprite;
		protected var animationObject : Object;
		
		protected var areaWidth:int;
		protected var areaHeight:int;
		
		protected var tWidth:int;
		protected var tHeight:int;
		
		protected var targetObject:InteractiveObject;
		
		public function ScrollBar(Target:InteractiveObject, AreaWidth:int, AreaHeight:int,  TrackWidth:int, TrackHeight:int)
		{
			super();
			
			contentAreaWidth = AreaWidth;
			contentAreaHeight = AreaHeight;
			
			trackWidth = TrackWidth;
			trackHeight = TrackHeight;
			
			target = Target;
		}
	
		public function Init():void
		{
			createDragger();
			createBackAndNextSkins();
			createArrowNavigations();
			createTrack();
			createSlider();
			createScrollerContent();
			createScrollerContentContainer();
			createMask();
			buildScrollBar();
		}
		
		protected function createDragger():void
		{
			var rectangle:Sprite= new Sprite();
            Drawer.DrawRect(rectangle,trackWidth,118,uint('0x'+Styles.COLOR_BLACK));
            
            dragger= new PrimitiveButton();
			draggerSkin = new Sprite();
			
			draggerSkin.addChild(rectangle);
			dragger.skin=draggerSkin;
		}
		
		protected function createBackAndNextSkins():void
		{
			backSkin=AssetManager.getItem("ArrowUp");
			backSkin.scaleX=10;
			backSkin.scaleY=10;
			
			nextSkin=AssetManager.getItem("ArrowDown");
			nextSkin.scaleX=10;
			nextSkin.scaleY=10;
		}
		
		protected function createArrowNavigations():void
		{
			arrowNav= new ConcreteArrowNavigation();
			//arrowNav.x=300;
			arrowNav.y=0;
			arrowNav.createArrows(backSkin,nextSkin);
			arrowNav.setOffset(0,200);
		}
		
		protected function createTrack():void
		{
			track=new PrimitiveButton();
			var trackSkin:Sprite = new Sprite();
			trackSkin.alpha=1;
			
			var rectangle:Sprite= new Sprite();
            Drawer.DrawRect(rectangle,trackWidth,trackHeight,uint('0x'+Styles.COLOR_YELLOW));
            
            trackSkin.addChild(rectangle);
			track.skin=trackSkin;
		}
		
		protected function createSlider():void
		{
			animationObject ={time:.5,equation:"Expo.easeInOut"};
		   	slider= new ConcreteSlider(dragger,track,animationObject,"vertical");
			(slider as ConcreteSlider).x = contentAreaWidth;
			(slider as ConcreteSlider).y = 0;
		}
		
		protected function createScrollerContent():void
		{
			scrollerContent = target;
		}
		
		protected function createScrollerContentContainer():void
		{
			scrollerContentContainer = new Sprite();
			
			var textToDemolish:TextBuilder= new TextBuilder("Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",50);
			textToDemolish.objectFormat=Styles.FAGO_11_GREY;
			//scrollerContentContainer.addChild(textToDemolish);
			
			Drawer.DrawInvisibleRect(scrollerContentContainer,contentAreaWidth,700,0x000000);
			//scrollerContentContainer.alpha=0;
			scrollerContentContainer.addChild(scrollerContent);
		}
		
		protected function createMask():void
		{
			maskee= new Sprite();
			Drawer.DrawRect(maskee,contentAreaWidth,contentAreaHeight);
		}
		
		protected function buildScrollBar():void
		{
			scroller = new ConcreteScrollerButtons(slider,animationObject,scrollerContentContainer,400,maskee,"vertical",arrowNav);
			
			(scroller as ConcreteScrollerButtons).numSteps=14;
			(scroller as AbstractScroller).x=0;
			(scroller as AbstractScroller).y=0;
			
			addChild(scroller as AbstractScroller);  
			
			(scroller as ConcreteScrollerButtons).transitionIn();
			 
			 scroller.activeMask(true);
		}
		
		public function updateScrollBar(object:Object):void
		{
			if(slider)
			{
				(slider as ConcreteSlider).y = -Math.round(object.sliderY);
				(slider as ConcreteSlider).x = Math.round((object.sliderX) - (slider as ConcreteSlider).width);
				
			}
			if(arrowNav)
			{
				//arrowNav.x= (slider as ConcreteSlider).x-200;
				//arrowNav.y= (slider as ConcreteSlider).y-20;
				//trace(track.y+track.height-40))
				//arrowNav.setOffset(0,track.height-80);
			}
		}
		
		
		public function updateScrollBarArrowNavigation(xOffset:Number,yOffset:Number):void
		{
			arrowNav.setOffset(xOffset,yOffset);

		}
		
		public function positionArrowNavigation(x:Number,y:Number):void
		{
			arrowNav.x=x;
			arrowNav.y=y;
		}

		protected function organizeItems():void
		{
			
		}
		
		protected function set contentAreaWidth(value:int):void
		{
			areaWidth  = value;
		}
		
		protected function get contentAreaWidth():int
		{
			return areaWidth;
		}
		
		protected function set contentAreaHeight(value:int):void
		{
			areaHeight  = value;
		}
		
		protected function get contentAreaHeight():int
		{
			return areaHeight;
		}
		
		protected function set trackWidth(value:int):void
		{
			tWidth  = value;
		}
		
		protected function get trackWidth():int
		{
			return tWidth;
		}
		
		protected function set trackHeight(value:int):void
		{
			tHeight  = value;
		}
		
		protected function get trackHeight():int
		{
			return tHeight;
		}
		
		protected function set target(object:InteractiveObject):void
		{
			targetObject  = object;
		}
		
		protected function get target():InteractiveObject
		{
			return targetObject;
		}
		
	}
}