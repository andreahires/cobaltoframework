package com.cobalto.core.model
{
	import com.asual.swfaddress.SWFAddress;
	import com.cobalto.ApplicationFacade;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.loading.BulkLoader;
	import com.cobalto.loading.BulkProgressEvent;
	import com.cobalto.loading.loadingtypes.LoadingItem;
	import com.cobalto.utils.AssetManager;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.system.ApplicationDomain;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	import site.SiteFacade;
	
	public class SoundProxy extends AbstractAssetsProxy implements IProxy
	{
		// Cannonical name of the Proxy
		public static const NAME:String = 'SoundProxy';
		
		protected var soundLibraryKey:String = null;
		protected var fontsKey:String = null;
		protected var introKey:String = null;
		protected var commonLabelXMLKey:String = null;
		private var loop:Sound;
		private var loopChannel:SoundChannel;
		
		public static var bubbleOver:Sound;
		
		public function SoundProxy(assetListRef:Array=null)
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
			
			var assetUrl:String = soundLibraryKey = assetList[0].url;
			soundLibraryKey = assetUrl = "assets/SoundLibrary.swf";

			var loadingItem:LoadingItem = mainDataLoader.add(assetUrl);
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
			//** Registering Font, Library
			AssetManager.soundApplicationDom = (mainDataLoader.getMovieClip(soundLibraryKey).loaderInfo.applicationDomain) as ApplicationDomain;
			ApplicationFacade.soundLoaded = true;
			
			initVolume();
			initLoop();
		}
		
		
		public static function playSound(linkageName:String):void
		{
			
			var vol:Number = 1;
			
			switch(linkageName)
			{
				case 'bubbleOver':
					vol = .2;
					break;
				
				case 'bubbleClick':
					vol = .6;
					break;
				
				case 'buttonOver':
					vol = 1;
					break;
					
				case 'buttonClick':
					vol = 1;
					break;
				
				case 'menuOver':
					vol = 1;
					break;
				
				case 'menuClick':
					vol = 1;
					break;
				
				case 'tagOver':
					vol = 4;
					break;
	
			}
			
			bubbleOver = AssetManager.getSound(linkageName);
			var bubbleChannel:SoundChannel = bubbleOver.play(0, 0, new SoundTransform(vol));
			
		}
		
		private function initLoop():void
		{
			//var l:MovieClip = AssetManager.getItem('loop', AssetManager.Sound_Library_Domain);
			//SiteFacade.stageRef.addChild(l)
			loop = AssetManager.getSound('loop');
			loopChannel = (loop as Sound).play(0, int.MAX_VALUE);
			loopChannel.soundTransform = new SoundTransform(0);

			playLoop(true);
			
		}
		
		public function playLoop(val:Boolean):void
		{

			TweenMax.killTweensOf(loopChannel);
			
			if(val)
			{
				TweenMax.to(loopChannel, 3, {volume:.15});
			}else{
				TweenMax.to(loopChannel, 3, {volume:0});
			}
			
		}

		private function initVolume():void
		{
			SoundMixer.soundTransform = new SoundTransform(.7); 
		}
		
		public function getAsset(key:String):void
		{
			AssetManager.getItem(key);
		}
	
	}
}