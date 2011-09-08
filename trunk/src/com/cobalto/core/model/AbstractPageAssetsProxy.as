package com.cobalto.core.model
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.loading.BulkLoader;
	import com.cobalto.loading.BulkProgressEvent;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class AbstractPageAssetsProxy extends AbstractAssetsProxy implements IProxy
	{
		
		protected var assetUrlArray:Array;
		protected var xml:XML;
		
		public function AbstractPageAssetsProxy(proxyName:String,assetListRef:Array=null)
		{
			super(proxyName,assetListRef);
		}
		
		override public function loadData():void
		{
			assetUrlArray = new Array();
			
			mainDataLoader = BulkLoader.createUniqueNamedLoader();
			
			for(var i:int = 0;i < assetList.length;i++)
			{
				
				assetUrlArray[i] = assetList[i].url;
				
				mainDataLoader.add(assetUrlArray[i]);
				mainDataLoader.get(assetUrlArray[i]).addEventListener(BulkLoader.HTTP_STATUS,onLoadError);
				mainDataLoader.get(assetUrlArray[i]).addEventListener(BulkProgressEvent.COMPLETE,onSingleItemComplete);
			}
			
			mainDataLoader.addEventListener(BulkProgressEvent.PROGRESS,onMainDataProgress);
			mainDataLoader.addEventListener(BulkProgressEvent.COMPLETE,onMainDataComplete);
			mainDataLoader.start();
			
			sendNotification(ApplicationFacade.GENERAL_PROGRESS_START);
		}
		
		protected function onLoadError(e:HTTPStatusEvent):void
		{
		
		}
		
		protected function onSingleItemComplete(e:Event):void
		{
		
		}
		
		override protected function onMainDataComplete(e:Event=null):void
		{
			//super.onMainDataComplete(e);
			
			// *** checking the type to retrieve the correct pageData 
			var pageDataId:Number;
			var assetLength:uint = assetUrlArray.length;
			
			for(var i:uint = 0;i < assetLength;i++)
			{
				pageDataId = i;
				
				if(assetList[i].type == "xml")
				{
					
					var pageXml:XML = xml = mainDataLoader.getContent(assetUrlArray[pageDataId]);
					
					// *** add the data on the asset Array
					loadedItems.push(pageXml);
					
				}
				else
				{
					
					loadedItems.push(mainDataLoader.getContent(assetUrlArray[pageDataId]));
				}
				
			}
			
			if(pageXml.code == "401" || pageXml.code == "0")
			{
				
				sendNotification(ApplicationFacade.GENERAL_COMPLETE,1);
				
				var noteObject:Object = {pageData:[],indexes:params.indexes,pageDepth:params.pageDepth};
				sendNotification(ApplicationFacade.PAGE_DATA_COMPLETE,noteObject);
				
				return;
			}
			
			if(!isNaN(pageDataId))
			{
				// *** retrieve the loaded data 
				notificatePageComplete();
			}
			else
			{
				throw new IllegalOperationError("there is not a pageData type asset on the siteTree xml for the page:" + this);
			}
		
		}
		
		protected function notificatePageComplete():void
		{
			var noteObject:Object = {pageData:loadedItems,indexes:params.indexes,pageDepth:params.pageDepth};
			sendNotification(ApplicationFacade.PAGE_DATA_COMPLETE,noteObject);
			sendNotification(ApplicationFacade.GENERAL_COMPLETE,noteObject);
		}
		
		override public function clear():void
		{
			/*if(mainDataLoader)
			   {
			   mainDataLoader.clear();
			 }*/
			//loadedItems = null;
			xml = null;
		}
	}
}