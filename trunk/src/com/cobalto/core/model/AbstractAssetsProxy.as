package com.cobalto.core.model
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.loading.BulkLoader;
	import com.cobalto.loading.BulkProgressEvent;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AbstractAssetsProxy extends Proxy implements IProxy
	{
		// Cannonical name of the Proxy
		public static const NAME:String = 'AbstractAssetProxy';
		
		protected var mainDataLoader:BulkLoader;
		protected var assetList:Array;
		protected var loadedItems:Array = new Array();
		protected var _params:Object;
		protected var isProxyPersistent:Boolean = false;
		
		public function AbstractAssetsProxy(proxyName:String,assetListRef:Array=null)
		{
			super(proxyName);
			assetList = assetListRef;
		}
		
		public function loadData():void
		{
			
			//**** can be a problem if more classes extend this one? I mean, lot instances of bulkloader with the same name??? test iT!!!
			mainDataLoader = new BulkLoader(NAME + "_BulkLoader" + Math.random() * 999999);
			
			for(var i:int = 0;i < assetList.length;i++)
			{
				mainDataLoader.add(assetList[i].url);
			}
			
			mainDataLoader.addEventListener(BulkProgressEvent.PROGRESS,onMainDataProgress);
			mainDataLoader.addEventListener(BulkProgressEvent.COMPLETE,onMainDataComplete);
			mainDataLoader.start();
		
		}
		
		protected function onMainDataProgress(e:Event=null):void
		{
			sendNotification(ApplicationFacade.GENERAL_PROGRESS,mainDataLoader.percentLoaded);
		}
		
		protected function onMainDataComplete(e:Event=null):void
		{
		
		}
		
		public function setAssetList(newAssetList:Array):void
		{
			assetList = newAssetList;
		}
		
		public function getLoadedItems():Array
		{
			return loadedItems;
		}
		
		public function clear():void
		{
			if(mainDataLoader)
			{
				mainDataLoader.removeAll();
				mainDataLoader.clear();
			}
		};
		
		public function set params(par:Object):void
		{
			_params = par;
		}
		
		public function get params():Object
		{
			return _params;
		}

		public function set isPersistent(val:Boolean):void
		{
			isProxyPersistent = val;
		}
		
		public function get isPersistent():Boolean
		{
			return isProxyPersistent;
		}
	
	}
}