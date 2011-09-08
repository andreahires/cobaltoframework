package com.cobalto.extended.magnolia.model
{
	
	import com.cobalto.ApplicationFacade;
	import com.cobalto.core.model.AbstractPageAssetsProxy;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.loading.BulkLoader;
	import com.cobalto.loading.BulkProgressEvent;
	import com.cobalto.utils.UrlLoader;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class MagnoliaRegisterProxy extends MagnoliaPageProxy implements IProxy
	{
		
		protected var formLoader:UrlLoader;
		protected var registertUrlAction:String;
		
		public function MagnoliaRegisterProxy(proxyName:String,assetListRef:Array=null)
		{
			super(proxyName,assetListRef);
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
					
					registertUrlAction = ApplicationFacade.baseURL+xml.properties.action;
					
				}
				else
				{
					loadedItems.push(mainDataLoader.getContent(assetUrlArray[pageDataId]));
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
		
		override public function sendFormData(obj:Object=null):void
		{
			
			var filteredData:Object = {};
			
			   for(var prop:* in obj)
			   {
				   var dataValue:*;
				   (obj[prop]) ? dataValue = obj[prop] : dataValue = '  ';
				   filteredData[prop] = dataValue;
			   }
			
			 if(formLoader) formLoader.destroy(); formLoader=null;
				
			 formLoader = new UrlLoader(registertUrlAction,filteredData)
				 //ApplicationFacade.baseURL+xml.properties.action
			 addLoaderListeners(formLoader);
		}
		
		protected function addLoaderListeners(ldr:IEventDispatcher):void
		{
			ldr.removeEventListener(UrlLoader.INIT,init);
			ldr.removeEventListener(UrlLoader.ON_PROGRESS,onProgress);
			ldr.removeEventListener(UrlLoader.ON_COMPLETE,onComplete);
			ldr.removeEventListener(UrlLoader.ON_SECURITY_ERROR,securityError);
			ldr.removeEventListener(UrlLoader.ON_HTTP_STATUS,httpStatus);
			ldr.removeEventListener(UrlLoader.ON_IO_ERROR,ioError);
			
			//////------------------------------------------//////
			
			ldr.addEventListener(UrlLoader.INIT,init);
			ldr.addEventListener(UrlLoader.ON_PROGRESS,onProgress);
			ldr.addEventListener(UrlLoader.ON_COMPLETE,onComplete);
			ldr.addEventListener(UrlLoader.ON_SECURITY_ERROR,securityError);
			ldr.addEventListener(UrlLoader.ON_HTTP_STATUS,httpStatus);
			ldr.addEventListener(UrlLoader.ON_IO_ERROR,ioError);
		}
		
		protected function init(e:Event):void
		{
			sendNotification(MagnoliaSiteFacade.REGISTER_DATA_RESPONSE,'init');
		}
		
		protected function onProgress(event:Event):void
		{
			sendNotification(MagnoliaSiteFacade.REGISTER_DATA_RESPONSE,'progress');
		}
		
		protected function onComplete(e:Event):void
		{
			var finalXml:XMLList = new XMLList(formLoader.resultData);
			var result:String = finalXml.result;
			//<registration><result>FAILED</result><errors><error code="username.existing">login</error><error code="email.existing">email</error></errors></registration>
			var object:Object={result:result, errors:XMLList(finalXml.errors.error)};
			
			sendNotification(MagnoliaSiteFacade.REGISTER_DATA_RESPONSE,object);
		}
		protected function securityError(event:Event):void
		{
			sendNotification(MagnoliaSiteFacade.REGISTER_DATA_RESPONSE,'securityError');
		}
		
		protected function httpStatus(event:Event):void
		{
			sendNotification(MagnoliaSiteFacade.REGISTER_DATA_RESPONSE,'httpStatus');
		}
		
		protected function ioError(event:Event):void
		{
			sendNotification(MagnoliaSiteFacade.REGISTER_DATA_RESPONSE,'ioError');
		}
	
	}
}