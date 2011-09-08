package com.cobalto.core.controller
{
	import com.cobalto.core.model.FlowProxy;
	import com.cobalto.core.view.AbstractPageMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	

	public class PopulatePageCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var indexArray:Array = notification.getBody().indexes as Array;
			var pageDepth:int = notification.getBody().pageDepth as int;
			//trace("PopulatePage indexes"+indexArray);
			var pageMediator:AbstractPageMediator = FlowProxy(facade.retrieveProxy(FlowProxy.NAME)).getPageMediatorAt(pageDepth) as AbstractPageMediator;
			pageMediator.populatePage(notification.getBody());
		}
		
	}
}