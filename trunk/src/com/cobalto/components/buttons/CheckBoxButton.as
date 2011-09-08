

	//////////////////////////////////////////////////////////////////////
	//																	\\
	//  TOGGLE_BUTTON ~ by  Zulu*										//---------/////////
	//\\ 																\\
	//////////////////////////////////////////////////////////////////////


package com.cobalto.components.buttons
{
	import com.cobalto.components.core.IForm;
	import com.cobalto.display.Drawer;
	import com.cobalto.text.HtmlTextBuilder;
	import com.cobalto.text.TextBuilder;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	
	import style.Styles;

	public class CheckBoxButton extends ListButton
	{
		protected var currentState : int;
		protected var selectedSkin : Sprite;
		protected var deSelectedSkin : Sprite;
		protected var labelTxtBuilder : HtmlTextBuilder;
		protected var labelTxt	: String;
		protected var labelStyleObject : Object;
		protected var errorBgColor:int=0xff0000;
		protected var focusStrokeColor:int=0x000000;
		
		public function CheckBoxButton()
		{
			super(0,0,0,0);
			
			Init();
		}
		protected function Init():void
		{
			deSelectStateSkin();
			selectStateSkin();
			defineLabelStyle();
		}
		
		protected function deSelectStateSkin():void
		{
		}

		protected function selectStateSkin():void
		{
		}
		
		protected function defineLabelStyle():void
		{
			
		}
		
		override public function build():void	
		{
			var errorBg:Sprite = new Sprite();
			Drawer.DrawRect(errorBg,selectedSkin.width,selectedSkin.height,errorBgColor);
			errorBg.alpha=0;
			errorBg.name = 'errorBg';
			
			var focusStroke:Sprite = new Sprite();
			Drawer.DrawRect(focusStroke,selectedSkin.width+2,selectedSkin.height+2,focusStrokeColor,-1,-1);
			focusStroke.alpha=0;
			focusStroke.name = 'focusStroke';
			
			var widthOfLabel : int = 450;
			if(labelTxt.length<50)widthOfLabel = 0;
			labelTxtBuilder = new HtmlTextBuilder(labelTxt,widthOfLabel);
			labelTxtBuilder.objectFormat = labelStyleObject;
			
			buttonSkin = new Sprite();
			buttonSkin.addChild(focusStroke);
			buttonSkin.addChild(selectedSkin);
			buttonSkin.addChild(deSelectedSkin);
			buttonSkin.addChild(labelTxtBuilder);
			buttonSkin.addChild(errorBg);
			skin = buttonSkin;
			//showHitArea(true);
			positionLabels();
		}
		
		protected function positionLabels():void
		{
			labelTxtBuilder. x = 20;
		}	
		
		public function setState(value:int):void
		{
			currentState = value;
			
			switch(currentState)
			{
				case 1:
				selectState();
				break;			
				
				default :
				deSelectState();
				break;
			}
		}
		
		private function deSelectState():void
		{
			deSelectStateHandler();
		}
		
		private function selectState():void
		{
			selectStateHandler();
		}

		protected function deSelectStateHandler():void
		{
			selectedSkin.alpha = 0;
			deSelectedSkin.alpha = 1; 
		}
		
		protected function selectStateHandler():void
		{
			selectedSkin.alpha = 1;
			deSelectedSkin.alpha = 0;
		}
			
		public function getCurrentState():int
		{
			return currentState;	
		}
		
		public function getSkin():Sprite
		{
			return buttonSkin;
		}
		
		override public function setLabel(value:String):void
		{
			labelTxt = 	value;
		}

		override protected function onFocusInHandler(focusEvent:FocusEvent):void{onSetFocusInSkinHandler(focusEvent.target as ToggleButton)};
		override protected function onFocusOutHandler(focusEvent:FocusEvent):void{onSetFocusOutSkinHandler(focusEvent.target as ToggleButton)};
		
		override public function onSetFocusInSkinHandler(target:ListButton):void{};
		override public function onSetFocusOutSkinHandler(target:ListButton):void{};
	}
}