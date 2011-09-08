package com.cobalto.core.controller
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.core.model.AbstractAssetsProxy;
	import com.cobalto.core.model.FlowProxy;
	import com.cobalto.core.model.SiteTreeProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	

	public class PageDataCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			
			var indexArray:Array = notification.getBody().indexes as Array;
			var pageDepth:int = notification.getBody().pageDepth as int;
			
			var flowProxy:FlowProxy = facade.retrieveProxy(FlowProxy.NAME) as FlowProxy;
			
			var pageProxy:AbstractAssetsProxy = flowProxy.getPageProxyAt(pageDepth) as AbstractAssetsProxy;
			//trace("get page proxy for load data at depth: "+pageDepth+" proxy: "+pageProxy);
			
			var pageAssetList:Array = SiteTreeProxy(facade.retrieveProxy(SiteTreeProxy.NAME)).getAssetList(indexArray.concat());
			//trace(pageAssetList+" assetList of indexArray:"+indexArray);
			if(pageAssetList)
			{
				pageProxy.setAssetList(pageAssetList);
				pageProxy.loadData();
				
			}else{
				
				sendNotification(ApplicationFacade.PAGE_DATA_COMPLETE, {pageData:null, indexes:indexArray, pageDepth:pageDepth});
				sendNotification(ApplicationFacade.GENERAL_COMPLETE, {pageData:null, indexes:indexArray, pageDepth:pageDepth});
			} 
			
		}
		
	}
}