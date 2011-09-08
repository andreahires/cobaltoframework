package com.cobalto.core.controller
{
	import com.cobalto.core.model.FlowProxy;
	import com.cobalto.core.model.LanguageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ModelPrepCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var languageProxy:LanguageProxy = new LanguageProxy(notification.getBody());
			facade.registerProxy(languageProxy);
		}
		
	}
}