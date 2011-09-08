package com.cobalto.api
{
	public interface IViewComponent
	{
		function organizeItems():void
		//function build(pageData:Object = null):void
		function transitionIn():void
		function transitionOut():void 
		function set id(pageId:int):void
		function get id():int
		
	}
}