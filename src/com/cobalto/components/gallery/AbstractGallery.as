package com.cobalto.components.gallery
{
	import com.cobalto.api.IMenu;
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.components.menu.BasicMenu;
	import com.cobalto.loading.BulkLoader;
	import com.cobalto.loading.loadingtypes.ImageItem;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	import flash.system.LoaderContext;
	
	import org.hamcrest.object.nullValue;
	
	public class AbstractGallery extends Sprite implements IMenu
	{
		
		public var _urlArray:Array;
		protected var _imgMenu:BasicMenu;
		protected var _multiLoader:BulkLoader;
		protected var _activeImgId:int;
		protected var _imageArray:Array = new Array();
		protected var _currentProgressId:int;
		protected var _isStarted:Boolean = false;
		protected var _id:uint;
		protected var _lastImageLoadedID:uint;
		
		public static const IMAGE_CHANGED:String = "ImageChanged";
		public static const IMAGE_CLICKED:String = "ImageClicked";
		public static const IMAGE_LOADED:String = "ImageLoaded";
		public static const FIRST_IMAGE_LOADED:String = "FirstImageLoaded";
		public static const TRANSITION_OUT_COMPLETE:String = 'TransitionOutComplete';
		public static const TRANSITION_IN_COMPLETE:String = 'TransitionInComplete';
		
		public function AbstractGallery(urlArray:Array)
		{
			
			super();
			_urlArray = urlArray;
			addEventListener(Event.REMOVED_FROM_STAGE,destroy);
		}
		
		protected function createMenu():void
		{
			
			_imgMenu = new BasicMenu();
			_imgMenu.addEventListener(BasicMenu.BUTTON_ADDED,onImgAdded);
			_imgMenu.addEventListener(PrimitiveButton.BUTTON_CLICKED,onImgClick);
			_imgMenu.addEventListener(PrimitiveButton.BUTTON_OVER,onImgOver);
			_imgMenu.addEventListener(PrimitiveButton.BUTTON_OUT,onImgOut);
			_imgMenu.build(_urlArray.length);
			addChildAt(_imgMenu,0);
		
		}
		
		public function setOffset(x:int,y:int):void
		{
			
			_imgMenu.setOffset(x,y);
		
		}
		
		//*  img handlers
		protected function onImgAdded(e:Event):void
		{
			
			_imageArray.push({mc:e.target});
		
		}
		
		protected function onImgClick(e:Event):void
		{
			_activeImgId = e.target.id;
			PrimitiveButton(e.target.parent).dispatchEvent(new Event(IMAGE_CLICKED,true));
		}
		
		protected function onImgOver(e:Event):void
		{
		
		}
		
		protected function onImgOut(e:Event):void
		{
		
		}
		
		//* multiloader
		public function startMultiLoader():void
		{
			
			createMenu();
			
			_isStarted = true;
			
			_multiLoader = BulkLoader.createUniqueNamedLoader();
			
			//var loaderContext:LoaderContext = new LoaderContext();
			//loaderContext.checkPolicyFile = true;
			var l:uint = urlArray.length;
			
			for(var i:int = 0;i < l; i++)
			{
				//_multiLoader.add(urlArray[i],{id:"img" + i,type:"image",index:i,context:loaderContext});
				_multiLoader.add(urlArray[i],{id:i,type:BulkLoader.TYPE_IMAGE,index:i});
				_multiLoader.get(i).addEventListener(Event.COMPLETE,onImgInit);
				_multiLoader.get(i).addEventListener(ProgressEvent.PROGRESS,onImgProgress);
				_multiLoader.get(i).addEventListener(BulkLoader.ERROR,onError);
				//_multiLoader.get("img" + i).addEventListener(BulkLoader.HTTP_STATUS,onHttpStatusHandler);
				
				
			}
			
			_multiLoader.addEventListener(BulkLoader.PROGRESS,onImgProgress);
			_multiLoader.start();
		
		}
		
		protected function onError(evt:ErrorEvent):void
		{
			trace("on error");
		}
		
		protected function onHttpStatusHandler(evt:HTTPStatusEvent):void
		{
			
			trace(evt.status);
			
			if(evt.status != 0)
			{
				trace("errore");
			}
		
		}
		
		protected function onImgProgress(e:ProgressEvent):void
		{
			//trace(e+" imgprogress");
		}
		
		protected function onImgInit(e:Event):void
		{
			if(_imageArray)
			{
				
				var imageItem:ImageItem = ImageItem(e.target);
				
				var id:int = int(imageItem.id);
				
				_multiLoader.get(id).removeEventListener(Event.COMPLETE,onImgInit);
				_multiLoader.get(id).removeEventListener(ProgressEvent.PROGRESS,onImgProgress);
				_multiLoader.get(id).removeEventListener(BulkLoader.ERROR,onError);
				_multiLoader.get(id).removeEventListener(HTTPStatusEvent.HTTP_STATUS,onHttpStatusHandler);
				
				var img:Bitmap = imageItem.content as Bitmap;
				
				if(img !== null)
				{
					img.smoothing = true;
				}
				
				var bt:PrimitiveButton = _imgMenu.itemArray[id].mc;
				bt.skin = img;
				setImgY(bt);
				
				_imageArray[id].img = img;
				
				dispatchEvent(new Event(IMAGE_LOADED));
				
				_lastImageLoadedID = id;
				
				//trace(_lastImageLoadedID + " last id");
				
				if(id == 0)
				{
					dispatchEvent(new Event(FIRST_IMAGE_LOADED));
				}
			}
		}
		
		public function getLastImageLoadedID():Number
		{
			return _lastImageLoadedID;
		}
		
		//can be used to change img y wen loaded
		protected function setImgY(bt:PrimitiveButton):void
		{
			//trace("--------------------@ bt.height = " + bt.height);
		}
		
		protected function onGalleryProgress(e:Event):void
		{
		
		}
		
		protected function onGalleryComplete(e:Event):void
		{
		
		}
		
		public function destroy(e:Event=null):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,destroy);
			
			if(_imageArray)
			{
				var l:uint = _imageArray.length;
				
				for(var i:uint = 0;i < l;i++)
				{
					if(_imageArray[i])
					{
						if(_imageArray[i].img)
						{
							_imageArray[i].img = null;
						}
					}
					
					if(_multiLoader.get(i))
					{
						_multiLoader.get(i).removeEventListener(Event.COMPLETE,onImgInit);
						_multiLoader.get(i).removeEventListener(ProgressEvent.PROGRESS,onImgProgress);
						_multiLoader.get(i).removeEventListener(BulkLoader.ERROR,onError);
					}
				}
			}
			
			if(_multiLoader)
				_multiLoader.clear();
			
			if(_imgMenu)
			{
				_imgMenu.removeEventListener(BasicMenu.BUTTON_ADDED,onImgAdded);
				_imgMenu.removeEventListener(PrimitiveButton.BUTTON_CLICKED,onImgClick);
				_imgMenu.removeEventListener(PrimitiveButton.BUTTON_OVER,onImgOver);
				_imgMenu.removeEventListener(PrimitiveButton.BUTTON_OUT,onImgOut);
				
			}
		
			_imageArray = null;
		
		}
		
		public function addItem(item:PrimitiveButton=null):void
		{
		
		}
		
		public function update(id:uint):void
		{
		}
		
		public function enableMenu():void
		{
		}
		
		public function disableMenu():void
		{
		}
		
		public function get activeId():uint
		{
			return _activeImgId;
		}
		
		public function get displayObject():DisplayObject
		{
			return this;
		}
		
		public function get itemArray():Array
		{
			return _imageArray;
		}
		
		public function set itemArray(array:Array):void
		{
			_imageArray = array;
		}
		
		public function get numItems():uint
		{
			return _imageArray.length;
		}
		
		//** getter - setters
		public function set urlArray(arr:Array):void
		{
			_urlArray = arr;
		}
		
		public function get urlArray():Array
		{
			return _urlArray;
		}
		
		public function get activeImgId():int
		{
			return _activeImgId;
		}
		
		public function set activeImgId(id:int):void
		{
			
			_activeImgId = id;
		
		}
		
		public function get multiProgressPercent():Number
		{
			
			return _multiLoader.percentLoaded;
		
		}
		
		public function get singleProgressPercent():Number
		{
			
			return _multiLoader.percentLoaded;
		
		}
		
		public function get imageArray():Array
		{
			
			return _imageArray;
		
		}
		
		public function get currentProgressId():int
		{
			return _currentProgressId;
		}
		
		public function get isStarted():Boolean
		{
			return _isStarted;
		}
		
		public function organizeItems():void
		{
		
		}
		
		public function transitionIn():void
		{
		
		}
		
		public function transitionOut():void
		{
		
		}
		
		protected function onTransitionOutEnd():void
		{
			dispatchEvent(new Event(TRANSITION_OUT_COMPLETE));
		}
		
		protected function onTransitionInEnd():void
		{
			dispatchEvent(new Event(TRANSITION_IN_COMPLETE));
		}
		
		public function set id(pageId:int):void
		{
			_id = pageId;
		}
		
		public function get id():int
		{
			return _id;
		}
	
	}

}