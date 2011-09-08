package com.cobalto.core.controller
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.api.IViewComponent;
	import com.cobalto.core.model.AbstractAssetsProxy;
	import com.cobalto.core.model.FlowProxy;
	import com.cobalto.core.model.SiteTreeProxy;
	import com.cobalto.core.view.AbstractPageMediator;
	import com.cobalto.core.view.PageMediator;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class InitPageCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			
			var indexArray:Array = notification.getBody().indexes as Array;
			var pageDepth:int = notification.getBody().pageDepth as int;
			
			var refClass:String = SiteTreeProxy(facade.retrieveProxy(SiteTreeProxy.NAME)).getRefClass(indexArray.concat());
			
			ApplicationFacade.lastPageCreatedRefClass = refClass;
			ApplicationFacade.lastTitle = SiteTreeProxy(facade.retrieveProxy(SiteTreeProxy.NAME)).getMenuTitle(indexArray.concat());
			
			// *** create the UI for the new Page
			var pageClass:Class = getDefinitionByName(ApplicationFacade.basePackage + ".pages." + refClass) as Class;
			var newPageComponent:IViewComponent = new pageClass();
			//newPageComponent.id = SiteTreeProxy(facade.retrieveMediator(SiteTreeProxy.NAME)).getIdFromRefclass(refClass);
			
			PageMediator(facade.retrieveMediator(PageMediator.NAME)).addNewPage(newPageComponent as DisplayObjectContainer,pageDepth);
			
			// *** create the Mediator for the new Page
			var mediatorClass:Class;
			
			try
			{
				mediatorClass = getDefinitionByName(ApplicationFacade.basePackage + ".pages.view." + refClass + "Mediator") as Class;
			}
			catch(e:*)
			{
				mediatorClass = ApplicationFacade._defaultMediatorClass as Class;
			}
			
			var newPageMediator:IMediator = new mediatorClass(refClass + "Mediator?id=" + Math.random() * 9999,newPageComponent);
			AbstractPageMediator(newPageMediator).params = {indexes:indexArray.concat(),pageDepth:pageDepth};
			
			//trace("assign mediator parameters:"+indexArray.concat()+"  Mediator:"+newPageMediator);
			facade.registerMediator(newPageMediator);
			
			// *** create the Proxy for the new Page
			var proxyClass:Class;
			
			try
			{
				proxyClass = getDefinitionByName(ApplicationFacade.basePackage + ".pages.model." + refClass + "Proxy") as Class;
			}
			catch(e:*)
			{
				proxyClass = ApplicationFacade._defaultProxyClass as Class;
			}
			
			var newPageProxy:IProxy = new proxyClass(String(refClass) + "Proxy?id=" + Math.random() * 9999);
			//trace("register" + newPageProxy);
			AbstractAssetsProxy(newPageProxy).params = {indexes:indexArray.concat(),pageDepth:pageDepth};
			facade.registerProxy(newPageProxy);
			
			// *** create the Proxy for the new Page
			FlowProxy(facade.retrieveProxy(FlowProxy.NAME)).addNewPage(indexArray.concat(),pageDepth,newPageComponent as DisplayObjectContainer,newPageMediator,newPageProxy,refClass);
			
			var firstEvent:String = FlowProxy(facade.retrieveProxy(FlowProxy.NAME)).handleNewFlow(indexArray,pageDepth);
			checkMenuState(firstEvent);
		}
		
		protected function checkMenuState(newEvent:String):void
		{
			
			var val:Boolean = false;
			
			if(newEvent == ApplicationFacade.STOP_FLOW)
			{
				val = true;
			}
			sendNotification(ApplicationFacade.MENU_STATE_UPDATE,val);
		
		}
	
	}
}