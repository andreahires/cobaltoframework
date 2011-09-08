package com.cobalto.components.menu
{
	import flash.events.Event;
	
	public class AbstractMainMultiLevel extends AbstractMainMenu
	{
		
		//** the depth of menu (this could be a subMenu)
		protected var _depth:uint = 0;
		
		//** it store the array of the indeces, useful to manage the history and retrieve the nested clicked buttons
		protected var indexArray:Array;
		
		//** the array of the subMenus
		protected var arrayChilds:Array = [];
		
		public function AbstractMainMultiLevel(nome:String,autoSelex:Boolean=false)
		{
			super(nome,autoSelex);
		}
		
		public function transitionInFirstAt(k:uint):void
		{
			// *** if the autoselex is true, it start the transition in of the parameter k
			//if(disableFirst == true) transitionInSubAt(k);
		}
		
		//*** transition in the subMenu at the index
		public function transitionInSubAt(k:uint):void
		{
			if(arrayChilds[k] != null)
				arrayChilds[k].transitionIn();
		}
		
		public function transitionOutAllSub():void
		{
			for(var i:uint = 0;i < arrayFigli.length;i++)
			{
				transitionOutSubAt(i);
			}
		}
		
		//** disable the internal basicMenu
		override public function disableMenu():void
		{
			super.disableMenu();
			
			for(var i:uint = 0;i < arrayChilds.length;i++)
			{
				if(arrayChilds[i])
					arrayChilds[i].disableMenu();
			}
		
		}
		
		//*** transition out the subMenu at the index
		public function transitionOutSubAt(k:uint):void
		{
			if(arrayChilds[k])
				arrayChilds[k].transitionOut();
		}
		
		protected function transitionInEnd():void
		{
			//** activate the first item
			// ** TODO - test the disablefirst functionality
			//enableMenu();
			
			//trace("menu lenght at transition in "+_arrayData.length);
			
			dispatchEvent(new Event(AbstractMainMenu.TRANSITION_IN_COMPLETE));
		
		}
		
		protected function transitionOutEnd():void
		{
			dispatchEvent(new Event(AbstractMainMenu.TRANSITION_OUT,true));
		}
		
		public function get arrayFigli():Array
		{
			return arrayChilds;
		}
		
		public function set depth(k:uint):void
		{
			_depth = k;
		}
		
		public function get depth():uint
		{
			return _depth;
		}
		
		public function set indexes(menuIndexArray:Array):void
		{
			indexArray = menuIndexArray;
		}
		
		public function get indexes():Array
		{
			return indexArray;
		}
	
	}
}