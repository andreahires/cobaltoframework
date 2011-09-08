

	//////////////////////////////////////////////////////////////////////
	//																	\\
	//  ILISTBOX ~ by  Zulu*											//---------/////////
	//\\ 																\\
	//////////////////////////////////////////////////////////////////////


package com.cobalto.components.core
{
	import com.cobalto.api.IMenu;

	public interface IListBox extends IMenu, IForm
	{
		function set label(value:String):void
		function get label():String;
		
		function set selectedIndex(value:int):void
		function get selectedIndex():int;
		
		function set dataProvider(value:Array):void;
		
		function addItemAt(value:String,index:int):void
		function removeItemAt(index:int):void;
	}
}