package com.cobalto.api
{
	public interface IInterfaceComponent extends IViewComponent
	{
		function build(params:Object = null):void
		function destroy():void
	}
	
	
}