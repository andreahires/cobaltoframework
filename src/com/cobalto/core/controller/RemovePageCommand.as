package com.cobalto.core.controller
{
	import com.cobalto.core.model.AbstractAssetsProxy;
	import com.cobalto.core.model.FlowProxy;
	import com.cobalto.components.pages.Page;
	import com.cobalto.core.view.AbstractPageMediator;
	import com.cobalto.core.view.PageMediator;
	import com.cobalto.core.view.ProgressMediator;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class RemovePageCommand extends SimpleCommand
	{
		
		public override function execute(notification:INotification):void
		{
			
			var flowProxy:FlowProxy = FlowProxy(facade.retrieveProxy(FlowProxy.NAME))
			//trace(notification+" note removeCommand");
			var pageIndexArray:Array = notification.getBody().indexes.concat();
			var pageDepth:int = notification.getBody().pageDepth;
			
			var oldProxy:IProxy = flowProxy.getPageProxy(pageDepth,0) as IProxy;
			var oldMediator:IMediator = flowProxy.getPageMediator(pageDepth,0) as IMediator;
			var oldViewComponent:Page = flowProxy.getPageViewComponent(pageDepth,0) as Page;
			
			//trace(oldProxy.getProxyName() + " proxy name");
			///** clear data and remove Proxy
			AbstractAssetsProxy(oldProxy).clear();
			facade.removeProxy(oldProxy.getProxyName());
			
			//*** remove the old page Mediator
			//trace("remove Mediator"+oldMediator.getMediatorName());
			AbstractPageMediator(oldMediator).destroy();
			facade.removeMediator(oldMediator.getMediatorName());
			
			//*** remove the page viewComponent
			PageMediator(facade.retrieveMediator(PageMediator.NAME)).removePageComponent(pageDepth,oldViewComponent);
			
			flowProxy.removePage(pageDepth,0);
			
			ProgressMediator(facade.retrieveMediator(ProgressMediator.NAME)).reset();
			
			oldViewComponent = null;
		}
	
	}
}