package com.cobalto.components.tooltip
{
	import com.cobalto.display.Drawer;
	import com.cobalto.text.TextBuilder;
	
	import flash.display.Sprite;
	
	import style.Styles;
	
	public class ToolTip extends Sprite
	{
		private var _shape:Sprite;
		private var _txt:TextBuilder;
		private var _str:String;
		
		public function ToolTip(str:String)
		{
			_shape = new Sprite();
			_str = str;
			build();			
		}
		
		private function build():void
		{
			
			_txt = new TextBuilder(_str);
			_txt.objectFormat=Styles.FAGO_11_YELLOW;
			
			Drawer.DrawRoundRect(_shape,_txt.textWidth+10,_txt.textHeight,0x761242,5,5)
			addChild(_shape);
			_shape.filters=[Styles.TITLE_SHADOW];
			
			addChild(_txt);
			
			_txt.y=(_txt.textHeight*.5)-_txt.textHeight*.5;
			_txt.x=4;
		}
	}
}