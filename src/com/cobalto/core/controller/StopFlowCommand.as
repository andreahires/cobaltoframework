package com.cobalto.core.controller
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.core.model.AbstractAssetsProxy;
	import com.cobalto.core.model.FlowProxy;
	import com.cobalto.components.pages.Page;
	import com.cobalto.core.view.PageMediator;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	

	public class StopFlowCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			sendNotification(ApplicationFacade.MENU_STATE_UPDATE, true);
		}
		
	}
}