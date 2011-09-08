package com.cobalto.extended.magnolia.controller
{
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.extended.magnolia.model.MagnoliaContactProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ContactDataSendCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			MagnoliaContactProxy(facade.retrieveProxy(MagnoliaSiteFacade._contactProxyClass.NAME) as MagnoliaContactProxy).sendFormData(notification.getBody() as Object);
		}
	
	}
}