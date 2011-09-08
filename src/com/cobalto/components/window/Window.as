package com.cobalto.components.window
{
	import com.cobalto.components.core.IForm;
	import com.cobalto.components.core.IWindow;
	import com.cobalto.display.Drawer;
	import com.cobalto.text.HtmlTextBuilder;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	public class Window extends Sprite implements IWindow
	{
		protected var _autoClose : Boolean = true;
		protected var _autoScroll : Boolean = true;
		protected var _data : XMLList;
		protected var _width : int;
		protected var _height : int;
		protected var _maskee : InteractiveObject;
		protected var _bg : InteractiveObject;
		protected var _windowStatus : String;
		protected var _isWindowClicked :Boolean;
		
		public static const WINDOW_OPENED : String = 'WindowOpened';
		public static const WINDOW_CLOSED : String = 'WindowClosed';
		
		public function Window(data:XMLList,autoclose:Boolean=true,autoscroll:Boolean=false,width:int=400,height:int=400)
		{
			super();
			
			Data = data;
			AutoClose = autoclose;
			AutoScroll =autoscroll;
			Width = width;
			Height = height;
			
			configListeners();
			
		}
		protected function configListeners():void
		{
			addEventListener(Event.ADDED_TO_STAGE,onAddedtoStageHandler);
			addEventListener(FocusEvent.FOCUS_IN,onFocusIHandler);
			addEventListener(FocusEvent.FOCUS_OUT,onFocusOutHandler);
			addEventListener(MouseEvent.CLICK,onClickHandler);
		}
		protected function onAddedtoStageHandler(event:Event):void
		{
		
		}
		protected function onFocusIHandler(focusEvent:FocusEvent):void
		{
			if(_isWindowClicked) transitionOut();
		}
		
		protected function onFocusOutHandler(focusEvent:FocusEvent):void
		{
			if(AutoClose)
			{
				trace('Focus Out')
				_isWindowClicked=false;
				transitionOut();
			}
		}
		
		protected function onClickHandler(event:MouseEvent):void
		{
			trace('clicked')
			if(AutoClose)
			{
				_isWindowClicked=true;
				transitionOut();
			}
		}
		public function build():void
		{
			
		}
		
		public function set Maskee(Value:InteractiveObject):void
		{
			_maskee = Value;
		}
		
		public function get Maskee():InteractiveObject
		{
			return _maskee;
		}
		
		public function set Bg(Value:InteractiveObject):void
		{
			_bg = Value;
		}
		public function get Bg():InteractiveObject
		{
			return _bg;
		}
		public function set AutoClose(Value:Boolean):void
		{
			_autoClose = Value;
		}
		
		public function get AutoClose():Boolean
		{
			return _autoClose;
		}
		
		public function set AutoScroll(Value:Boolean):void
		{
			_autoScroll = Value;
		}
		
		public function set Data(Value:XMLList):void
		{
			_data = Value;
		}
		
		public function get Data():XMLList
		{
			return _data;
		}
		
		public function set Width(Value:int):void
		{
			_width = Value;
		}
		public function get Width():int
		{
			return _width;
		}
		public function set Height(Value:int):void
		{
			_height = Value;
		}
		public function get Height():int
		{
			return _height;
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
		
		public function transitionInEnd():void
		{
		}
		
		public function transitionOutEnd():void
		{
		}
		
		public function set id(pageId:int):void
		{
		}
		
		public function get id():int
		{
			return 0;
		}
	}
}