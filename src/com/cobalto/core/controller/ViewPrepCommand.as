package com.cobalto.core.controller
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.core.view.StageMediator;
	
	import flash.display.Stage;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ViewPrepCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			var app:Stage = notification.getBody().app as Stage;
			var stageMediatorClass:Class = ApplicationFacade._stageMediatorClass;
			facade.registerMediator(new stageMediatorClass(app));
		}
	
	}

}