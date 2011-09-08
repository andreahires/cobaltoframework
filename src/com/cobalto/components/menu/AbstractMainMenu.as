package com.cobalto.components.menu
{
	
	import com.cobalto.api.IIterator;
	import com.cobalto.api.IMainMenu;
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.events.MenuEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	public class AbstractMainMenu extends Sprite implements IMainMenu
	{
		//** event that inform that the menu is added to the displayList
		public static const ABSTRACT_MAIN_MENU_ADDED:String = "AbstractMainMenuAdded";
		
		//** event that inform that all the buttons are created
		public static const ADDED_READY:String = "AddedReady";
		public static const BUTTON_OVER:String = "MenuButtonOver";
		public static const BUTTON_OUT:String = "MenuButtonOut";
		
		//** transitions Events
		public static const TRANSITION_OUT:String = "transition_out";
		public static const TRANSITION_IN:String = "transition_in";
		public static const TRANSITION_OUT_COMPLETE:String = "transition_out_complete";
		public static const TRANSITION_IN_COMPLETE:String = "transition_in_complete";
		
		//*** array that contains the menu items
		protected var _itemsArray:Array;
		
		//** the array of the labels
		protected var _arrayData:Array;
		
		//** the selected button id
		protected var _activeId:uint;
		
		//** the last over button id
		protected var _buttonOverId:uint;
		
		//** the last out button id
		protected var _buttonOutId:uint;
		
		//** the basic menu added by composition
		protected var menu:BasicMenu;
		
		//** variable to understand if the first item of the menu need to be selected when created
		protected var disableFirst:Boolean;
		
		//** the id of the menu itSelf
		protected var _menuId:uint;
		
		//*** the name of the menu itself
		public var nome:String;
		
		//*** optional params object
		protected var paramsObj:Object;
		
		//** contructor
		//** @param nome - the name of the menu
		//** @param autoselect - an optional parameter to understand if 
		//	the first item of the menu need to be selected when created
		
		public function AbstractMainMenu(nome:String,autoSelex:Boolean=false)
		{
			super();
			this.nome = nome;
			this.disableFirst = autoSelex;
			this.addEventListener(Event.ADDED_TO_STAGE,addedListener);
			
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		// *** added event of this menu itself
		protected function addedListener(e:Event):void
		{
			dispatchEvent(new Event(AbstractMainMenu.ABSTRACT_MAIN_MENU_ADDED,true));
		}
		
		// *** set array for the menu data, an array of labels
		public function set menuData(array:Array):void
		{
			_arrayData = array;
		}
		
		public function build():void
		{
			
			// *** create the basic menu through composition
			if(_arrayData == null)
			{
				throw new IllegalOperationError("set the data first before calling the init function");
			}
			else
			{
				_itemsArray = [];
				menu = new BasicMenu();
				menu.addEventListener(BasicMenu.BUTTON_ADDED,addedHandler);
				menu.addEventListener(BasicMenu.BUTTON_ENABLED,enabledHandler);
				menu.addEventListener(BasicMenu.BUTTON_DISABLED,disabledHandler);
				menu.addEventListener(PrimitiveButton.BUTTON_OVER,overHandler);
				menu.addEventListener(PrimitiveButton.BUTTON_OUT,outHandler);
				menu.addEventListener(PrimitiveButton.BUTTON_CLICKED,clickHandler);
				menu.build(_arrayData.length);
				addChild(menu);
				
			}
		
		}
		
		//*** pass here when the button is added on displayList
		public function addedHandler(e:Event):void
		{
			var index:uint = e.target.id;
			var pb:PrimitiveButton = e.target as PrimitiveButton;
			
			//** push on the array the item inside an object
			_itemsArray.push({btn:pb});
			
			//*** when the last item is added it dispatch the ADDED_READY event
			if(index == _arrayData.length - 1)
				setUpTopMenu();
		}
		
		public function setUpTopMenu():void
		{
			//menu.removeEventListener(BasicMenu.BUTTON_ADDED, addedHandler);	
			dispatchEvent(new Event(ADDED_READY,true));
		}
		
		//** transition in of the menu
		public function transitionIn():void
		{
			throw new IllegalOperationError("transition In called from an Abstract Class should be overrided");
		}
		
		//** transition out of the menu
		public function transitionOut():void
		{
			throw new IllegalOperationError("transition Out called from an Abstract Class should be overrided");
		}
		
		// ** useful to enable a specific item of the menu
		public function enableAt(k:uint):void
		{
			throw new IllegalOperationError("enable at called from an Abstract Class should be overrided");
		}
		
		// ** useful to disable a specific item of the menu
		public function disableAt(k:uint):void
		{
			throw new IllegalOperationError("disable at called from an Abstract Class should be overrided");
		}
		
		// ** TODO - it hadn't be implemented yet
		public function addItem(item:PrimitiveButton=null):void
		{
			throw new IllegalOperationError("addItem called from an Abstract Class should be overrided");
		}
		
		//** enable the internal basicMenu
		public function enableMenu():void
		{
			menu.enableMenu();
		}
		
		//** disable the internal basicMenu
		public function disableMenu():void
		{
			menu.disableMenu();
		}
		
		//** ??? is it useful on the MainMultilevelMenu maybe??
		public function iterator():IIterator
		{
			return null;
		}
		
		//*** this should go on the MainMultilevelMenu too
		public function addSubMenu(imenu:IMainMenu,nome:String,id:uint):void
		{
			throw new IllegalOperationError("addSubMenu called from an Abstract Class");
		}
		
		public function organizeItems():void
		{
			throw new IllegalOperationError("organizeItems called from an Abstract Class should be overrided");
		}
		
		protected function enabledHandler(e:Event):void
		{
			throw new IllegalOperationError("abstract enabled handler should be overriden in the concrete class");
		}
		
		protected function disabledHandler(e:Event):void
		{
			throw new IllegalOperationError("abstract disabled handler should be overriden in the concrete class");
		}
		
		protected function overHandler(e:Event=null):void
		{
			_buttonOverId = e.target.id;
			dispatchEvent(new Event(BUTTON_OVER));
		}
		
		protected function outHandler(e:Event=null):void
		{
			_buttonOutId = e.target.id;
			dispatchEvent(new Event(BUTTON_OUT));
		}
		
		// ** set the active id, disable the selected item and dispatch the event
		protected function clickHandler(e:Event=null):void
		{
			_activeId = e.target.id;
			update(e.target.id);
		
			//*** this custom event could be avoided just catching the activeId of this menu from the parent
			// without to send it as body of the event
			//dispatchEvent(new MenuEvent(MenuEvent.FIRE,true,false,e.target.id));		
		}
		
		//** disable the selected button and enable the other buttons
		public function update(id:uint):void
		{
			if(menu)menu.update(id);
		}
		
		protected function onRemoved(e:Event):void
		{
			destroy();
		}
		
		public function destroy():void
		{
			if(!menu)return;
			menu.removeEventListener(BasicMenu.BUTTON_ADDED,addedHandler);
			menu.removeEventListener(BasicMenu.BUTTON_ENABLED,enabledHandler);
			menu.removeEventListener(BasicMenu.BUTTON_DISABLED,disabledHandler);
			menu.removeEventListener(PrimitiveButton.BUTTON_OVER,overHandler);
			menu.removeEventListener(PrimitiveButton.BUTTON_OUT,outHandler);
			menu.removeEventListener(PrimitiveButton.BUTTON_CLICKED,clickHandler);
			menu = null;
			
			_itemsArray = null;
			_arrayData = null;
			paramsObj = null;
		}
		
		//** get the array of the buttons
		public function get itemArray():Array
		{
			return _itemsArray;
		}
		
		//** set the buttons array - not very useful and maybe dangerous
		public function set itemArray(array:Array):void
		{
			_itemsArray = array;
		}
		
		//** return the item total
		public function get numItems():uint
		{
			return _itemsArray.length;
		}
		
		//** return the selected button
		public function get activeId():uint
		{
			return _activeId;
		}
		
		public function get id():int
		{
			return _menuId;
		}
		
		public function set id(pageId:int):void
		{
			_menuId = pageId;
		}
		
		public function get displayObject():DisplayObject
		{
			return this;
		}
		
		public function get overId():uint
		{
			return _buttonOverId;
		}
		
		public function get outId():uint
		{
			return _buttonOutId;
		}
		
		public function set params(obj:Object):void
		{
			paramsObj = obj;
		}
		
		public function get params():Object
		{
			return paramsObj;
		}
	
	}
}