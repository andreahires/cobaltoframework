package com.cobalto.core.controller
{
	import com.cobalto.core.model.SiteTreeProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SiteTreeCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
				
			var siteTreeProxy:SiteTreeProxy = new SiteTreeProxy(notification.getBody());
			facade.registerProxy(siteTreeProxy);

		
		}

	}
}