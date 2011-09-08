package com.cobalto.events
{
	import flash.events.Event;

	public class MenuEvent extends Event
	{
		public static const FIRE:String="fire";
		public var  index:int;
		
		
		public function MenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,index:int=0)
		{
			super(type, bubbles, cancelable);
			this.index=index;
		}
		
		public override function clone():Event{
		    
		    return new MenuEvent(type, bubbles, cancelable,index);
		
		}
		public override function toString():String{
		
		 return formatToString("MenuEvent","type","bubbles","cancelable","index");
		  
		}
		
	}
}