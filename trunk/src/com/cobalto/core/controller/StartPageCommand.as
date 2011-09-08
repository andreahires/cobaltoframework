package com.cobalto.core.controller
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.core.model.FlowProxy;
	import com.cobalto.core.model.SiteTreeProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartPageCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			
			if(FlowProxy(facade.retrieveProxy(FlowProxy.NAME)))
			{
				
				var indexArray:Array = notification.getBody() as Array;
				var siteTreeProxy:SiteTreeProxy = facade.retrieveProxy(SiteTreeProxy.NAME) as SiteTreeProxy;
				var refClass:String = siteTreeProxy.getRefClass(indexArray.concat());
				
				
				
				if(refClass && refClass != "Bridge")
				{
					//var pageDepth:int = siteTreeProxy.getDepth(indexArray);
					var pageDepth:int = 1;
					
					FlowProxy(facade.retrieveProxy(FlowProxy.NAME)).startNewFlow(indexArray,pageDepth);
					
					var address:String = siteTreeProxy.getAddress(indexArray.concat());
					sendNotification(ApplicationFacade.ADDRESS_CHANGE,address);
					
					var pageTitle:String = siteTreeProxy.getPageTitle(indexArray.concat());
					
					var menuTitle:String = siteTreeProxy.getMenuTitle(indexArray.concat());
					ApplicationFacade.currentMenuTitle = menuTitle;
					
					sendNotification(ApplicationFacade.TITLE_CHANGE,pageTitle);
				}
				
			}
		
		}
	
	}
}