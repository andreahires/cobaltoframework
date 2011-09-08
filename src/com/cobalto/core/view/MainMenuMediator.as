package com.cobalto.core.view
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.api.IMainMenu;
	import com.cobalto.components.menu.AbstractMainMenu;
	import com.cobalto.components.menu.AbstractMainMultiLevel;
	import com.cobalto.components.menu.ApplicationMenu;
	import com.cobalto.core.model.SiteTreeProxy;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainMenuMediator extends Mediator implements IMediator
	{
		protected var _mainMenu:ApplicationMenu;
		protected var _rootMainMenu:IMainMenu;
		protected var _stage:Stage;
		protected var siteTreeProxy:SiteTreeProxy;
		protected var levelsArray:Array;
		
		public static var NAME:String = "MainMenuMediator";
		
		public function MainMenuMediator(stageRef:Stage)
		{
			super(NAME);
			_stage = stageRef;
			siteTreeProxy = SiteTreeProxy(facade.retrieveProxy("SiteTreeProxy"));
			createMainMenu();
		}
		
		protected function createMainMenu():void
		{
			
			var rootMenuClass:Class = ApplicationFacade._rootMainMenuClass;
			
			_rootMainMenu = new rootMenuClass("rootMainMenu",false);
			_rootMainMenu.menuData = siteTreeProxy.getMenuData();
			AbstractMainMultiLevel(_rootMainMenu).indexes = [];
			AbstractMainMultiLevel(_rootMainMenu).params = [];
			
			var applicationMenuClass:Class = ApplicationFacade.applicationMenuMainComponentClass;
			_mainMenu = new applicationMenuClass(_rootMainMenu as AbstractMainMultiLevel);
			_mainMenu.siteTreeData = siteTreeProxy.getTree();
			_mainMenu.addEventListener(ApplicationMenu.PAGE_CHANGE,onPageChange);
			_mainMenu.x = 150;
			_mainMenu.y = 50;
			
			//*** create refClass references 
			var refClassArray:Array = new Array();
			var rootMenuLength:int = siteTreeProxy.getMenuData().length;
			
			for(var i:uint = 0;i < rootMenuLength;i++)
			{
				refClassArray.push(siteTreeProxy.getRefClass([i]));
			}
			
			AbstractMainMultiLevel(_rootMainMenu).params = refClassArray;
			
			createFirstSubMenus(siteTreeProxy.getMenuData());
			
			_stage.addChild(_mainMenu);
			//_rootMainMenu.transitionIn();
			_mainMenu.organizeItems();
		
		}
		
		protected function onPageChange(e:Event):void
		{
			
			sendNotification(ApplicationFacade.PAGE_CHANGE,_mainMenu.lastIndexArray.concat());
		}
		
		protected function createFirstSubMenus(parentMenuArray:Array):void
		{
			
			var subMenuClass:Class = ApplicationFacade._subLevelMenuClass;
			
			for(var i:int = 0;i < parentMenuArray.length;i++)
			{
				
				var subMenuArray:Array = siteTreeProxy.getSubMenuData(i);
				
				if(subMenuArray.length > 0)
				{
					//trace("subMenuDAta" + subMenuArray);
					var newSubMenu:AbstractMainMultiLevel = new subMenuClass("subMenu" + i,false) as AbstractMainMultiLevel;
					newSubMenu.addEventListener(AbstractMainMenu.ADDED_READY,onSubMenuAdded);
					
					var indexArray:Array = [i];
					newSubMenu.menuData = subMenuArray;
					
					var refClassArray:Array = siteTreeProxy.getRefClassArray([i]);
					newSubMenu.params = refClassArray;
					
					_mainMenu.addSubMenu(newSubMenu,indexArray);
					newSubMenu.x = 130;
					
					createSubMenus(subMenuArray,i);
				}
				
			}
		
		}
		
		protected function createSubMenus(parentMenuArray:Array,startId:int,levelArray:Array=null):void
		{
			var subMenuClass:Class = ApplicationFacade._subLevelMenuClass;
			
			for(var i:int = 0;i < parentMenuArray.length;i++)
			{
				
				var newLevelArray:Array;
				
				if(levelArray == null)
				{
					newLevelArray = [i];
				}
				else
				{
					newLevelArray = levelArray.concat();
					newLevelArray.push(i);
				}
				
				var subMenuArray:Array = siteTreeProxy.getSubMenuData(startId,newLevelArray);
				
				if(subMenuArray.length > 0)
				{
					
					var newSubMenu:AbstractMainMultiLevel = new subMenuClass("subMenu" + i,false);
					newSubMenu.addEventListener(AbstractMainMenu.ADDED_READY,onSubMenuAdded);
					newSubMenu.menuData = subMenuArray;
					newSubMenu.x = 130 * (newLevelArray.length + 1);
					
					var indexArray:Array = newLevelArray.concat();
					indexArray.unshift(startId);
					
					var refClassArray:Array = siteTreeProxy.getRefClassArray(indexArray.concat());
					newSubMenu.params = refClassArray;
					
					_mainMenu.addSubMenu(newSubMenu,indexArray);
					
					createSubMenus(subMenuArray,startId,newLevelArray);
					
				}
				
			}
		
		}
		
		protected function onSubMenuAdded(e:Event):void
		{
			//e.target.transitionIn();
			//trace(e.target+" submenu");
		}
		
		public function updateMenus(indexArray:Array):void
		{
			//TODO check if the requested menu should be visualized or not
			//var hasMenu:Boolean = siteTreeProxy.hasMenuVisible(indexArray;
			_mainMenu.activate(indexArray.concat());
		}
		
		protected function onButtonClicked(e:Event):void
		{
		
			//sendNotification(ApplicationFacade.PAGE_CHANGE,e.target.id);
		}
		
		// Return list of Nofitication names that Mediator is interested in
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.STAGE_RESIZE,ApplicationFacade.MENU_STATE_UPDATE,ApplicationFacade.PAGE_DATA_COMPLETE];
		}
		
		public function enable(val:Boolean=false):void
		{
		
		}
		
		// Handle all notifications this Mediator is interested in
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case ApplicationFacade.STAGE_RESIZE:
					
					_mainMenu.organizeItems();
					break;
				
				case ApplicationFacade.MENU_STATE_UPDATE:
					
					if(note.getBody() == false)
					{
						_mainMenu.disableMenu();
					}
					else
					{
						_mainMenu.enableMenu();
					}
					break;
				
				case ApplicationFacade.PAGE_DATA_COMPLETE:
					_mainMenu.transitionIn();
					//_rootMainMenu.transitionIn();
					break;
			
			}
		}
	
	}
}