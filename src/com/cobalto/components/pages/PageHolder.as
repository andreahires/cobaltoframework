package com.cobalto.components.pages
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class PageHolder extends Sprite
	{
		protected var pageArray:Array = new Array();
		
		public function PageHolder()
		{
			super();
		}
		
		public function addNewPage(newPageInstance:DisplayObjectContainer,depth:uint):void
		{
			
			if(depth > 1)
			{
				var parentPage:Page = pageArray[depth - 2][pageArray[depth - 2].length - 1];
				newPageInstance.x = 300;
				parentPage.addChild(newPageInstance);
			}
			else
			{
				addChildAt(newPageInstance,0);
				
			}
			
			if(!pageArray[depth - 1])
				pageArray[depth - 1] = new Array();
			pageArray[depth - 1].push(newPageInstance);
		
			//trace("addNewPage: "+newPageInstance+" - at depth: "+depth);
		
		}
		
		public function removePage(depth:int,pageInstance:Page):void
		{
			
			//trace("removePage: "+pageInstance+" - at depth: "+depth);
			if(depth > 1)
			{
				var parent:Page = pageInstance.parent as Page;
				
				if(parent)
				{
					parent.removeChild(pageInstance);
				}
				
			}
			else
			{
				pageInstance.destroy();
				//removeChild(pageInstance);
			}
			
			pageInstance = null;
			pageArray[depth - 1].shift();
		
		}
	
	}
}