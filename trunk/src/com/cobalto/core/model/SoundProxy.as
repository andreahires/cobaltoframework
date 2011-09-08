package com.cobalto.core.model
{
	import com.asual.swfaddress.SWFAddress;
	import com.cobalto.ApplicationFacade;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.loading.BulkLoader;
	import com.cobalto.loading.BulkProgressEvent;
	import com.cobalto.utils.AssetManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class SoundProxy extends AbstractAssetsProxy implements IProxy
	{
		// Cannonical name of the Proxy
		public static const NAME:String = 'SoundProxy';
		
		protected var soundLibraryKey:String = null;
		protected var fontsKey:String = null;
		protected var introKey:String = null;
		protected var commonLabelXMLKey:String = null;
		
		public function SoundProxy(assetListRef:Array=null)
		{
			super(NAME,assetListRef);
			assetList = assetListRef;
		}
		
		override public function onRegister():void
		{
			if(SWFAddress.getBaseURL() == "http://piaggio-author.openmindonline.it")
			{

				loadData();
			}
		}
		
		override public function loadData():void
		{
			mainDataLoader = new BulkLoader("SoundDataBulk");
			
			var assetUrl:String = soundLibraryKey = assetList[0].url;
			
			//var assetUrl:String;
			
			if(SWFAddress.getBaseURL() == "http://piaggio-author.openmindonline.it")
			{

				soundLibraryKey = assetUrl = "assets/SoundLibrary2.swf";
			}
				
			
			//var assetUrl:String="assets/SoundLibrary.swf";
			
			mainDataLoader.add(assetUrl);
			
			mainDataLoader.addEventListener(BulkProgressEvent.PROGRESS,onMainDataProgress);
			mainDataLoader.addEventListener(BulkProgressEvent.COMPLETE,onMainDataComplete);
			mainDataLoader.start();
		}
		
		override protected function onMainDataProgress(e:Event=null):void
		{
			//sendNotification(ApplicationFacade.MAIN_ASSETS_PROGRESS,mainDataLoader.percentLoaded);
		}
		
		override protected function onMainDataComplete(e:Event=null):void
		{
			//*** get the common label xml
			
			//** Registering Font, Library
			AssetManager.soundApplicationDom = (mainDataLoader.getMovieClip(soundLibraryKey).loaderInfo.applicationDomain) as ApplicationDomain;
			
			//AssetManager.fontsApplicationDom = (mainDataLoader.getContent(fontsKey).loaderInfo.applicationDomain) as ApplicationDomain;
			//AssetManager.registerFonts(ApplicationFacade.FONT_LIST);
			
			//** Registering Intro Movie if(Available);
			
			//sendNotification(ApplicationFacade.MAIN_SOUNDS_AVAILABLE);
			
			ApplicationFacade.soundLoaded = false;
		
		}
		
		public function getAsset(key:String):void
		{
			AssetManager.getItem(key);
		}
	
	}
}