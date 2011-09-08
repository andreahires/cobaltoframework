package com.cobalto.core.controller
{
	import com.cobalto.core.model.FlowProxy;
	import com.cobalto.core.model.SiteTreeProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class FlowStartupCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			var siteTree:Array = SiteTreeProxy(facade.retrieveProxy(SiteTreeProxy.NAME)).getTree();
			var flowProxy:FlowProxy = new FlowProxy(siteTree);
			
			facade.registerProxy(flowProxy);
			
		}
		
	}
}