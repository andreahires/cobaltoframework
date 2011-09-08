

	//////////////////////////////////////////////////////////////////////
	//																	\\
	//  MENU_LIST	 ~ by Zulu*											//---------/////////
	//\\ 																\\
	//////////////////////////////////////////////////////////////////////


package com.cobalto.components.ListBox
{
	import com.cobalto.api.IMainMenu;
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.components.menu.AbstractMainMenu;
	import com.cobalto.components.menu.BasicMenu;
	import com.cobalto.display.Drawer;
	import com.cobalto.text.TextBuilder;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import style.Styles;
	
	public class MenuList extends AbstractMainMenu implements IMainMenu
	{
		protected var _width:int=100;
		protected var _height:int=20;
		protected var _willScroll:Boolean;
		protected var _uniqueName:String;
		protected var _scollUniqueName:String='notyetset';
		
		public static const BUTTON_ADD:String = 'ButtonAdd';
		public static const COLLAPSE_LIST:String = 'CollapseListFromMenuList';
		
		public function MenuList(Name:String,autoSelection:Boolean,willScroll:Boolean)
		{
			_willScroll = willScroll;
			super(Name,autoSelection);
			addEventListener(BasicMenu.BUTTON_ADDED, onButtonAdd);
			addEventListener(Event.ADDED_TO_STAGE,ConfigureListeners);
		}
		protected function ConfigureListeners(event:Event):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageClick);		
		}
		
		protected function onStageClick(event:Event):void
		{
			try
			{
				var target:String=(event.target.parent.name.toString())
				if(target!=='ListButton' && target!=='Scroller')
				{
					dispatchEvent(new Event(COLLAPSE_LIST,true));
				}
			}catch(error:Error){};
			
		}
			
		private function onButtonAdd(event:Event):void
		{
			onAddedHandler(event);
			dispatchEventOnAdded();
		}
		private function dispatchEventOnAdded():void
		{
			dispatchEvent(new Event(BUTTON_ADD,false));
		}
		
		override public function build():void
		{
			super.build();
		}
		
		public function onAddedHandler(e:Event):void
		{
			var skin:Sprite = new Sprite();
			var btn:PrimitiveButton = e.target as PrimitiveButton;
			var labelBg:Sprite = new Sprite();
			Drawer.DrawRoundRect(labelBg,getWidth, getHeight, 0xffffff,5,5,0,0);
			var label:TextBuilder = new TextBuilder(_arrayData[btn.id].toString().toUpperCase());
			label.objectFormat=Styles.FAGO_11_GREY;
			skin.addChild(labelBg)
			skin.addChild(label);
			btn.mouseChildren=false;
			btn.mouseEnabled=false;
			btn.skin = skin;
			btn.y=btn.height*btn.id;
			
			label.x= Math.round(getWidth*.5 - label.textWidth*.5);
			label.y= Math.round(getHeight*.5 - label.textHeight*.5);
			btn.visible=false;
		}
		override protected function overHandler(e:Event=null):void{

			super.overHandler(e);
			TweenLite.to(e.target.parent.skin, 0.5,{delay:0,ease:Expo.easeOut, alpha:0.4});
		}
		override protected function outHandler(e:Event=null):void{
			super.outHandler(e);
		   TweenLite.to(e.target.parent.skin, 0.5,{delay:0,ease:Expo.easeOut, alpha:1});
		}
		
		override protected function disabledHandler(e:Event):void{
		  // to do something	
		}
		override public function enableAt(k:uint):void
		{
			
		}
		override protected function enabledHandler(e:Event):void{
		  // to do something
		}
		override public function transitionIn():void
		{
			for(var i:uint=0; i<itemArray.length;i++){
		    var primitiveRootButton:PrimitiveButton=itemArray[i].pb;
			itemArray[i].btn.mouseEnabled=true;
		    if(i==itemArray.length-1){
		    	TweenLite.to(itemArray[i].btn, 0.5,{alpha:1,delay:.01*i,visible:true,scaleY:1,ease:Expo.easeOut});
		     }else{
		       TweenLite.to(itemArray[i].btn, 0.5,{alpha:1,delay:0,delay:.01*i,visible:true,scaleY:1,ease:Expo.easeOut});
		    }
		  }
		}
	 	override public function transitionOut():void{

			for(var i:uint=0; i<itemArray.length;i++)
			{
		       var primitiveRootButton:PrimitiveButton=itemArray[i].pb;
		       itemArray[i].btn.mouseEnabled=true;
		       if(i==itemArray.length-1)
		       {
		       	 TweenLite.to(itemArray[i].btn, 0.5,{delay:.01*i,visible:true,scaleY:0,ease:Expo.easeOut});
		       }
		       else
		       {
		         TweenLite.to(itemArray[i].btn, 0.5,{delay:.01*i,visible:true,scaleY:0,ease:Expo.easeOut});
		       }
	  		}
		}
		public function set setWidth(value:int):void
		{
			_width = value;
		}
		public function get getWidth():int
		{
			return _width;
		}
		public function set setHeight(value:int):void
		{
			_height = value;
		}
		public function get getHeight():int
		{
			return _height;
		}
		public function set setUniqueName(value:String):void
		{
			this.name = value;
			_uniqueName = value;
		}
		
		public function get getUniqueName():String
		{
			return _uniqueName;
		}
		
		public function set setScrollUnique(str:String):void
		{
			_scollUniqueName = str;
		}
		
		
	}
}