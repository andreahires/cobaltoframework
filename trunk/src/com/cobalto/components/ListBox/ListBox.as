
//////////////////////////////////////////////////////////////////////
//																	\\
//  LIST_BOX ~ by Zulu*												//---------/////////
//\\ 																\\
//////////////////////////////////////////////////////////////////////

package com.cobalto.components.ListBox
{
	import com.jac.mouse.MouseWheelEnabler;
	import com.cobalto.api.IMainMenu;
	import com.cobalto.components.buttons.ListButton;
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.components.core.IListBox;
	import com.cobalto.components.menu.AbstractMainMenu;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	public class ListBox extends Sprite implements IListBox
	{
		private var _mandatory:Boolean;
		protected var _width:int;
		protected var _height:int;
		protected var _menuTotal:int = 0;
		private var _name:String;
		private var _id:int;
		protected var listBoxButton:ListButton;
		protected var listMenu:AbstractMainMenu;
		protected var listData:Array;
		protected var menuId:int = -1;
		protected var focusIndex:int = -1;
		protected var isMenuExpand:Boolean;
		protected var defaultLabel:String = 'Select Menu';
		protected var listPosition:String = LIST_POSITION_RIGHT;
		protected var FieldName:String;
		protected var FieldValue:String;
		protected var iMainMenClassObject:Class;
		protected var aListButtonClassObject:Class;
		
		public static const ON_LIST_CHANGED:String = 'OnListChanged';
		
		////////////////
		//ANDREA 
		protected var maxNumVrItem:uint=13;
		//////////////////
		
		public static const ITEM_ADDED:String = 'ItemAdded';
		public static const ITEM_ADDED_AT:String = 'ItemAddedAt';
		public static const ITEM_REMOVED_AT:String = 'ItemRemovedAt';
		
		public static const LIST_POSITION_TOP:String = 'Top';
		public static const LIST_POSITION_BOTTOM:String = 'Bottom';
		public static const LIST_POSITION_LEFT:String = 'Left';
		public static const LIST_POSITION_RIGHT:String = 'Right';
		public static const LIST_POSITION_RIGHT_MIDDLE:String = 'RightMiddle';
		public static const LIST_POSITION_CENTER_MIDDLE:String = 'CenterMiddle';
		
		public static const TRANSITION_OUT_COMPLETE:String = 'TransitionOutComplete';
		public static const TRANSITION_IN_COMPLETE:String = 'TransitionInComplete';
		
		public static const COLLAPSE_LIST:String="CollapseList";
		public static const EXPAND_LIST:String="ExpandList";
		
		public static const BUTTON_OVER:String="ButtonOver";
		public static const BUTTON_OUT:String="ButtonOut";
		
		
		public function ListBox(iMainMenu:IMainMenu,aListButton:ListButton, width:int, height:int, Name:String)
		{
			super();
			/*
			   (!Register.isRegistered(iMainMenu)) ? Register.registerClass(iMainMenu) : trace('Sublime Menu List Class has been registered already') ;
			   (!Register.isRegistered(aListButton)) ? Register.registerClass(aListButton) : trace('Sublime ListButton Class has been registered already') ;
			 */
			setName = Name;
			
			aListButtonClassObject = getClass(aListButton);
			iMainMenClassObject = getClass(iMainMenu);
			
			listMenu = iMainMenClassObject as MenuList;
			listBoxButton = aListButtonClassObject as ListButton;
			
			
			ConfigureHandlers();
			
			this.focusRect = false;
			
			_width = width;
			_height = height;
			
			//This is used to add MouseWheel capability to the stage
			//MouseWheelEnabler.init(this); uncomment to add mousewheel support
		}
		
		protected function ConfigureHandlers():void
		{
			addEventListener(FocusEvent.FOCUS_IN,onFocusInHandler);
			addEventListener(FocusEvent.FOCUS_OUT,onFocusOutHandler);
			addEventListener(MenuList.BUTTON_ADD,positionListMenu);
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStageHandler);
				
		}
				
		private function getClass(classObj:*):Class
		{
			var className:String = getQualifiedClassName(classObj).split("::").join(".");
			return getDefinitionByName(className) as Class;
		}
		
		public function onFocusOutHandler(focusEvent:FocusEvent):void
		{
			listBoxButton.onSetFocusOutSkinHandler(listBoxButton);
			removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			collapseList();
		}
		
		public function onFocusInHandler(focusEvent:FocusEvent):void
		{
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			listBoxButton.onSetFocusInSkinHandler(listBoxButton);
		}
		
		public function collapseList():void
		{
			listMenu.transitionOut();
			isMenuExpand = false;
			TweenLite.to(listBoxButton.skin,0.8,{alpha:1,ease:Expo.easeOut});
			this.setChildIndex(listBoxButton,(this.numChildren-1));
			dispatchEvent(new Event(COLLAPSE_LIST,true));
			//MouseWheelEnabler.removeListener();	uncomment to add mousewheel support
		}
		
		public function expandList():void
		{
			this.setChildIndex(listMenu,(this.numChildren-1));
			this.parent.setChildIndex(this,(this.parent.numChildren - 1));
			
			listMenu.transitionIn();
			isMenuExpand = true;
			//TweenLite.to(listBoxButton.skin,0.8,{alpha:.5,ease:Expo.easeOut});
			dispatchEvent(new Event(EXPAND_LIST,true));
			
			//MouseWheelEnabler.addListener(); 	uncomment to add mousewheel support
		}
		
		public function onKeyDown(keyboardEvent:KeyboardEvent):void
		{
			var character:String = String.fromCharCode(keyboardEvent.charCode);
			var iValue:Number = getStringNum(character);
			
			if(keyboardEvent.keyCode === Keyboard.UP)
			{
				selectMenu('UP');
				
			}
			else if(keyboardEvent.keyCode === Keyboard.DOWN)
			{
				selectMenu('DOWN');
			}
			else if(keyboardEvent.keyCode === Keyboard.ENTER)
			{
				onEnterKeyPressed();
			}
			/*
			else
			{
			   expandList();
			}
			*/
			if(iValue >= 0 && iValue !== focusIndex)
			{
				if(focusIndex === -1) setFocusIndexToZero();
				
				var itemButton:PrimitiveButton;
				itemButton = listMenu.itemArray[focusIndex].btn;
				previousMenuOut(itemButton);
				
				focusIndex = iValue;
				
				itemButton = listMenu.itemArray[focusIndex].btn;
				currentMenuOver(itemButton);
				
				selectedIndex = focusIndex;
				onMenuMoveByCharHandler(focusIndex);
				
				setListMenuButton(selectedIndex);
			}
		}
		
		protected function getStringNum(character:String):Number
		{
			var firstChar:int;
			var iValue:Number;
			
			for(var i:int = 0;i < itemArray.length;i++)
			{
				firstChar = String(itemArray[i].toUpperCase().substr(0,1)).indexOf(character.toUpperCase(),0);
				iValue = i;
				
				if(firstChar >= 0)
					return iValue;
			}
			
			return -1;
		}
		
		public function moveMenu(index:int):void
		{
			var btn:PrimitiveButton = listMenu.itemArray[index].btn;
			TweenLite.to(listMenu,0.8,{ease:Expo.easeOut,y:-btn.y});
		}
		
		private function selectMenu(position:String):void
		{
			var itemButton:PrimitiveButton;
			
			switch(position)
			{
				case 'UP':
					
					if((focusIndex <= itemArray.length) && (focusIndex != 0 && focusIndex > 0))
					{
						itemButton = listMenu.itemArray[focusIndex].btn;
						previousMenuOut(itemButton);
						
						focusIndex--;
						
						itemButton = listMenu.itemArray[focusIndex].btn;
						currentMenuOver(itemButton);
						
						selectedIndex = focusIndex;
						
						onMenuMoveUpHandler(itemButton);
					}
					
					if(focusIndex === -1)
					{
						setFocusIndexToZero();
						itemButton = listMenu.itemArray[focusIndex].btn;
						currentMenuOver(itemButton);
					}
					
					break;
				
				case 'DOWN':
					
					if(focusIndex < itemArray.length - 1 && focusIndex >= 0)
					{
						itemButton = listMenu.itemArray[focusIndex].btn;
						previousMenuOut(itemButton)
						
						focusIndex++;
						
						itemButton = listMenu.itemArray[focusIndex].btn;
						currentMenuOver(itemButton);
						
						selectedIndex = focusIndex;
						
						onMenuMoveDownHandler(itemButton);
					}
					
					if(focusIndex === -1)
					{
						setFocusIndexToZero();
						itemButton = listMenu.itemArray[focusIndex].btn;
						currentMenuOver(itemButton);
					}
					
					break;
				
				default:
					break;
			}
			
			setListMenuButton(selectedIndex);
		}
		
		protected function onMenuMoveUpHandler(btn:PrimitiveButton):void
		{
		
		}
		
		protected function onMenuMoveDownHandler(btn:PrimitiveButton):void
		{
			
		}
		
		protected function onMenuMoveByCharHandler(index:int):void
		{
			
		}
		
		private function setFocusIndexToZero():void
		{
			focusIndex = 0;
			selectedIndex = 0;
		}
		
		public function currentMenuOver(btn:PrimitiveButton):void
		{
			btn.skin.alpha = .3;
		}
		
		public function previousMenuOut(btn:PrimitiveButton):void
		{
			btn.skin.alpha = 1;
		}
		
		public function build():void
		{
			if(listBoxButton)
			{
				listBoxButton.removeEventListener(PrimitiveButton.BUTTON_CLICKED,onListButtonClickedHandler);
				listBoxButton.parent.removeChild(listBoxButton);
			}
			
			listBoxButton = new aListButtonClassObject(_width, _height);
			listBoxButton.label = label;
			listBoxButton.build();
			listBoxButton.addEventListener(PrimitiveButton.BUTTON_CLICKED,onListButtonClickedHandler);
			Sprite(listBoxButton.skin).mouseChildren = false;
			listBoxButton.alpha = 0;
			addChild(listBoxButton);
			
			buildListMenu();
			
			MenuList(listMenu as MenuList).setUniqueName=getName;
			listBoxButton.setUniqueName=getName;

			//decorate();
		}
		protected function buildListMenu():void
		{
			if(listMenu)
			{
				listMenu.removeEventListener(PrimitiveButton.BUTTON_CLICKED,onListMenuButtonClickedHandler);
				listMenu.removeEventListener(PrimitiveButton.BUTTON_OVER,onListMenuButtonOver);
				listMenu.removeEventListener(PrimitiveButton.BUTTON_OUT,onListMenuButtonOut);
				listMenu.parent.removeChild(listMenu);
			}
			
			listMenu = new iMainMenClassObject(label + '_list',false);
			MenuList(listMenu as MenuList).setHeight = _height;
			MenuList(listMenu as MenuList).setWidth = _width;
			listMenu.menuData = listDataOf('label');
			listMenu.build();
			
			listMenu.addEventListener(PrimitiveButton.BUTTON_CLICKED,onListMenuButtonClickedHandler);
			listMenu.addEventListener(PrimitiveButton.BUTTON_OVER,onListMenuButtonOver);
			listMenu.addEventListener(PrimitiveButton.BUTTON_OUT,onListMenuButtonOut);
			
			addChild(listMenu);
		}
		
		public function decorate():void
		{
			MenuList(listMenu as MenuList).setUniqueName=getName;
			listBoxButton.setUniqueName=getName;
		}
		
		protected function listDataOf(value:String):Array
		{
			var resultArray : Array = [];
			var i : int = 0;

			while(i<numItems)
			{
				resultArray.push(listData[i][value]);
				++i;
			}
			
			return resultArray;
		}
		
		private function onListButtonClickedHandler(event:Event=null):void
		{
			(isMenuExpand) ? collapseList() : expandList();
		}
		
		//private function onListMenuButtonOver(event:Event):void
		protected function onListMenuButtonOver(event:Event):void
		{
			//dispatchEvent(new Event(BUTTON_OVER,true));
			removeEventListener(FocusEvent.FOCUS_OUT,onFocusOutHandler);
		}
		
		//private function onListMenuButtonOut(event:Event):void
		protected function onListMenuButtonOut(event:Event):void
		{
			//dispatchEvent(new Event(BUTTON_OUT,true));
			addEventListener(FocusEvent.FOCUS_OUT,onFocusOutHandler);
		}
		
		private function onEnterKeyPressed():void
		{
			onListButtonClickedHandler();
		}
		
		protected function onListMenuButtonClickedHandler(event:Event):void
		{
			selectedIndex = event.target.id;
			setListMenuButton(selectedIndex);
			collapseList();
			onChangeHandler(event);
		}
		
		public function onChangeHandler(event:Event=null):void
		{
			
		}
		
		public function defaultSelectedValue(index:int):void
		{
			selectedIndex = index;
		}
		
		protected function onAddedToStageHandler(event:Event):void
		{
			if(selectedIndex!==-1)
			{
				setListMenuButton(selectedIndex);			
			}
		}
		
		private function setListMenuButton(index:int):void
		{
			fieldValue = listDataOf('value')[selectedIndex];
			listBoxButton.setLabel(listDataOf('label')[selectedIndex]);
			dispatchEvent(new Event(ON_LIST_CHANGED,true));
		}
		
		public function organizeItems():void
		{
			
		}
		
		public function set itemArray(array:Array):void
		{
			
		}
		
		public function get itemArray():Array
		{
			return listDataOf('label');
		}
		
		public function addItem(pBtn:PrimitiveButton=null):void
		{
		}
		
		public function get numItems():uint
		{
			return listData.length;
		}
		
		public function transitionIn():void
		{
		}
		
		public function update(id:uint):void
		{
		}
		
		public function transitionOut():void
		{
		}
		
		protected function onTransitionOutEnd():void
		{
			dispatchEvent(new Event(TRANSITION_OUT_COMPLETE));
		}
		
		protected function onTransitionInEnd():void
		{
			dispatchEvent(new Event(TRANSITION_IN_COMPLETE));
		}
		
		public function enableMenu():void
		{
			
		}
		
		public function listMenuPosition(value:String):void
		{
			listPosition = value;
		}
		
		protected function positionListMenu(event:Event=null):void
		{
			
			switch(listPosition)
			{
				case LIST_POSITION_RIGHT_MIDDLE:
					listMenu.x = Math.round(listBoxButton.x + listBoxButton.width);
					listMenu.y = -Math.round(_height / 2) * _menuTotal;
					break;
				
				case LIST_POSITION_CENTER_MIDDLE:
					listMenu.x = 0;
					listMenu.y = -Math.round(_height / 2) * _menuTotal;
					break;
				
				case LIST_POSITION_RIGHT:
					listMenu.x = Math.round(listBoxButton.x + listBoxButton.width);
					listMenu.y = Math.round(listBoxButton.y);
					break;
				
				case LIST_POSITION_LEFT:
					listMenu.x = Math.round(listBoxButton.x - listBoxButton.width);
					listMenu.y = Math.round(listBoxButton.y);
					break;
				
				case LIST_POSITION_TOP:
					listMenu.x = Math.round(listBoxButton.x);
					listMenu.y = Math.round(listBoxButton.y);
					break;
				
				case LIST_POSITION_BOTTOM:
					listMenu.x = Math.round(listBoxButton.x);
					listMenu.y = Math.round(listBoxButton.y + listBoxButton.height);
					break;
				
				default:
					break;
			}
			
			_menuTotal++;
			
			if(_menuTotal === numItems) decorate();
		}
		
		public function addItemAt(value:String,index:int):void
		{
		}
		
		public function removeItemAt(index:int):void
		{
		}
		
		public function reset():void
		{
			label = defaultLabel;
			listBoxButton.setLabel(label);
			listMenu.enableMenu();
			menuId = -1;
			focusIndex = -1;
			collapseList();
			fieldValue = listDataOf('value')[selectedIndex]
		}
		
		public function getData():Object
		{
			return {id:selectedIndex, textValue:listDataOf('label')[selectedIndex], type:'ListBox', name:getName, fieldName:fieldName, fieldValue:fieldValue};
		}
		
		public function setData(value:String):void
		{
			var selecId :int = -1;
			var i:int=0;
			var dataLength : int = dataProvider.length;
			
			while(i<dataLength)
			{
				if(value.toUpperCase()===dataProvider[i].value.toString().toUpperCase())
				{
					selecId=i;
				}
				
				++i;
			}
			
			selectedIndex = selecId;

			if( listDataOf('label')[selectedIndex] )
			{
				fieldValue = listDataOf('value')[selectedIndex];
				listBoxButton.setLabel(listDataOf('label')[selectedIndex]);
			}
			
			//trace('  listBoxButton ->>  ', listBoxButton);
		}
		
		public function onSetFocusInSkinHandler(target:InteractiveObject):void
		{
			
		};
		
		public function onSetFocusOutSkinHandler(target:InteractiveObject):void
		{
			
		};
		
		public function onDisableSkinHandler(target:InteractiveObject):void
		{
		};
		
		public function onEnableSkinHandler(target:InteractiveObject):void
		{
		};
		
		public function onErrorSkinHandler(target:InteractiveObject):void
		{
		};
		
		public function get mandatory():Boolean
		{
			return _mandatory
		}
		
		public function set mandatory(value:Boolean):void
		{
			_mandatory = value
		}
		
		public function set label(value:String):void
		{
			defaultLabel = value;
		}
		
		public function get label():String
		{
			return defaultLabel;
		}
		
		public function set id(uniqueId:int):void
		{
			_id =uniqueId;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function disableMenu():void
		{
		
		}
		
		public function get activeId():uint
		{
			return menuId;
		}
		
		public function set selectedIndex(value:int):void
		{
			menuId = value;
		}
		
		public function get selectedIndex():int
		{
			return menuId;
		}
		
		public function get displayObject():DisplayObject
		{
			return null;
		}
		
		public function set dataProvider(value:Array):void
		{
			listData = value;
		}
		
		public function get dataProvider():Array
		{
			return listData;
		}
		
		public function get fieldName():String
		{
			return FieldName;
		}
		
		public function set fieldName(value:String):void
		{
			FieldName = value;
		}
		
		public function set setName(value:String):void
		{
			_name = value;
		}
		
		public function get getName():String
		{
			return _name;
		}
		
		public function set fieldValue (value:String):void
		{
			FieldValue =value;
		}
		
		public function get fieldValue():String
		{
			return FieldValue;
		}
		
		public function get isExpanded():Boolean
		{
			return isMenuExpand;
		}
	}
}