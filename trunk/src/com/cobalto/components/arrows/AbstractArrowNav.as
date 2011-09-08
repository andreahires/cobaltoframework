
///////   ANDREA OLD VERSIONE REPLACED TO THE NEW ONE TO MAKE THE SCROLLER WORK
package com.cobalto.components.arrows
{
	import com.cobalto.api.IViewComponent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import com.cobalto.components.menu.BasicMenu;
	import com.cobalto.components.buttons.PrimitiveButton;
	
	// ABSTRACT CLASS - It shouldn't instantiated, it should be always subclasses
	
	public class AbstractArrowNav extends Sprite implements IViewComponent
	{
		
		protected var _arrowMenu:BasicMenu;
		
		protected var _itemsNum:uint;
		
		protected var _backSkin:Sprite;
		
		protected var _nextSkin:Sprite;
		
		protected var _activeId:uint = 0;
		
		protected var _id:uint;
		
		public static const ARROW_NEXT_CLICK:String = "ArrowNextClick";
		
		public static const ARROW_NEXT_OVER:String = "ArrowNextOver";
		
		public static const ARROW_NEXT_OUT:String = "ArrowNextOut";
		
		public static const ARROW_BACK_CLICK:String = "ArrowBackClick";
		
		public static const ARROW_BACK_OVER:String = "ArrowBackOver";
		
		public static const ARROW_BACK_OUT:String = "ArrowBackOut";
		
		public function createArrows(backSkin:Sprite,nextSkin:Sprite):void
		{

			_backSkin = backSkin;
			_nextSkin = nextSkin;
			build(2);
		}
		
		//*** create a menu that contains 2 items (the arrows)
		public function build(itemTotal:uint):void
		{

			_arrowMenu = new BasicMenu();
			_arrowMenu.addEventListener(BasicMenu.BUTTON_ADDED,onArrowAdded);
			_arrowMenu.addEventListener(PrimitiveButton.BUTTON_CLICKED,onArrowClick);
			_arrowMenu.addEventListener(PrimitiveButton.BUTTON_OVER,onArrowOver);
			_arrowMenu.addEventListener(PrimitiveButton.BUTTON_OUT,onArrowOut);
			_arrowMenu.build(itemTotal);
			addChild(_arrowMenu);
			updateArrowStates();

		}
		
		public function setOffset(x:uint,y:uint):void
		{
			
			_arrowMenu.setOffset(x,y);
		
		}
		
		//*** based on the id we can understand if it is tha back or the next arrow
		protected function onArrowAdded(e:Event):void
		{
			//*** we can assign the skin
			if(e.target.id == 0)
			{
				e.target.skin = _backSkin;
				showArrow(0,false);
			}
			else
			{
				e.target.skin = _nextSkin;
				showArrow(1,false);
			}
			
			//e.target.showHitArea(true);
			
			if(e.target.id == 1)
				updateArrowStates();
		}
		
		protected function onArrowClick(e:Event):void
		{
			//*** on the click we updaate the active id and update the status of the arrows (visibility)
			if(e.target.id == 0)
			{
				_activeId--;
				updateArrowStates();
				dispatchEvent(new Event(ARROW_BACK_CLICK,true));
				
			}
			else
			{
				_activeId++;
				updateArrowStates();
				dispatchEvent(new Event(ARROW_NEXT_CLICK,true));
				
			}
		
		}
		
		public function dealWithScroller():void
		{
			
			if(_activeId == 0)
			{
				
				showArrow(0,false);
				showArrow(1,true);
				
			}
			else if(_activeId > 0 && _activeId < _itemsNum)
			{
				
				showArrow(0,true);
				showArrow(1,true);
				
			}
			else
			{
				
				showArrow(0,true);
				showArrow(1,false);
				
			}
		
		}
		
		//** function to display or hide the arrows... 
		//** override this to hide or display arrows with transitions
		public function showArrow(arrowId:uint,state:Boolean=true):void
		{

			if(_arrowMenu.itemArray[arrowId].mc.skin)
			{
				if(state)
				{
					_arrowMenu.itemArray[arrowId].mc.skin.visible = state;
				}
				else
				{
					_arrowMenu.itemArray[arrowId].mc.skin.visible = state;
				}
				
				_arrowMenu.itemArray[arrowId].mc.mouseChildren = state;
				_arrowMenu.itemArray[arrowId].mc.mouseEnabled = state;
			}
		}
		
		//*** based on the set itemlength manage the visibility of the back/next arrow
		protected function updateArrowStates():void
		{
			
			//trace(activeId+'activeId - length'+itemLength);
			
			if(activeId + 1 > itemLength)
			{
				showArrow(1,false);
			}
			else
			{
				showArrow(1,true);
			}
			
			if(activeId - 1 < 0)
			{
				showArrow(0,false);
			}
			else
			{
				showArrow(0,true);
			}
			
			if(itemLength == 0)
			{
				showArrow(0,false);
				showArrow(1,false);
			}
				
		
		}
		
		protected function onArrowOver(e:Event):void
		{
		
		}
		
		protected function onArrowOut(e:Event):void
		{
		
		}
		
		// * getter - setters 
		public function set itemLength(num:int):void
		{
			if(num < 0)
				num = 0;
			
			_itemsNum = num;
			
			if(_arrowMenu)
				updateArrowStates();
		}
		
		public function get itemLength():int
		{
			return _itemsNum;
		}
		
		public function set nextSkin(skin:Sprite):void
		{
			_nextSkin = skin;
		}
		
		public function set backSkin(skin:Sprite):void
		{
			_backSkin = skin;
		}
		
		public function get backArrow():PrimitiveButton
		{
			return _arrowMenu.itemArray[0].mc;
		}
		
		public function get nextArrow():PrimitiveButton
		{
			return _arrowMenu.itemArray[1].mc;
		}
		
		public function get activeId():uint
		{
			return _activeId;
		}
		
		public function set activeId(id:uint):void
		{
			_activeId = id;
			updateArrowStates();
		}
		
		public function organizeItems():void
		{
		
		}
		
		public function transitionIn():void
		{
		
		}
		
		public function transitionOut():void
		{
		
		}
		
		public function set id(pageId:int):void
		{
			_id = pageId;
		}
		
		public function get id():int
		{
			return _id;
		}
	
	}

}
