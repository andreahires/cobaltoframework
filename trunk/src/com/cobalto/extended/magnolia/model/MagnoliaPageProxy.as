package com.cobalto.extended.magnolia.model
{
	
	import com.cobalto.ApplicationFacade;
	import com.cobalto.core.model.AbstractPageAssetsProxy;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.loading.BulkLoader;
	import com.cobalto.loading.BulkProgressEvent;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class MagnoliaPageProxy extends AbstractPageAssetsProxy implements IProxy
	{
		
		protected var pageMode:String;
		protected var loggedUser:String = null;
		protected var pagePermission:String;
		
		public function MagnoliaPageProxy(proxyName:String,assetListRef:Array=null)
		{
			super(proxyName,assetListRef);
		}
		
		override public function loadData():void
		{
			assetUrlArray = new Array();
			
			//**** can be a problem if more classes extend this one? I mean, lot instances of bulkloader with the same name??? test iT!!!
			mainDataLoader = BulkLoader.createUniqueNamedLoader();
			
			for(var i:int = 0;i < assetList.length;i++)
			{
				var toAppend:String = "";
				
				if(MagnoliaSiteFacade.APPENDLOGIN.length > 2)
					toAppend = "?" + MagnoliaSiteFacade.APPENDLOGIN;
				
				assetUrlArray[i] = assetList[i].url + toAppend;
				
				mainDataLoader.add(assetUrlArray[i]);
				mainDataLoader.get(assetUrlArray[i]).addEventListener(BulkLoader.HTTP_STATUS,onLoadError);
				mainDataLoader.get(assetUrlArray[i]).addEventListener(BulkProgressEvent.COMPLETE,onSingleItemComplete);
			}
			
			mainDataLoader.addEventListener(BulkProgressEvent.PROGRESS,onMainDataProgress);
			mainDataLoader.addEventListener(BulkProgressEvent.COMPLETE,onMainDataComplete);
			mainDataLoader.start();
			
			sendNotification(ApplicationFacade.GENERAL_PROGRESS_START);
		}
		
		override protected function onLoadError(e:HTTPStatusEvent):void
		{
			//trace(e.status + "---- error trace");
			
			if(mainDataLoader)
			{
				//trace("LOADER ERROR");
				//trace("e.status = "+e.status);
				if(e.status == 0 || e.status == 401)
				{
					
					mainDataLoader.removeEventListener(BulkProgressEvent.PROGRESS,onMainDataProgress);
					mainDataLoader.removeEventListener(BulkProgressEvent.COMPLETE,onMainDataComplete);
					sendNotification(MagnoliaSiteFacade.LOGIN_REQUEST,this.loadData);
					mainDataLoader = null;
					sendNotification(ApplicationFacade.GENERAL_COMPLETE,1);
					
					var noteObject:Object = {pageData:[],indexes:params.indexes,pageDepth:params.pageDepth,mode:pageMode};
					sendNotification(ApplicationFacade.PAGE_DATA_COMPLETE,noteObject);
				}
			}
		}
		
		// --- 
		override protected function onSingleItemComplete(e:Event):void
		{
			//trace(e + "single complete");
			e.target.removeEventListener(BulkLoader.HTTP_STATUS,onLoadError);
			e.target.removeEventListener(BulkProgressEvent.COMPLETE,onSingleItemComplete);
		}
		
		override protected function onMainDataComplete(e:Event=null):void
		{
			
			// Hide Login Panel If opened;
			sendNotification(MagnoliaSiteFacade.HIDE_LOGIN_PANEL_IF_OPENED,true);
			
			// *** checking the type to retrieve the correct pageData 
			var pageDataId:Number;
			var assetLength:uint = assetUrlArray.length;
			
			for(var i:uint = 0;i < assetLength;i++)
			{
				pageDataId = i;
				
				if(assetList[i].type == "xml")
				{
					var pageXml:XML = mainDataLoader.getContent(assetUrlArray[pageDataId]);
					xml = pageXml;
					
					// *** add the data on the asset Array
					loadedItems.push(pageXml);
					
					//*** retrieve the mode
					pageMode = pageXml.@mode.toString();
					loggedUser = pageXml.@loggedUser.toString();
					pagePermission = pageXml.@permission.toString();
				}
				else
				{
					if(BulkLoader.guessType(assetUrlArray[pageDataId]) == "movieclip")
					{
						loadedItems.push(mainDataLoader.getMovieClip(assetUrlArray[pageDataId]));
						
					}
					else
					{
						loadedItems.push(mainDataLoader.getContent(assetUrlArray[pageDataId]));
					}
					
				}
				
			}
			
			if(pageXml.code == "401" || pageXml.code == "0")
			{

				sendNotification(MagnoliaSiteFacade.LOGIN_REQUEST,this.loadData);
				sendNotification(ApplicationFacade.GENERAL_COMPLETE,1);
				
				var noteObject:Object = {pageData:[],indexes:params.indexes,pageDepth:params.pageDepth,mode:pageMode};
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
				//throw new IllegalOperationError("there is not a pageData type asset on the siteTree xml for the page:"+this);
			}
		
		}
		
		override protected function notificatePageComplete():void
		{
			// *** send the parameters as note
			var noteObject:Object = {pageData:loadedItems,indexes:params.indexes,pageDepth:params.pageDepth,mode:pageMode};
			sendNotification(ApplicationFacade.PAGE_DATA_COMPLETE,noteObject);
			
			// Added by Zulu for login status purpose
			(loggedUser) ? sendNotification(MagnoliaSiteFacade.LOGIN_STATUS,true) : sendNotification(MagnoliaSiteFacade.LOGIN_STATUS,false);
			
			sendNotification(ApplicationFacade.GENERAL_COMPLETE,noteObject);
			//clear();
		}
		
		public function sendFormData(obj:Object=null):void
		{
		
		}
	}
}