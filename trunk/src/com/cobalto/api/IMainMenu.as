package com.cobalto.api
{
	import com.cobalto.text.TextBuilder;
	
	
	public interface IMainMenu extends IViewComponent, IMenu
	{
		 function set menuData(array:Array):void;
		 function build():void;
		 function enableAt(k:uint):void;
		 function disableAt(k:uint):void;
		 function addSubMenu(imenu:IMainMenu, nome:String, id:uint):void;
		
	}
}