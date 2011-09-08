
//////////////////////////////////////////////////////////////////////
//																	\\
//  LIST_BOX_BUTTON ~ by Zulu*										//---------/////////
//\\ 																\\
//////////////////////////////////////////////////////////////////////

package com.cobalto.components.buttons
{
	import com.cobalto.display.Drawer;
	import com.cobalto.text.HtmlTextBuilder;
	import com.cobalto.text.TextBuilder;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	
	import style.Styles;
	
	public class ListButton extends PrimitiveButton
	{
		public var buttonSkin:Sprite;
		protected var buttonLabel:HtmlTextBuilder;
		protected var buttonText:String;
		protected var labelBg:Sprite;
		protected var rR1:int;
		protected var rR2:int;
		protected var buttonHeight:int;
		protected var buttonWidth:int;
		protected var _uniqueName:String;
		protected var maskee:Sprite;
		
		public function ListButton(w:int=0,h:int=0,rc1:int=0,rc2:int=0)
		{
			//this.name = 'ListButton';
			super(w,h);
			rR1 = rc1;
			rR2 = rc2;
			ConfigureHandlers();
			this.focusRect = false;
		}
		
		protected function ConfigureHandlers():void
		{
			addEventListener(FocusEvent.FOCUS_IN,onFocusInHandler);
			addEventListener(FocusEvent.FOCUS_OUT,onFocusOutHandler);
		}
		
		public function build():void
		{
			
			buttonSkin = new Sprite();
			buttonLabel = new HtmlTextBuilder(label);
			labelBg = new Sprite();
			
			Drawer.DrawRoundRect(labelBg,super.width,super.height,0xffffff,rR1,rR2,0,0);
			buttonSkin.addChild(labelBg);
			
			buttonLabel.objectFormat = Styles.FAGO_11_GREY;
			buttonSkin.addChild(buttonLabel);
			
			maskee = new Sprite(), Drawer.DrawRoundRect(maskee,(super.width),super.height,0xffffff,rR1,rR2,0,0);
			buttonSkin.addChild(maskee);
			buttonLabel.mask=maskee;
			
			skin = buttonSkin;
			
			buttonLabel.x = Math.round(width * .5 - buttonLabel.width * .5);
			buttonLabel.y = Math.round(height * .5 - buttonLabel.height * .5);
		}
		
		public function set label(value:String):void
		{
			buttonText = value;
		}
		
		public function get label():String
		{
			return buttonText;
		}
		
		public function setLabel(value:String):void
		{
			label = value;
			buttonLabel.setText(trimString(label));
			buttonLabel.objectFormat = Styles.FAGO_11_GREY;
			buttonLabel.x = Math.round(width * .5 - buttonLabel.textWidth * .5);
			buttonLabel.y = Math.round(height * .5 - buttonLabel.textHeight * .5);
		}
		
		protected function trimString(stringValue:String):String
		{
			return stringValue;
		}
		protected function onFocusInHandler(focusEvent:FocusEvent):void
		{
			onSetFocusInSkinHandler(focusEvent.target as ListButton)
		};
		
		protected function onFocusOutHandler(focusEvent:FocusEvent):void
		{
			onSetFocusOutSkinHandler(focusEvent.target as ListButton)
		};
		
		public function onSetFocusInSkinHandler(target:ListButton):void
		{
		};
		
		public function onSetFocusOutSkinHandler(target:ListButton):void
		{
			
		};
		
		public function set setUniqueName(value:String):void
		{
			this.name = value;
			_uniqueName = value;
		}
		
		public function get getUniqueName():String
		{
			return _uniqueName;
		}
	}
}