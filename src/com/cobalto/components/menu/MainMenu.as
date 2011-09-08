package com.cobalto.components.menu
{
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.text.TextBuilder;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	
	import style.Styles;
	
	public class MainMenu extends MainMenuBase
	{
		public function MainMenu()
		{
			super();
		}
		
		override protected function addedHandler(e:Event):void
		{
			var bt:PrimitiveButton = e.target as PrimitiveButton;
			//bt.showHitArea(true);
			
			var skin:Sprite = new Sprite();
			var lb:TextBuilder = new TextBuilder(menuDataArray[bt.id].toUpperCase());
			lb.objectFormat = Styles.COPY_WHITE;
			//lb.objectField = {antiAliasType:AntiAliasType.ADVANCED};
			skin.addChild(lb);
			
			bt.skin = skin;
			bt.x = bt.id * 150;
		}
		
		override public function organizeItems():void
		{
			super.organizeItems();
		}
	
	}

}