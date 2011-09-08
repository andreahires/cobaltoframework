package com.cobalto.utils
{
	import flash.display.DisplayObjectContainer;
	
	public class Utils3D
	{
		
		public static function make2D(clip:DisplayObjectContainer):void
		{
			var storeX:Number = clip.x;
			var storeY:Number = clip.y;
			var storeRot:Number = clip.rotation;
			
			clip.transform.matrix3D = null;
			
			var ovalXFactor:Number = clip.width / (clip.width + 1);
			var ovalYFactor:Number = clip.height / (clip.height + 1);
			clip.scaleX = ovalXFactor;
			clip.scaleY = ovalYFactor;
			
			clip.rotation = storeRot;
			clip.x = storeX;
			clip.y = storeY;
		
		}
	
	}
}