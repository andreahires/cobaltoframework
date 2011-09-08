package com.cobalto.core.controller
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.core.model.SiteTreeProxy;
	import com.cobalto.core.view.MainMenuMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class sendTargetUrlCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var siteTreeProxy:SiteTreeProxy = facade.retrieveProxy(SiteTreeProxy.NAME) as SiteTreeProxy;
			
			if(siteTreeProxy)
			{
				
				var requestedIndexArray:Array = siteTreeProxy.getIndexArrayFromAddress(notification.getBody() as String);
				
				if(!requestedIndexArray)
				{
					requestedIndexArray = siteTreeProxy.getIndexArrayFromAddress(ApplicationFacade.ERROR_PAGE_ADDRESS);
				}
				
				sendNotification(ApplicationFacade.PAGE_CHANGE,requestedIndexArray.concat());
				
				var mainMenuMediator:MainMenuMediator = facade.retrieveMediator(MainMenuMediator.NAME) as MainMenuMediator;
				
				if(mainMenuMediator)
					mainMenuMediator.updateMenus(requestedIndexArray.concat());
				
			}
		
		}
	
	}
}