package com.cobalto.api
{
	public interface IIterator
	{
		
		function reset():void;
        function next():Object;
        function hasNext():Boolean;
	
	}
}