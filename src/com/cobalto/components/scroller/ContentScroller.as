

	//////////////////////////////////////////////////////////////////////
	//																	\\
	//  CONTENT_SCROLLER ~ by  Zulu*									//---------/////////
	//\\ 																\\
	//////////////////////////////////////////////////////////////////////


package com.cobalto.components.scroller
{
	import com.cobalto.api.IViewComponent;
	import com.cobalto.display.Drawer;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class ContentScroller extends Sprite implements IViewComponent
	{
		public static const CONTENT_ADDED : String = 'ContentAdded';
		
		protected var maskee:Sprite;
		
		protected var areaWidth:int;
		protected var areaHeight:int;
		
		protected var cornerRadius1:int;
		protected var cornerRadius2:int;
		
		protected var contentHolder:Sprite;
			 
		public function ContentScroller()
		{
			super();
			contentHolder = new Sprite();
			addChild(contentHolder);
		}
		
		public function addItem(content:InteractiveObject):void
		{
			content.addEventListener(Event.ADDED_TO_STAGE,contentAdded);
			contentHolder.addChild(content);
		}
		
		protected function contentAdded(event:Event):void
		{
			dispatchEvent(new Event(CONTENT_ADDED,true));
		}	
		
		protected function setup():void{}; 
		protected function update():void{};
		public function organizeItems():void{};
		public function transitionIn():void{};
		public function transitionOut():void{};		
		public function set id(pageId:int):void{};
		
		public function get id():int
		{
			return 0;
		}
		public function set contentAreaWidth(value:int):void
		{
			areaWidth = value;
		}
		public function get contentAreaWidth():int
		{
			return areaWidth;
		}

		public function set contentAreaHeight(value:int):void
		{
			areaHeight = value;
		}
		public function get contentAreaHeight():int
		{
			return areaHeight;
		}
		
		public function set maskeeCornerRadius(value:int):void
		{
			cornerRadius1 = value;
		}
		public function get maskeeCornerRadius():int
		{
			return cornerRadius1;
		}
		
	}
}