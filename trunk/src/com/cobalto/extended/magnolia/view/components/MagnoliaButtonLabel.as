package com.cobalto.extended.magnolia.view.components
{
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.display.Drawer;
	import com.cobalto.text.TextBuilder;
	import com.cobalto.utils.AssetManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import style.Styles;
	
	import style.Styles;
	
	/** MagnoliaButton By: Federico Weber
	 *
	 * The purpose of this calss is to add a button to edit the section elements
	 * of the pages using magnolia CMS
	 *
	 * */
	
	public class MagnoliaButtonLabel extends Sprite
	{
		
		private var _btn:PrimitiveButton;
		private var _link:String;
		private var _label:TextBuilder;
		private var _labelTxt:String;
		
		public function MagnoliaButtonLabel(link:String,label:String)
		{
			super();
			_link = link;
			_labelTxt = label
			build();
			//this.visible = false;
		}
		
		private function build():void
		{
			var skin:Sprite = new Sprite();
			
			_label = new TextBuilder(_labelTxt);
			_label.objectFormat = Styles.MAGNOLIABAR_TEXT_STYLE;
			_label.objectField = Styles.TEXT_ADVANCED;
			skin.addChild(_label);
			
			Drawer.DrawRect(skin,_label.width + 20,_label.height,0x86ad42);
			_label.x = 10;
			_label.y = -1;
			_btn = new PrimitiveButton();
			_btn.skin = skin;
			_btn.addEventListener(PrimitiveButton.BUTTON_CLICKED,onClick);
			addChild(_btn);
		}
		
		private function onClick(e:Event):void
		{
			e.stopImmediatePropagation();		
			var call:String
			call = _link;
			ExternalInterface.call(call);
		}
	
	}
}