package com.cobalto.components.gallery
{
	import com.cobalto.components.arrows.AbstractArrowNav;
	import com.cobalto.components.arrows.BaseArrowNav;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class GalleryArrows extends AbstractGallery
	{
		
		protected var _arrowNav:AbstractArrowNav;
		protected var _backSkin:Sprite;
		protected var _nextSkin:Sprite;
		
		public function GalleryArrows(urlArray:Array)
		{
			
			super(urlArray);
		
		}
		
		override public function startMultiLoader():void
		{
			super.startMultiLoader();
			
			createArrows();
		}
		
		public function startMultiLoaderWithoutArrows():void
		{
			super.startMultiLoader();
			
		}
		
		override protected function onImgInit(e:Event):void
		{
			
			super.onImgInit(e);
		
		}
		
		protected function createArrows():void
		{
			
			trace("create arrows on gallery arrows");

			_arrowNav = new BaseArrowNav();
			_arrowNav.createArrows(_backSkin,_nextSkin);
			_arrowNav.addEventListener(AbstractArrowNav.ARROW_BACK_CLICK,onArrowBackClick);
			_arrowNav.addEventListener(AbstractArrowNav.ARROW_BACK_OVER,onArrowBackOver);
			_arrowNav.addEventListener(AbstractArrowNav.ARROW_BACK_OUT,onArrowBackOut);
			_arrowNav.addEventListener(AbstractArrowNav.ARROW_NEXT_CLICK,onArrowNextClick);
			_arrowNav.addEventListener(AbstractArrowNav.ARROW_NEXT_OVER,onArrowNextOver);
			_arrowNav.addEventListener(AbstractArrowNav.ARROW_NEXT_OUT,onArrowNextOut);
			addChild(_arrowNav);
		
		}
		
		
	
		// * handlers
		protected function onArrowBackClick(e:Event):void
		{
			
		
		}
		
		protected function onArrowNextClick(e:Event):void
		{
		
		}
		
		protected function onArrowBackOver(e:Event):void
		{
		
		}
		
		protected function onArrowBackOut(e:Event):void
		{
		
		}
		
		protected function onArrowNextOver(e:Event):void
		{
		
		}
		
		protected function onArrowNextOut(e:Event):void
		{
		
		}
		
		public function set backSkin(skin:Sprite):void
		{
			
			_backSkin = skin;
		
		}
		
		public function set nextSkin(skin:Sprite):void
		{
			
			_nextSkin = skin;
		
		}
		
		public function get arrowNav():AbstractArrowNav
		{
			
			return _arrowNav;
		
		}
		
		override public function destroy(e:Event=null):void
		{
			super.destroy(e);
			
			if(_arrowNav)
			{
				_arrowNav.removeEventListener(AbstractArrowNav.ARROW_BACK_CLICK,onArrowBackClick);
				_arrowNav.removeEventListener(AbstractArrowNav.ARROW_BACK_OVER,onArrowBackOver);
				_arrowNav.removeEventListener(AbstractArrowNav.ARROW_BACK_OUT,onArrowBackOut);
				_arrowNav.removeEventListener(AbstractArrowNav.ARROW_NEXT_CLICK,onArrowNextClick);
				_arrowNav.removeEventListener(AbstractArrowNav.ARROW_NEXT_OVER,onArrowNextOver);
				_arrowNav.removeEventListener(AbstractArrowNav.ARROW_NEXT_OUT,onArrowNextOut);
			}
		}
		
		public function resizeGallery():void
		{
			
		}
	
	}
}