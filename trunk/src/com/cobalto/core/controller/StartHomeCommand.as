package com.cobalto.core.controller
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.core.model.FlowProxy;
	import com.cobalto.core.model.SWFAddressProxy;
	import com.cobalto.core.model.SiteTreeProxy;
	import com.cobalto.core.view.StageMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class StartHomeCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			// *** retrieve site proxy
			var siteTreeProxy:SiteTreeProxy = facade.retrieveProxy(SiteTreeProxy.NAME) as SiteTreeProxy;
			
			// *** retrieve swfAddressProxy
			var swfAddressProxy:SWFAddressProxy = facade.retrieveProxy(SWFAddressProxy.NAME) as SWFAddressProxy;
			
			// *** crete the mediators for Menu and Pageholder
			StageMediator(facade.retrieveMediator(StageMediator.NAME)).createSubMediators();
			
			//*** get the index array of the first page to initialize from the last address stored on swfAddressProxy
			var requestedIndexArray:Array = siteTreeProxy.getIndexArrayFromAddress(swfAddressProxy.lastUriSegments);

			// *** start the new page, this notification is listened by the startPageCommand
			sendNotification(ApplicationFacade.PAGE_CHANGE, requestedIndexArray);

		}
		
	}
}