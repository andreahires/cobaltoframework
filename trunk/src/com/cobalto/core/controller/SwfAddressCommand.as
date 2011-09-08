package com.cobalto.core.controller
{
	import com.cobalto.core.model.SWFAddressProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class SwfAddressCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			
			facade.registerProxy(new SWFAddressProxy());
		}
		
	}
}