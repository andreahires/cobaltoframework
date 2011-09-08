package com.cobalto.components.scrollbar
{
	import com.cobalto.display.Drawer;
	import com.cobalto.utils.AssetManager;
	import com.fuoriDalCerchio.Scrollbar;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	

	
	public class SmallScroller extends Scrollbar
	{
		protected var scroller:Sprite;
		protected var msk:Shape;
		protected var dragger:MovieClip;
		protected var bg:MovieClip;
		protected var mskHeight:uint;
		protected var mskWidth:uint;
		protected var content:DisplayObject;
		private var _customScrollTrack:String;
		private var _customScrollthumb:String;
		
		public function SmallScroller(dragged:DisplayObject,maskWidth:uint=0,maskHeight:uint=0,TrackLinkageID:String=null, ThumbLinkageID:String=null)
		{
			content = dragged;
			customScrollTrack = TrackLinkageID;
			customScrollThumb = ThumbLinkageID;
			
			this.tabChildren = false;
			this.tabEnabled = false;
			mskWidth = maskWidth;
			mskHeight = maskHeight;
			
			if(mskWidth == 0 || mskHeight == 0)
			{
				mskWidth = dragged.width;
				mskHeight = dragged.height;
			}
			addChild(dragged);
			createMask();
			createScroller();
			createBackGround();
			createRuler();
			
			super(content,msk,dragger,bg,msk,false,4);
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			scroller.x = maskWidth;
		}
		
		protected function onAdded(e:Event):void
		{
			this.init(e);
		}
		
		protected function onRemoved(e:Event):void
		{
			destroy();
		}
		
		protected function createMask():void
		{
			msk = new Shape();
			Drawer.DrawRect(msk,mskWidth,mskHeight);
			addChild(msk);
		}
		
		protected function createScroller():void
		{
			scroller = new Sprite();
			addChild(scroller);
		}
		
		protected function createRuler():void
		{
			dragger = AssetManager.getItem((customScrollThumb) ? customScrollThumb : "Black_SrollDragger") as MovieClip;
			dragger.x = 1;
			scroller.addChild(dragger);
		}
		
		protected function createBackGround():void
		{
			
			bg = AssetManager.getItem((customScrollTrack) ? customScrollTrack : "Black_ScrollTrack") as MovieClip;
			bg.height = mskHeight;
			scroller.addChild(bg);
			
			if(msk.height > content.height)
			{
				bg.alpha = 0;
			}
			
		}
		
		public function destroy():void
		{
			
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP,releaseHandle);
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL,wheelHandle,true);
			}
			removeEventListener(Event.ENTER_FRAME,enterFrameHandle);
			
			scroller = null;
			msk = null;
			dragger = null;
			bg = null;
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		override public function set setUniqueName(value:String):void
		{
			scroller.name = value;
			_uniqueName = value;
		}
		
		override public function get getUniqueName():String
		{
			return _uniqueName;
		}
		public function get scrollBarInstance():SmallScroller
		{
			return this;
		}
		public  function set customScrollTrack(trackLinkageID:String):void
		{
			_customScrollTrack = trackLinkageID
		}
		
		public  function get customScrollTrack():String
		{
			return _customScrollTrack
		}
		
		
		public  function set customScrollThumb(thumbLinkageID:String):void
		{
			_customScrollthumb = thumbLinkageID
		}
		public  function get customScrollThumb():String
		{
			return _customScrollthumb;
		}
	}
}