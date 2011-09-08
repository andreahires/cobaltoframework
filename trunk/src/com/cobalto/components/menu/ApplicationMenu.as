package com.cobalto.components.menu
{
	import com.cobalto.api.IApplicationMenu;
	import com.cobalto.api.IMainMenu;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import com.cobalto.components.buttons.PrimitiveButton;
	
	public class ApplicationMenu extends Sprite implements IApplicationMenu
	{
		protected var subMenuArray:Array = new Array();
		
		protected var _isReady:Boolean = false;
		
		//*** the first level menu reference
		protected var _rootMenu:AbstractMainMultiLevel;
		
		//*** the rootMenu and subMenus Container
		protected var menuHolder:Sprite = new Sprite();
		//** the last menu requested??
		protected var _last:IMainMenu;
		
		//** the menu requested??
		protected var _requested:IMainMenu;
		
		// *** the history array store all the active subMenus and it is useful 
		// *** to understand the current navigation depth
		protected var historyArray:Array = [];
		
		//*** the last index array requested
		protected var _lastIndexArray:Array = [];
		
		//*** the last button indexRequested
		protected var _lastIndex:uint;
		
		// *** the last menu clicked
		protected var _lastMenuClicked:AbstractMainMultiLevel;
		
		//*** the menu to open according to the swf adress
		protected var _firstMenuToOpen:AbstractMainMultiLevel;
		
		//***store the value of the siteTree array
		protected var siteTreeArray:Array;
		
		// *** the event dispatch to inform the system to change page (onClick)
		public static const PAGE_CHANGE:String = "PageChange";
		
		// @param rootMenu
		public function ApplicationMenu(rootMenu:AbstractMainMultiLevel)
		{
			super();
			
			//*** create the array that hold the informations on the past clicks
			historyArray = new Array();
			
			//*** root menu is the first level menu
			_rootMenu = rootMenu;
			
			//**** add a sprite holder to the display list
			addChild(menuHolder);
			
			this.mouseEnabled = false;
			
			setRootMenuProp();
		}
		
		//** set listener to the rootMenu and build it
		protected function setRootMenuProp():void
		{
			
			_rootMenu.addEventListener(PrimitiveButton.BUTTON_CLICKED,onMenuClickHandler);
			_rootMenu.addEventListener(AbstractMainMenu.TRANSITION_IN_COMPLETE,transitionInListener);
			_rootMenu.addEventListener(AbstractMainMenu.BUTTON_OVER,onMenuOverHandler);
			_rootMenu.addEventListener(AbstractMainMenu.BUTTON_OUT,onMenuOutHandler);
			_rootMenu.depth = 0;
			_rootMenu.build();
			
			subMenuArray[0] = [_rootMenu];
			
			menuHolder.addChild(_rootMenu);
		}
		
		// ** add the subMenus from the Mediator
		public function addSubMenu(subMenu:AbstractMainMultiLevel,indexes:Array):void
		{
			var indexesLength:uint = indexes.length;
			
			//** set the depth for the subMenu
			subMenu.depth = indexesLength;
			
			//** set the indexes
			subMenu.indexes = indexes;
			
			//** add the click listener
			subMenu.addEventListener(PrimitiveButton.BUTTON_CLICKED,onMenuClickHandler);
			subMenu.addEventListener(AbstractMainMenu.BUTTON_OVER,onMenuOverHandler);
			subMenu.addEventListener(AbstractMainMenu.BUTTON_OUT,onMenuOutHandler);
			
			//** variable useful to assign the childs on the subMenu for the composite pattern
			var toPutOn:AbstractMainMultiLevel = _rootMenu;
			var baseSiteTreeLevel:Array = siteTreeArray;
			var lastObject:Object;
			
			//*** loop through the indexes of the subMenu to add
			for(var i:uint = 0;i < indexesLength;i++)
			{
				
				//*** add the subMenu display object on the siteTreeArray
				if(i == indexesLength - 1)
				{
					
					baseSiteTreeLevel[indexes[i]].subMenuDisplay = subMenu;
					
					toPutOn.arrayFigli[indexes[i]] = subMenu;
					
					subMenu.nome = "menu" + indexes.toString();
					subMenu.build();
					menuHolder.addChild(subMenu);
					
					if(!subMenuArray[i + 1])
						subMenuArray[i + 1] = [];
					subMenuArray[i + 1].push(subMenu);
					
					subMenu.y = toPutOn.y + indexes[i] * 20;
				}
				
				baseSiteTreeLevel = baseSiteTreeLevel[indexes[i]].subMenu;
				
				//** set the parent menu for the next loop
				toPutOn = toPutOn.arrayFigli[indexes[i]];
				
			}
		
		}
		
		protected function onMenuOverHandler(e:Event):void
		{
		}
		
		protected function onMenuOutHandler(e:Event):void
		{
		}
		
		//** when any button of the menu is clicked
		protected function onMenuClickHandler(e:Event):void
		{
			//** get the instance of the clicked menu
			var clickedMenu:AbstractMainMultiLevel = e.currentTarget as AbstractMainMultiLevel;
			
			//** manage the multilevel transitions
			//manageNestedActions(clickedMenu, e.target.id);
			
			//** compose the indexArray that will be send as note body to the framework
			var indexArray:Array = clickedMenu.indexes.concat();
			indexArray.push(e.target.id);
			
			activate(indexArray);
			
			//_lastIndexArray = indexArray.concat();
			//**dispatch the event
			dispatchEvent(new Event(PAGE_CHANGE));
		}
		
		//*** very important function that embed the logic of transitions of the menu
		protected function manageNestedActions(clickedMenu:AbstractMainMultiLevel,idRequested:uint):void
		{
			//** set the last insed
			_lastIndex = idRequested;
			
			//** set the last clicked menu useful at the transitionOutComplete
			_lastMenuClicked = clickedMenu;
			
			if(historyArray.length - 1 == clickedMenu.depth || historyArray.length == 0)
			{
				//trace(historyArray.length-1 +"+ compare +"+ clickedMenu.depth);
				// *** if the clicked menu is in the current navigation level 
				// *** it just start the transition in of the requested id subMenu (if it exist)
				//clickedMenu.addEventListener(AbstractMainMenu.TRANSITION_IN_COMPLETE, transitionInListener);
				if(clickedMenu.arrayFigli[idRequested])
					clickedMenu.arrayFigli[idRequested].addEventListener(AbstractMainMenu.TRANSITION_IN_COMPLETE,transitionInListener);
				clickedMenu.transitionInSubAt(idRequested);
				
			}
			else
			{
				
				//** if the history length is superior to the depth it start the transition out of the last level
				
				historyArray[historyArray.length - 1].addEventListener(AbstractMainMenu.TRANSITION_OUT,transitionOutListener);
				
				if(historyArray[historyArray.length - 1] != _rootMenu)
					historyArray[historyArray.length - 1].transitionOut();
			}
		
		}
		
		//*** on the transition In Complete of the menus it add a level on the history
		protected function transitionInListener(e:Event):void
		{
			var targetMenu:AbstractMainMultiLevel = e.target as AbstractMainMultiLevel;
			targetMenu.removeEventListener(AbstractMainMenu.TRANSITION_IN_COMPLETE,transitionInListener);
			
			addToHistory(targetMenu);
		}
		
		protected function addToHistory(subMenu:AbstractMainMultiLevel):void
		{
			historyArray.push(subMenu);
		}
		
		// ** on the trasition out complete of the menus it remove a level from the history
		protected function transitionOutListener(e:Event):void
		{
			historyArray[historyArray.length - 1].removeEventListener(AbstractMainMenu.TRANSITION_OUT,transitionOutListener);
			historyArray.pop();
			
			// *** restart the logic until the correct level
			manageNestedActions(_lastMenuClicked,_lastIndex);
		}
		
		public function disable(menu:IMainMenu):void
		{
			var childrenTot:uint = this.numChildren;
			
			for(var i:uint = 0;i < childrenTot;i++)
			{
				var menuItems:IMainMenu = (this.getChildAt(i) as AbstractMainMenu);
				(menuItems as AbstractMainMenu).disableMenu();
			}
			_last = menu;
		
		}
		
		public function disableMenu():void
		{
			
			var childrenTot:uint = menuHolder.numChildren;
			
			for(var i:uint = 0;i < childrenTot;i++)
			{
				var menuItems:AbstractMainMultiLevel = menuHolder.getChildAt(i) as AbstractMainMultiLevel;
				
				if(menuItems)
					menuItems.disableMenu();
			}
		
		}
		
		public function enableMenu():void
		{
			
			var childrenTot:uint = menuHolder.numChildren;
			
			for(var i:uint = 0;i < childrenTot;i++)
			{
				var menuItems:AbstractMainMultiLevel = menuHolder.getChildAt(i) as AbstractMainMultiLevel;
				
				if(menuItems)
					menuItems.enableMenu();
			}
		
		}
		
		public function enable():void
		{
			// code for resetting the menu as before
		}
		
		//*** function useful to activate the menu externally
		public function activate(indexArray:Array):void
		{
			
			if(_isReady)
			{
				//*** if the lastindex is not set it mean the menu is not still clicked
				if(_lastIndexArray.length == 0)
				{
					_lastIndexArray = indexArray.concat();
				}
				else
				{
					
					updateMenus(indexArray);
				}
			}
		}
		
		//*** update the menu on a requested index		
		protected function updateMenus(indexArray:Array):void
		{
			
			//** if the last index is egual to the requested one
			//** the request is probably caused by the click
			if(_lastIndexArray.toString() != indexArray.toString())
			{
				//*** create a new history array
				var newHistoryArray:Array = [];
				
				//** a variable that store the parent array level to retrieve the siteTree menu data on the loop
				var previousLevelMenuArray:Array = siteTreeArray;
				
				//*** the 0 index of the history is originally empty????
				newHistoryArray[0] = null;
				
				_rootMenu.update(indexArray[0]);
				
				//*** find the max length between the requested indexes and the history 
				var maxLength:uint = Math.max(indexArray.length,historyArray.length) + 1;
				
				//*** loop through 10 level starting from the first one (temp)
				for(var i:int = 1;i < maxLength;i++)
				{
					//** retrieve the subMenu for the level from the history
					var oldSubMenu:AbstractMainMultiLevel = historyArray[i];
					
					//** if the current level is inside the requested length
					if(indexArray[i] != null)
					{
						
						//*** if the parent level has the same index it mean the 
						//*** requested submenu for this level is the same of the current one
						if(oldSubMenu)
						{
							var newSubMenu:AbstractMainMultiLevel;
							
							var indexSlice:Array = indexArray.slice(0,i);
							
							//trace(indexSlice +" compare parents "+ oldSubMenu.indexes.toString());
							if(indexSlice.toString() == oldSubMenu.indexes.toString())
							{
								//** populate the new history with the oldMenu
								newHistoryArray.push(historyArray[i]);
								oldSubMenu.update(indexArray[i]);
								
							}
							else
							{
								
								//*** if exist transition out the old menu for this level
								oldSubMenu.transitionOut();
								
								//*** retrieve the correct subMenu from the siteTree array
								newSubMenu = previousLevelMenuArray[indexArray[i - 1]].subMenuDisplay;
								
								//** transition in and update the the new menu
								newSubMenu.transitionIn();
								newSubMenu.update(indexArray[i - 1]);
								
								//** populate the new history with the newMenu
								newHistoryArray.push(newSubMenu);
								
							}
							
						}
						else
						{
							
							//*** retrieve the correct subMenu from the siteTree array
							newSubMenu = previousLevelMenuArray[indexArray[i - 1]].subMenuDisplay;
							
							//** transition in and update the the new menu
							newSubMenu.transitionIn();
							newSubMenu.update(indexArray[i]);
							
							//** populate the new history with the newMenu
							newHistoryArray.push(newSubMenu);
							
						}
						
						previousLevelMenuArray = previousLevelMenuArray[indexArray[i - 1]].subMenu;
						
					}
					else
					{
						//*** if the level has a subMenu it call the transition out for it
						if(oldSubMenu)
							oldSubMenu.transitionOut();
					}
					
				}
				
				//*** update the history with the new one
				historyArray = newHistoryArray;
				//trace(historyArray.length+" his length adter update");
				//*** update the last indexArray with the new requested
				_lastIndexArray = indexArray;
				_lastIndex = indexArray[indexArray.length - 1];
				
			}
		
		}
		
		protected function updateLevel():void
		{
		}
		
		//*** useful to pass the multidimensional array of the siteTree from the mediator
		public function set siteTreeData(arr:Array):void
		{
			siteTreeArray = arr;
		}
		
		public function organizeItems():void
		{
		}
		
		public function get lastIndexArray():Array
		{
			trace("last index Array" + _lastIndexArray);
			return _lastIndexArray;
		}
		
		public function transitionIn():void
		{
			_isReady = true;
			_rootMenu.transitionIn();
			activate(_lastIndexArray);
		}
	}
}