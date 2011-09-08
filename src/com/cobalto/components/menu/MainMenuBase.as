package com.cobalto.components.menu
{
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import com.cobalto.components.buttons.PrimitiveButton;

	public class MainMenuBase extends Sprite
	{
		
		protected var menuDataArray			:Array;
		protected var activeId				:int;
		protected var menu					:BasicMenu;

		// ** Build Menu & EventListeners
		public function buildMenu():void
		{
			if(menuData == null)
			{
				throw new IllegalOperationError("set the menudata with the 'setData' method before to build the menu");
			} 
			
			menu = new BasicMenu();
			menu.addEventListener(BasicMenu.BUTTON_ADDED, addedHandler);
			menu.addEventListener (BasicMenu.BUTTON_ENABLED, enabledHandler);
			menu.addEventListener (BasicMenu.BUTTON_DISABLED, disabledHandler);
			menu.addEventListener (PrimitiveButton.BUTTON_OVER, overHandler);
			menu.addEventListener (PrimitiveButton.BUTTON_OUT, outHandler);
			menu.addEventListener (PrimitiveButton.BUTTON_CLICKED, clickHandler);
			menu.build(menuData.length);
			addChild(menu);
		}
		
		// ** Menu Added Handler
		protected function addedHandler(e:Event):void{}
		
		// ** Menu Over Handler
		protected function overHandler (e:Event):void
		{
			overTween (e.target.parent.skin);	
		}
		
		protected function overTween(skin:*):void{}
		
		// ** Menu Out Handler
		protected function outHandler (e:Event):void
		{
			outTween (e.target.parent.skin);
		}
		
		protected function outTween (skin:*):void{}
		
		// ** Disabled Handler - received the event related to when the current button need to be activated
		protected function disabledHandler (e:Event):void{}
		
		protected function activateTween (skin:Sprite):void{}
		
		// ** Disabled Handler - received the event related to when the current button need to be resetted
		protected function enabledHandler(e:Event):void
		{
			var skin:Sprite = e.target.skin;
			outTween(skin);	
		}
		
		public function transitionIn():void
		{
			if(menu == null) throw new IllegalOperationError("cannot call this method before the buildMenu one");
		}
		
		public function transitionOut():void
		{
			if(menu == null) throw new IllegalOperationError("cannot call this method before the buildMenu one");
		}
		
		// ** Menu Click Handler
		protected function clickHandler(e:Event):void
		{
			activeId = e.target.id;
			updateMenuStatus(activeId);
		}
		
		public function updateMenuStatus(intId:int):void
		{
			if(menu == null)
			{
				throw new IllegalOperationError("cannot call this method before the buildMenu one");
			} else {
				menu.update(intId);
			}
		}
		
		public function enable(stato:Boolean):void
		{
			if(stato)
			{
				menu.enableMenu();
			}else{
				menu.disableMenu();
			}
		}
	
		
		public function enableMenu():void
		{
			menu.enableMenu();
		}
		
		public function disableMenu():void
		{
			menu.disableMenu();	
		}
		
		public function organizeItems():void{}
		
		public function set menuData(value:Array):void
		{
			menuDataArray = value;	
		}
		
		public function get menuData():Array
		{
			return menuDataArray;
		}
		
	}
}