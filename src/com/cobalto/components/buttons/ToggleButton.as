
//////////////////////////////////////////////////////////////////////
//																	\\
//  TOGGLE_BUTTON ~ by  Zulu*										//---------/////////
//\\ 																\\
//////////////////////////////////////////////////////////////////////

package com.cobalto.components.buttons
{
	import com.cobalto.display.Drawer;
	import com.cobalto.text.HtmlTextBuilder;
	import com.cobalto.text.TextBuilder;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import style.Styles;
	
	public class ToggleButton extends ListButton
	{
		protected var currentState:uint = 0;
		protected var lblArray:Array;
		public static const CHANGED:String = 'Changed';
		
		public function ToggleButton(labelArray:Array,w:int=0,h:int=0,rc1:int=0,rc2:int=0)
		{
			lblArray = labelArray;
			super(w,h,rc1,rc2);
		}
		
		override public function build():void
		{
			buttonSkin = new Sprite();
			labelBg = new Sprite();
			Drawer.DrawRoundRect(labelBg,super.width,super.height,uint('0x' + Styles.COLOR_BLACK),rR1,rR2,0,0);
			buttonSkin.addChild(labelBg);
			buttonLabel = new HtmlTextBuilder(lblArray[currentState]);
			buttonLabel.objectFormat = Styles.FAGO_11_WHITE;
			buttonLabel.htmlFormat = Styles.DESCRIPTION_BLACK_BACKGROUND;
			buttonLabel.objectField = Styles.TEXT_ADVANCED;
			buttonSkin.addChild(buttonLabel);
			skin = buttonSkin;
			
			buttonLabel.x = Math.round(width * .5 - buttonLabel.textWidth * .5);
			buttonLabel.y = Math.round(height * .5 - buttonLabel.textHeight * .5);
			
			this.addEventListener(PrimitiveButton.BUTTON_CLICKED,onClickHandler);
			this.addEventListener(PrimitiveButton.BUTTON_OUT,onOutHandler);
			this.addEventListener(PrimitiveButton.BUTTON_OVER,onOverHandler);
		
		}
		
		protected function onClickHandler(event:Event):void
		{
			dispatchEvent(new Event(CHANGED,true));
		}
		
		protected function onOutHandler(event:Event):void
		{
		
		}
		
		protected function onOverHandler(event:Event):void
		{
		
		}
		
		public function toogleState():void
		{
			switch(currentState)
			{
				case 0:
					toogleState0(currentState,lblArray[currentState]);
					break;
				
				case 1:
					toogleState1(currentState,lblArray[currentState]);
					break;
			}
		}
		
		public function manageState():void
		{
			if(currentState === 0)
			{
				currentState = 1;
			}
			else if(currentState === 1)
			{
				currentState = 0;
			}
		}
		
		protected function toogleState0(value:uint,label:String):void
		{
			setLabel(label);
			toogleState0Skin();
		}
		
		protected function toogleState1(value:uint,label:String):void
		{
			setLabel(label);
			toogleState1Skin();
		}
		
		public function toogleState0Skin():void
		{
		
		}
		
		public function toogleState1Skin():void
		{
		
		}
		
		public function getCurrentState():uint
		{
			return currentState;
		}
		
		public function setCurrentState(value:uint):void
		{
			currentState = value;
		}
		
		public function enableToggle():void
		{
			this.mouseEnabled = false;
			this.buttonMode = false;
		}
		
		public function disableToggle():void
		{
			this.mouseEnabled = true;
			this.buttonMode = true;
		}
		
		public function getSkin():Sprite
		{
			return buttonSkin;
		}
		
		public function getBg():Sprite
		{
			return labelBg;
		}
		
		override public function setLabel(value:String):void
		{
			label = value;
			buttonLabel.setText(label);
			buttonLabel.objectFormat = Styles.FAGO_11_WHITE;
			
			buttonLabel.x = Math.round(width * .5 - buttonLabel.textWidth * .5);
			buttonLabel.y = Math.round(height * .5 - buttonLabel.textHeight * .5);
		}
		
		override protected function onFocusInHandler(focusEvent:FocusEvent):void
		{
			onSetFocusInSkinHandler(focusEvent.target as ToggleButton)
		};
		
		override protected function onFocusOutHandler(focusEvent:FocusEvent):void
		{
			onSetFocusOutSkinHandler(focusEvent.target as ToggleButton)
		};
		
		override public function onSetFocusInSkinHandler(target:ListButton):void
		{
		};
		
		override public function onSetFocusOutSkinHandler(target:ListButton):void
		{
		};
		
		public function get labelWidth():Number
		{
			return buttonLabel.textWidth;
		}
	}
}