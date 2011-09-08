package com.cobalto.api
{
	import com.cobalto.components.buttons.PrimitiveButton;
	
	import flash.display.DisplayObject;
	
	public interface IMenu extends IList
	{
		
		function addItem(item:PrimitiveButton = null):void
		
		function update(id:uint):void;
		
		function enableMenu():void
		
		function disableMenu():void
		
		function get activeId():uint
		
		function get displayObject():DisplayObject
		
		
	}
}