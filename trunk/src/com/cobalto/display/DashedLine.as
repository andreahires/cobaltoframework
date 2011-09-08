package com.cobalto.display
{
	
	import flash.display.Sprite;
	
	import com.greensock.TweenLite;

	public class DashedLine extends Sprite
	{
		protected var lineLenght:uint;
		protected var dashSize:uint;
		protected var gapSize:uint;
		protected var color:Number;
		protected var vertical:Boolean;
		
		protected var dashedLine:Sprite;
		
		public function DashedLine(lineLenght:uint, dashSize:uint, gapSize:uint, vertical:Boolean=false, color:Number = 0x000000)
		{
			this.lineLenght = lineLenght;
			this.dashSize = dashSize;
			this.gapSize = gapSize;
			this.color = color;
			this.vertical = vertical;
			build();
		}
		
		protected function build():void
		{
			dashedLine = new Sprite();
			
			
			for (var currentLenght:uint = 0; currentLenght<= lineLenght - dashSize; currentLenght+= dashSize + gapSize)
			{
				Drawer.DrawLine(dashedLine,dashSize,0,currentLenght,0,color);
			}
			
			if ( currentLenght < lineLenght)
			{
				Drawer.DrawLine(dashedLine,lineLenght - currentLenght,0,currentLenght,0,color);
			}
			
			addChild(dashedLine);
			if (vertical)
				dashedLine.rotation = 90;
			
		}
		
		// set color of the grid
		public function setColor(c:Number):void
		{
			TweenLite.to(this,0,{tint:c});
		}
		
	}
}