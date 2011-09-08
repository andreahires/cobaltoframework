

	//////////////////////////////////////////////////////////////////////
	//																	\\
	//  IFORM ~ by  Zulu*												//---------/////////
	//\\ 																\\
	//////////////////////////////////////////////////////////////////////


package com.cobalto.components.core
{
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	
	public interface IForm extends IEventDispatcher
	{
		function set id(index:int):void;
		function get id():int;
		
		function set mandatory (value:Boolean):void;
		function get mandatory():Boolean;
		
		function set fieldName (value:String):void;
		function get fieldName():String;
		
		function set fieldValue (value:String):void;
		function get fieldValue ():String;
		
		function onSetFocusInSkinHandler(target:InteractiveObject):void;
		function onSetFocusOutSkinHandler(target:InteractiveObject):void;
		
		function onDisableSkinHandler(target:InteractiveObject):void;
		function onEnableSkinHandler(target:InteractiveObject):void;
		function onErrorSkinHandler(target:InteractiveObject):void;
				
		function reset():void;
		function getData():Object;
	}
}