package com.cobalto.extended.magnolia.controller
{
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	
	public class LoginDataSendCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			//trace(" Login data send command : INotification000000    : >>>>>>>>>>>>>>>>>>>>> >>>>>>>>>>>>   ");
			MagnoliaSiteFacade.APPENDLOGIN = notification.getBody().toString();
			//trace(notification.getBody() + " notification.getBody    : >>>>>>>>>>>>>>>>>>>>> >>>>>>>>>>>>   ");
			MagnoliaSiteFacade.LOGIN_CALLBACK();
		}
	
	}
}