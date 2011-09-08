package com.cobalto.extended.magnolia.view.components
{
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.utils.AssetManager;
	import com.cobalto.display.Drawer;
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	/** MagnoliaButton By: Federico Weber
	 *
	 * The purpose of this calss is to add a button to edit the section elements
	 * of the pages using magnolia CMS
	 *
	 * */
	
	public class MagnoliaButton extends Sprite
	{
		
		private var _btn:PrimitiveButton;
		private var _link:String;
		private var _label:MovieClip;
		
		public function MagnoliaButton(link:String)
		{
			super();
			_link = link;
			_label = AssetManager.getItem("PencilIcon");
			build();
			//this.visible = false;
		}
		
		private function build():void
		{
			var skin:Sprite = new Sprite();
			Drawer.DrawRect(skin,_label.width,_label.height,0x86ad42);
			skin.addChild(_label);
			
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