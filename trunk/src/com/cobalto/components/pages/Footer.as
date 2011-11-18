
//////////////////////////////////////////////////////////////////////
//																	\\
//  FOOTER ~ by  Zulu*												//---------/////////
//\\ 																\\
//////////////////////////////////////////////////////////////////////

package com.cobalto.components.pages
{
	import com.cobalto.api.IViewComponent;
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.display.Drawer;
	import com.cobalto.text.TextBuilder;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import style.Styles;
	
	public class Footer extends Page implements IViewComponent
	{
		protected var bg:Shape = new Shape();
		protected var textLine:TextBuilder;
		protected var isMenuCreated:Boolean = false;
		protected var currentLinksArray:Array = [];
		protected var linksHolder:Sprite;
		
		public function Footer()
		{
			super();
			linksHolder = new Sprite();
			addChild(linksHolder);
		}
		
		override public function build(pageData:Object=null):void
		{
			bg = new Shape();
			Drawer.DrawRect(bg,1024,30,0x000000);
			addChildAt(bg,0);
			
			organizeItems();
		}
		
		public function updateFooter(linksArray:Array):void
		{
			currentLinksArray = linksArray;
			
			if(isMenuCreated)
				removeAndRecreateMenus();
			else if(!isMenuCreated)
				createMenu();
		}
		
		protected function createMenu():void
		{
			
			var length:uint = currentLinksArray.length;
			var i:uint = 0;
			
			while(i < length)
			{
				var text:TextBuilder = new TextBuilder(currentLinksArray[i].label);
				text.objectFormat = Styles.COPY_YELLOW;
				text.objectField = Styles.TEXT_ADVANCED;
				var skin:Sprite = new Sprite();
				skin.addChild(text);
				
				var button:PrimitiveButton = new PrimitiveButton(text.textWidth,text.textHeight);
				button.skin = skin;
				button.id = i;
				
				button.addEventListener(PrimitiveButton.BUTTON_CLICKED,onLinkClickHandler);
				button.addEventListener(PrimitiveButton.BUTTON_OVER,onLinkOverHandler);
				button.addEventListener(PrimitiveButton.BUTTON_OUT,onLinkOutHandler);
				button.name = 'LINKSBUTTON' + i;
				button.alpha = 0;
				linksHolder.addChild(button);
				
				++i;
			}
			
			isMenuCreated = true;
			transitionIn();
		}
		
		protected function removeAndRecreateMenus():void
		{
			var length:uint = linksHolder.numChildren;
			var i:uint = 0;
			
			while(i < length)
			{
				var button:PrimitiveButton = linksHolder.getChildByName('LINKSBUTTON' + i) as PrimitiveButton;
				button.removeEventListener(PrimitiveButton.BUTTON_CLICKED,onLinkClickHandler);
				button.removeEventListener(PrimitiveButton.BUTTON_OVER,onLinkOverHandler);
				button.removeEventListener(PrimitiveButton.BUTTON_OUT,onLinkOutHandler);
				this.removeChild(button);
				++i;
			}
			
			createMenu();
		}
		
		protected function onLinkClickHandler(event:Event):void
		{
		
		}
		
		protected function onLinkOverHandler(event:Event):void
		{
		
		}
		
		protected function onLinkOutHandler(event:Event):void
		{
		
		}
		
		override public function transitionIn():void
		{
			var length:uint = linksHolder.numChildren;
			var i:uint = 0;
			
			while(i < length)
			{
				var button:PrimitiveButton = linksHolder.getChildByName('LINKSBUTTON' + i) as PrimitiveButton;
				button.alpha = 1;
				++i;
			}
		}
		
		protected function alignHolder():void
		{
			linksHolder.x = 110;
			linksHolder.y = 4;
		}
		
		override protected function onTransitionInEnd():void
		{
		
		}
		
		override protected function onTransitionOutEnd():void
		{
		
		}
		
		public function setLoginStatus(status:Boolean):void
		{
		
		}
		
		public function freezeFooter():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.buttonMode = false;
		}
		
		public function deFreezeFooter():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
			this.buttonMode = true;
		}
		
		override public function transitionOut():void
		{
			var length:uint = linksHolder.numChildren;
			var i:uint = 0;
			
			while(i < length)
			{
				var button:PrimitiveButton = linksHolder.getChildByName('LINKSBUTTON' + i) as PrimitiveButton;
				button.alpha = 0;
				++i;
			}
		}
		
		override public function organizeItems():void
		{
			
			this.y = Math.round(stage.stageHeight - bg.height);
			
			if(linksHolder && stage)
			{
				linksHolder.x = 75;
			}
			
			if(bg && stage)
			{
				bg.width = stage.stageWidth;
				
			}
		}
	}
}