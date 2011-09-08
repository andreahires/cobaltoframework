package com.cobalto.api
{
	public interface IList extends IViewComponent
	{
		//function build(itemTotal:uint):void;
		
		function get itemArray():Array
		function set itemArray(array:Array):void
		
		function get numItems():uint;
		
	}
}