package com.cobalto.extended.magnolia.controller
{
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.extended.magnolia.model.MagnoliaRegisterProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class RegisterDataSendCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			MagnoliaRegisterProxy(facade.retrieveProxy(MagnoliaSiteFacade._registerProxyClass.NAME) as MagnoliaRegisterProxy).sendFormData(notification.getBody() as Object);
		}
	
	}
}