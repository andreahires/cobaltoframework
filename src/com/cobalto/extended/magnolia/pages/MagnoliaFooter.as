
//////////////////////////////////////////////////////////////////////
//																	\\
//  MagnoliaFooter ~ by  Zulu*											//---------/////////
//\\ 																\\
//////////////////////////////////////////////////////////////////////

package com.cobalto.extended.magnolia.pages
{
	import com.asual.swfaddress.SWFAddress;
	import com.cobalto.ApplicationFacade;
	import com.cobalto.api.IViewComponent;
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.components.buttons.ToggleButton;
	import com.cobalto.components.pages.Footer;
	import com.cobalto.display.Drawer;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.text.TextBuilder;
	import com.cobalto.utils.Web;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import style.Styles;
	
	public class MagnoliaFooter extends Footer implements IViewComponent
	{
		protected var loginToggleButton:ToggleButton;
		protected var soundButton:PrimitiveButton;
		
		public function MagnoliaFooter()
		{
			super();
		}
		
		override public function build(pageData:Object=null):void
		{
			super.build(pageData);
			
			currentLinksArray = new Array();
			
			var footerLength:uint = ApplicationFacade.commonLabelXML.properties.footerlinks.link.length();
			
			for each(var link:XML in ApplicationFacade.commonLabelXML.properties.footerlinks.link)
			{
				currentLinksArray.push({label:link,href:link.@href,target:link.@target});
			}
			
			createMenu();
			addSoundController();
		
		}
		
		override public function updateFooter(linksArray:Array):void
		{
		/*currentLinksArray = linksArray;
		
		   if(isMenuCreated)
		   removeAndRecreateMenus();
		   else if(!isMenuCreated)
		 createMenu();*/
		}
		
		override protected function createMenu():void
		{
			
			var length:uint = currentLinksArray.length;
			var i:uint = 0;
			
			while(i < length)
			{
				var text:TextBuilder = new TextBuilder(currentLinksArray[i].label);
				text.objectFormat = Styles.FAGO_11_YELLOW;
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
			alignHolder();
			transitionIn();
		
		}
		
		override protected function removeAndRecreateMenus():void
		{
			var length:uint = linksHolder.numChildren;
			var i:uint = 0;
			
			while(i < length)
			{
				var button:PrimitiveButton = linksHolder.getChildByName('LINKSBUTTON' + i) as PrimitiveButton;
				linksHolder.removeChild(button);
				++i;
			}
			
			createMenu();
		}
		
		override protected function onLinkClickHandler(event:Event):void
		{
			var href:String = currentLinksArray[event.target.id].href;
			var target:String = currentLinksArray[event.target.id].target;
			
			Web.getURL(href,target);
		}
		
		override protected function onLinkOverHandler(event:Event):void
		{
		
		}
		
		override protected function onLinkOutHandler(event:Event):void
		{
		
		}
		
		override public function transitionIn():void
		{
			var length:uint = linksHolder.numChildren;
			var i:uint = 0;
			var xOffset:uint = 0;
			
			while(i < length)
			{
				var button:PrimitiveButton = linksHolder.getChildByName('LINKSBUTTON' + i) as PrimitiveButton;
				TweenLite.to(button,0.3,{x:Math.round(xOffset),alpha:1,ease:Expo.easeOut});
				xOffset += button.width + 10;
				++i;
			}
			
			addLoginToggleButton();
			organizeItems();
		}
		
		override protected function alignHolder():void
		{
			linksHolder.x = 75;
			//linksHolder.y = Math.round(stage.stageHeight - linksHolder.height - 3);
		}
		
		override protected function onTransitionInEnd():void
		{
			
		}
		
		override protected function onTransitionOutEnd():void
		{
		
		}
		
		override public function transitionOut():void
		{
			var length:uint = linksHolder.numChildren;
			var i:uint = 0;
			
			while(i < length)
			{
				var button:PrimitiveButton = linksHolder.getChildByName('LINKSBUTTON' + i) as PrimitiveButton;
				TweenLite.to(button,0.3,{alpha:0,ease:Expo.easeOut});
				++i;
			}
		}
		
		public function addLoginToggleButton(value:int=0):void
		{
			if(!loginToggleButton)
				createLoginToggleButton();
		}
		
		protected function addSoundController():void
		{
			
			soundButton = new PrimitiveButton();
			
			var skin:Sprite = new Sprite();
			
			Drawer.DrawRect(skin,60,25);
			
			soundButton.skin = skin;
			
			soundButton.addEventListener(PrimitiveButton.BUTTON_CLICKED,onSoundClickHandler);
			
			addChild(soundButton);
			
			soundButton.alpha = 0;
		
		}
		
		protected function onSoundClickHandler(e:Event):void
		{
			if(ApplicationFacade.soundLoaded == true)
			{
				
				ApplicationFacade.soundLoaded = false;
				
			}
			else
			{
				ApplicationFacade.soundLoaded = true;
				
			}
		
		}
		
		protected function createLoginToggleButton():void
		{			
			trace(ApplicationFacade.commonLabelXML);
			loginToggleButton = new ToggleButton([ApplicationFacade.commonLabelXML..login,ApplicationFacade.commonLabelXML..logout],50,20,2,2);
			loginToggleButton.build();
			loginToggleButton.addEventListener(ToggleButton.CHANGED,onLoginChangeHandler);
			linksHolder.addChild(loginToggleButton);
			loginToggleButton.y = -3;
			loginToggleButton.alpha = 0;
			freezeToggle();
		}
		
		protected function onLoginChangeHandler(event:Event):void
		{
			
			switch(loginToggleButton.getCurrentState())
			{
				
				case 1:
					
					freezeToggle();
					
					MagnoliaSiteFacade.APPENDLOGIN = ApplicationFacade.commonLabelXML..links.logoutLink;
					var currentPage:String = SWFAddress.getPathNames()[SWFAddress.getPathNames().length - 1];
					
					switch(currentPage.toUpperCase())
				{
					case 'HOME':
						Web.getURL(ApplicationFacade.commonLabelXML..links.redirectLink,'_self');
						break;
					default:
						MagnoliaSiteFacade.APPENDLOGIN = ApplicationFacade.commonLabelXML..links.logoutLink;
						Web.getURL(ApplicationFacade.commonLabelXML..links.homeLink,'_self');
						break;
				}
					
					break;
				
				default:
					freezeToggle();
					//trace(ApplicationFacade.commonLabelXML..links.loginLink + " ApplicationFacade.commonLabelXML..links.loginLink");
					Web.getURL(ApplicationFacade.commonLabelXML..links.loginLink,'_self');
					break;
			}
		}
		
		override public function setLoginStatus(status:Boolean):void
		{
			switch(status)
			{
				case true:
					loginToggleButton.setCurrentState(1)
					loginToggleButton.toogleState();
					TweenLite.to(loginToggleButton,0.8,{alpha:1,ease:Expo.easeOut});
					deFreezeToggle();
					break;
				
				default:
					loginToggleButton.setCurrentState(0)
					loginToggleButton.toogleState();
					TweenLite.to(loginToggleButton,0.8,{alpha:1,ease:Expo.easeOut});
					deFreezeToggle();
					break;
			}
		}
		
		protected function freezeToggle():void
		{
			loginToggleButton.mouseEnabled = false;
			loginToggleButton.buttonMode = false;
			loginToggleButton.hit.mouseEnabled = false;
			loginToggleButton.hit.buttonMode = false;
		}
		
		protected function deFreezeToggle():void
		{
			loginToggleButton.mouseEnabled = true;
			loginToggleButton.buttonMode = true;
			loginToggleButton.hit.mouseEnabled = true;
			loginToggleButton.hit.buttonMode = true;
		}
		
		override public function freezeFooter():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.buttonMode = false;
			TweenLite.to(linksHolder,1,{y:100,ease:Expo.easeOut});
		}
		
		override public function deFreezeFooter():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
			this.buttonMode = true;
			
			TweenLite.to(linksHolder,1,{y:9,ease:Expo.easeOut});
		}
		
		override public function organizeItems():void
		{
			super.organizeItems();
			
			if(linksHolder)
				linksHolder.y = 9;
			
			if(loginToggleButton)
			{
				loginToggleButton.x = (this.stage.stageWidth - (loginToggleButton.width *2.8));		
			}
		}
	
	}
}