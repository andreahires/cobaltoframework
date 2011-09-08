package com.cobalto.api
{
	import com.cobalto.components.menu.AbstractMainMultiLevel;
	
	
	public interface IApplicationMenu
	{
		function addSubMenu(subMenu:AbstractMainMultiLevel,indexes:Array):void;
		function disable(k:IMainMenu):void;
		function activate(indexArray:Array):void
	}
}