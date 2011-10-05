package com.cobalto.components
{
	import com.cobalto.api.IInterfaceComponent;
	import com.cobalto.utils.MemoryUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public class InterfaceComponent extends Sprite implements IInterfaceComponent
	{
		
		private var listenerCollection:Dictionary;
		
		
		public function InterfaceComponent()
		{
			super();
			listenerCollection = new Dictionary(false);
		}
		
		public function build(params:Object = null):void
		{
			
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			listenerCollection[listener] = type;
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
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

		public function destroy():void
		{

			var value:String;
			for (var key:* in listenerCollection) 
			{
				value = listenerCollection[key];
				removeEventListener(value,key);
				delete listenerCollection[key];
			}
			
			listenerCollection = null;
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