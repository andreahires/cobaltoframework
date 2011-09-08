package com.cobalto.components.gallery
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.components.menu.AbstractMainMenu;
	import com.cobalto.loading.BulkLoader;
	import com.cobalto.loading.BulkProgressEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	public class AbstractColorsGallery extends Sprite
	{
		
		protected var multiLoader:BulkLoader;
		private var _colorsHolder:Sprite = new Sprite;
		
		protected var colorsValues:Array ;
		protected var colorsUrls:Array ;
		protected var colorsLabel:Array ;
		
		protected var colorsMenu:AbstractMainMenu;
		protected var colorMenuHolder:Sprite;
		
		protected var content:XML;
		private var _mainImg:Bitmap;
		
		public static const MAIN_IMG_LOADED:String = "MainImgLoaded";
		
		public function AbstractColorsGallery()
		{
			super();
		}
		
		public function build(content:XML):void
		{
			this.content = content;
			prepareData();
			loadBaseImg();
			buildColorSelector();
			
			addChild(colorsHolder);
		}
		
		//this is used to build the colors menu
		protected function buildColorSelector():void
		{
			throw new IllegalOperationError("buildColorSelector called from an Abstract Class should be overrided");
		}
		
		protected function prepareData():void
		{
			throw new IllegalOperationError("prepareData called from an Abstract Class should be overrided");
		}
		
		protected function loadBaseImg():void
		{
			throw new IllegalOperationError("loadImgs called from an Abstract Class should be overrided");
			
		}
		
		protected function loadColors():void
		{
			throw new IllegalOperationError("loadImgs called from an Abstract Class should be overrided");
		}
		
		protected function onBaseImgLoaded(e:Event):void
		{
			trace	("Load complete");
			_mainImg = multiLoader.getContent("baseImg") as Bitmap;
			colorsHolder.addChildAt(_mainImg,0);
			_mainImg.smoothing = true;
			
			//dispatch MainImgLoaded Event
			dispatchEvent(new Event(MAIN_IMG_LOADED,true));
			
			//remove loader events listener
			multiLoader.removeEventListener(BulkProgressEvent.COMPLETE,onBaseImgLoaded);
			
			//load other colors
			loadColors();
		}
		
		protected function onImgLoaded(e:Event):void
		{
			var id:String = e.target.id;
			//trace("loaded img = " + multiLoader.get(id).id );
			multiLoader.get(id).removeEventListener(Event.COMPLETE,onImgLoaded);
			//multiLoader.get(id).removeEventListener(BulkLoader.ERROR,onError);
			
			var img:Bitmap = multiLoader.getBitmap(id);
			if(img !== null)
			{
				trace("adding img at "+id.split("img")[1]);
				img.smoothing = true;
				colorsHolder.addChildAt(img, id.split("img")[1]);
				img.alpha = 0;				
			}
		}
		
		protected function onColorsLoaded(e:Event):void
		{
			
			trace("all colors are loaded");
			
			multiLoader.removeAll();
			multiLoader.removeEventListener(BulkProgressEvent.COMPLETE,onColorsLoaded);
			multiLoader.clear();
			multiLoader = null;
		}
		
		private function update():void
		{
			//change selected color
		}
			
		public function get menu():Sprite
		{
			return this.colorMenuHolder;
		}
		
		public function get mainImg():Bitmap
		{
			return _mainImg;
		}
		
		public function get colorsHolder():Sprite
		{
			return _colorsHolder;
		}
		
	}
}