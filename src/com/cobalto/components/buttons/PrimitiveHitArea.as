package com.cobalto.components.buttons
{
	import flash.display.Sprite;
	
	import org.casalib.display.CasaSprite;
	
	public class PrimitiveHitArea extends CasaSprite
	{
		
		private var _id:uint = 0;
		
		public function PrimitiveHitArea()
		{
			super();
			this.cacheAsBitmap = true;
		}
		
		public function get id():uint
		{
			return _id;
		}
		
		public function set id(refId:uint):void
		{
			_id = refId;
		}
	}
}