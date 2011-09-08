package com.cobalto.components.core
{
	import com.cobalto.api.IViewComponent;
	
	import flash.display.InteractiveObject;
	
	public interface IWindow extends IViewComponent
	{
		function build():void;
		function set AutoClose(Value:Boolean):void;
		function set AutoScroll(Value:Boolean):void;
		function set Data(Value:XMLList):void;
		function set Maskee(Value:InteractiveObject):void;
		function set Bg(Value:InteractiveObject):void;
		function set Width(Value:int):void;
		function set Height(Value:int):void;
	}
}