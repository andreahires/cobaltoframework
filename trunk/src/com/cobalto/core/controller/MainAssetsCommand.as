package com.cobalto.core.controller
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.core.model.LanguageProxy;
	import com.cobalto.core.model.MainAssetsProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class MainAssetsCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			
			
		
			var assetList:Array = LanguageProxy(facade.retrieveProxy(LanguageProxy.NAME)).getAssetList();
			var assetsProxy:MainAssetsProxy = new MainAssetsProxy(assetList);
			facade.registerProxy(assetsProxy);
			
		}
		
	}
}