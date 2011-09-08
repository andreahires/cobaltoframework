package com.cobalto.utils
{
	
	public class Math3
	{
		
		// map(value, low1, high1, low2, high2);
		public static function map(v:Number,a:Number,b:Number,x:Number=0,y:Number=1):Number
		{
			return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
		}
	}
}