package com.cobalto.display
{
	import site.components.shapes.DashedRectangle;
	
	public class Stroke extends DashedRectangle
	{
		public function Stroke(width:uint, height:uint, color:Number=0xd1cdcc, top:Boolean=true, bottom:Boolean=true, left:Boolean=true, right:Boolean=true)
		{
			super(width, height, color, top, bottom, left, right);
		}
		
		override protected function build():void
		{
			if (top)
			{
				var topLine:DashedLine = new DashedLine(rectWidth,1,0,false,color);
				addChild(topLine);
			}
			
			if (bottom)
			{
				var bottomLine:DashedLine = new DashedLine(rectWidth,1,0,false,color);
				addChild(bottomLine);
				bottomLine.y = rectHeight;
			}
			
			if (left)
			{
				var leftLine:DashedLine = new DashedLine(rectHeight,1,0,true,color);
				addChild(leftLine);
			}
			
			if (right)
			{
				var rightLine:DashedLine = new DashedLine(rectHeight,1,0,true,color);
				addChild(rightLine)
				rightLine.x = rectWidth;
			}
			
		}
	}
}