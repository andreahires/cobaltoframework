package com.cobalto.core.model
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.loading.BulkLoader;
	import com.cobalto.loading.BulkProgressEvent;
	import com.cobalto.utils.AssetManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class MainAssetsProxy extends AbstractAssetsProxy implements IProxy
	{
		// Cannonical name of the Proxy
		public static const NAME:String = 'MainAssetsProxy';
		
		protected var libraryKey:String = null;
		protected var fontsKey:String = null;
		protected var introKey:String = null;
		protected var commonLabelXMLKey:String = null;
		
		public function MainAssetsProxy(assetListRef:Array=null)
		{
			super(NAME,assetListRef);
			assetList = assetListRef;
		}
		
		override public function onRegister():void
		{
			loadData();
		}
		
		override public function loadData():void
		{
			mainDataLoader = BulkLoader.createUniqueNamedLoader();
			
			for(var i:int = 0;i < assetList.length;i++)
			{
				
				var assetUrl:String = assetList[i].url;
				
				///** Coomented By Zulu  to resolve Placeholder(Registration components placeholder ),
				/// will be removed for live version.
				
				if(assetList[i].type == "library")
				{
					libraryKey = assetUrl;
					
					if(ApplicationFacade.baseURL == ApplicationFacade.compareURLToLoadLocalAssets)
						libraryKey = assetUrl = "assets/Library.swf";
					
				}
				
				if(assetList[i].type == "fonts")
				{
					fontsKey = assetUrl;
					
					if(ApplicationFacade.baseURL == ApplicationFacade.compareURLToLoadLocalAssets)
						fontsKey = assetUrl = "assets/Fonts.swf";
					
				}
				
				if(assetList[i].type == "intro")
					introKey = assetUrl;
				
				if(assetList[i].type == "xml")
					commonLabelXMLKey = assetUrl;
				
				mainDataLoader.add(assetUrl);
				
			}
			
			mainDataLoader.addEventListener(BulkProgressEvent.PROGRESS,onMainDataProgress);
			mainDataLoader.addEventListener(BulkProgressEvent.COMPLETE,onMainDataComplete);
			mainDataLoader.start();
		}
		
		override protected function onMainDataProgress(e:Event=null):void
		{
			sendNotification(ApplicationFacade.MAIN_ASSETS_PROGRESS,mainDataLoader.percentLoaded);
		}
		
		override protected function onMainDataComplete(e:Event=null):void
		{
			//*** get the common label xml
			if(commonLabelXMLKey)
				ApplicationFacade.commonLabelXML = new XML(mainDataLoader.get(commonLabelXMLKey).content) as XML;
			
		
			
			
			//** Registering Font, Library
			AssetManager.mainLibraryApplicationDom = (mainDataLoader.getMovieClip(libraryKey).loaderInfo.applicationDomain) as ApplicationDomain;
			AssetManager.fontsApplicationDom = (mainDataLoader.getContent(fontsKey).loaderInfo.applicationDomain) as ApplicationDomain;
			AssetManager.registerFonts(ApplicationFacade.FONT_LIST);
			
			//** Registering Intro Movie if(Available);
			if(introKey)
			{
				AssetManager.introMovie = (mainDataLoader.getMovieClip(introKey,true) as MovieClip);
			}
			
			sendNotification(ApplicationFacade.MAIN_ASSETS_AVAILABLE);
		
		}
		
		public function getAsset(key:String):void
		{
			AssetManager.getItem(key);
		}
	
	}
}