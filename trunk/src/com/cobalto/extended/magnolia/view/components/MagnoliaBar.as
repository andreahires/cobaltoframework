package com.cobalto.extended.magnolia.view.components
{
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.components.menu.BasicMenu;
	import com.cobalto.display.Drawer;
	import com.cobalto.text.HtmlTextBuilder;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import style.Styles;
	
	import style.Styles;
	
	/*
	   The class is useful to create a menu bar to use with Magnolia CMS
	   the class create basicMenu class to hold the buttons and associate a label to each button.
	   It is possible to setup the width of the bar, while the height is fixed.
	   The class feature two methods, one for changing it's width and one for add buttons
	 */
	
	public class MagnoliaBar extends Sprite
	{
		private var _leftMenu:BasicMenu;
		private var _rightMenu:BasicMenu;
		private var _bar:Sprite;
		private var _width:Number;
		private var _leftWidth:Number = 0;
		private var _rightWidth:Number = 0;
		
		private var _menuXML:XMLList;
		private var _rightButtons:Array;
		private var _leftButtons:Array;
		private var _leftOffset:uint = 0;
		private var _rightOffset:uint = 0;
		private var _preview:Boolean;
		
		static private var _height:Number = 20;
		static private var _offset:Number = 30;
		static private var _barColor:uint = 0x86ad42;
		static private var _overColor:uint = 0x658131;
		
		public function MagnoliaBar(width:Number,menuXML:XMLList,preview:Boolean=false)
		{
			super();
			_width = width;
			_rightMenu = new BasicMenu;
			_leftMenu = new BasicMenu;
			_menuXML = menuXML;
			_rightButtons = new Array();
			_leftButtons = new Array();
			_preview = preview;
			parseXML();
			build();
			//this.visible = false;
		}
		
		//**This function is use to create a separate XML object for each menu 
		//**once the XML have been created it call the build function.
		private function parseXML():void
		{
			//*loop through all the buttons
			for each(var button:XML in _menuXML.button)
			{
				var thisButton:Object;
				
				if(button.@align == 'R')
				{
					thisButton = {align:button.@align,link:button.@onclick,label:button.@label.toString()};
					_rightButtons.push(thisButton);
				}
				else if(button.@align == 'L')
				{
					thisButton = {align:button.@align,link:button.@onclick,label:button.@label.toString()};
					_leftButtons.push(thisButton);
				}
			}
		}
		
		//**This is the function that is used to addButtons to the menus
		// @param num: number of buttons of the menu
		public function build():void
		{
			//*build the bar
			_bar = new Sprite();
			
			if(_preview == false)
				Drawer.DrawRect(_bar,_width,_height,_barColor);
			addChild(_bar);
			
			_leftWidth = 0;
			_rightWidth = 0;
			_leftOffset = 0;
			_rightOffset = 0;
			
			//*build Left menu
			if(_leftButtons)
			{
				_leftMenu.addEventListener(BasicMenu.BUTTON_ADDED,createSkin);
				_leftMenu.addEventListener(PrimitiveButton.BUTTON_OVER,menuOver);
				_leftMenu.addEventListener(PrimitiveButton.BUTTON_OUT,menuOut);
				_leftMenu.addEventListener(PrimitiveButton.BUTTON_CLICKED,menuClicked);
				_leftMenu.build(_leftButtons.length);
				addChild(_leftMenu);
			}
			
			//*build right menu
			if(_rightButtons)
			{
				_rightMenu.addEventListener(BasicMenu.BUTTON_ADDED,createSkin);
				_rightMenu.addEventListener(PrimitiveButton.BUTTON_OVER,menuOver);
				_rightMenu.addEventListener(PrimitiveButton.BUTTON_OUT,menuOut);
				_rightMenu.addEventListener(PrimitiveButton.BUTTON_CLICKED,menuClicked);
				_rightMenu.build(_rightButtons.length);
				addChild(_rightMenu);
			}
		}
		
		//**This function the skin for the menu buttons
		private function createSkin(e:Event):void
		{
			e.stopImmediatePropagation();
			//*create label and skin Sprite
			var btSkin:Sprite = new Sprite();
			var btOver:Sprite = new Sprite();
			var txt:HtmlTextBuilder;
			
			//*Left Menu
			if(e.currentTarget == _leftMenu && _preview == false)
			{
				txt = new HtmlTextBuilder(_leftButtons[e.target.id].label.toString());
				txt.y = 1;
				txt.x = _offset * .5;
				txt.htmlFormat = Styles.DESCRIPTION_BLACK_BACKGROUND;
				txt.objectFormat = Styles.MAGNOLIABAR_TEXT_STYLE;
				txt.objectField = Styles.TEXT_ADVANCED;
				
				Drawer.DrawRect(btOver,txt.width + _offset,_height,_overColor);
				btSkin.addChild(btOver);
				btSkin.addChild(txt);
				
				//*separator 
				Drawer.DrawLine(btSkin,0,_height,txt.width + _offset,0,0xFFFFFF);
				
				e.target.x = _leftOffset;
				_leftOffset += btSkin.width;
				_leftWidth += btSkin.width;
				
				/* trace ("_leftButtons.length -1 = " + (_leftButtons.length-1));
				 trace("_leftButtons n. "+ e.target.id + " - _leftMenuWidth = " + _leftWidth + " x = "+e.target.x );   */
				
				if(e.target.id == _leftButtons.length - 1)
					organizeItems();
			}
			
			//*Right Menu
			if(e.currentTarget == _rightMenu && _preview == false)
			{
				
				txt = new HtmlTextBuilder(_rightButtons[e.target.id].label.toString());
				txt.y = 1;
				txt.x = _offset * .5
				txt.objectFormat = Styles.MAGNOLIABAR_TEXT_STYLE;
				txt.htmlFormat = Styles.DESCRIPTION_BLACK_BACKGROUND;
				txt.objectField = Styles.TEXT_ADVANCED;
				
				Drawer.DrawRect(btOver,txt.width + _offset,_height,_overColor);
				btSkin.addChild(btOver);
				btSkin.addChild(txt);
				
				//*separator 
				Drawer.DrawLine(btSkin,0,_height - 1,0,0,0xFFFFFF);
				e.target.x = _rightOffset;
				_rightOffset += btSkin.width;
				_rightWidth += btSkin.width;
				
				//trace ("_rightButtons.length -1 = " + (_rightButtons.length-1));
				//trace("_rightButtons n. "+ e.target.id + " - RightMenuWidth = " + _rightWidth + " x = "+e.target.x);   
				
				if(e.target.id == _rightButtons.length - 1)
					organizeItems();
			}
			
			if(e.currentTarget == _leftMenu && _preview == true)
			{
				txt = new HtmlTextBuilder("edit");
				txt.y = 1;
				txt.x = _offset * .5;
				txt.htmlFormat = Styles.DESCRIPTION_BLACK_BACKGROUND;
				txt.objectFormat = Styles.MAGNOLIABAR_TEXT_STYLE;
				txt.objectField = Styles.TEXT_ADVANCED;
				
				Drawer.DrawRect(btOver,txt.width + _offset,_height,_overColor);
				btSkin.addChild(btOver);
				
				var btBack:Sprite = new Sprite();
				Drawer.DrawRect(btBack,txt.width + _offset,_height,_barColor);
				btSkin.addChild(btBack);
				
				btSkin.addChild(txt);
				
				e.target.x = _leftOffset;
				_leftOffset += btSkin.width;
				_leftWidth += btSkin.width;
				
				organizeItems();
			}
			
			e.target.skin = btSkin;
			
			// hide buttonOver skin
			e.target.skin.getChildAt(0).alpha = 0;
		
			//PrimitiveButton(e.target).showHitArea(true);	
		}
		
		//**thisfunction is used to organize menu buttons
		public function organizeItems():void
		{
			//trace("organizing Magnolia Bar!!!!!!!");
			_rightMenu.x = _width - rightMenuWidth;
			//trace ("----------------> _rightMenu.x = " + _rightMenu.x );	
			//trace ("----------------> rightMenuWidth = " + rightMenuWidth);	
			//trace ("leftMenuWidth = " + leftMenuWidth);	
			//trace ("_leftMenu.x = " + _leftMenu.x );	  
		
		}
		
		//**This function will be executed when the menu is clicked
		private function menuClicked(e:Event):void
		{
			var call:String
			
			if(_leftMenu != null && e.currentTarget == _leftMenu)
			{
				call = _leftButtons[e.target.id].link;
			}
			else if(_rightMenu != null)
			{
				call = _rightButtons[e.target.id].link;
			}
			ExternalInterface.call(call);
		}
		
		//**This function is used for the roll over skin
		private function menuOver(e:Event):void
		{
			//e.target.parent.skin.getChildAt(0).alpha = 1;
		}
		
		//**This function is used for the roll out skin
		private function menuOut(e:Event):void
		{
			//e.target.parent.skin.getChildAt(0).alpha = 0;
		}
		
		//**This is the function to change the width of the bar
		public function setWidth(width:Number):void
		{
			_width = width;
			_bar.width = _width;
			
			if(_rightMenu)
				organizeItems();
		}
		
		public function get barWidth():Number
		{
			return _bar.width;
		}
		
		public function set rightMenuX(x:Number):void
		{
			_rightMenu.x = x;
		}
		
		public function get rightMenuX():Number
		{
			return _rightMenu.x = x;
		}
		
		public function get leftMenuWidth():Number
		{
			return _leftWidth;
		}
		
		public function get rightMenuWidth():Number
		{
			return _rightWidth;
		}
		
		public function set leftMenuX(x:Number):void
		{
			_leftMenu.x = x;
		}
		
		public function get leftMenuX():Number
		{
			return _leftMenu.x = x;
		}
	}
}