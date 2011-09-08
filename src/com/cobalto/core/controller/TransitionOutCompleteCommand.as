package com.cobalto.core.controller
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.observer.Notification;
	

	public class TransitionOutCompleteCommand extends MacroCommand
	{
		override protected function initializeMacroCommand():void
		{
			super.initializeMacroCommand();
			addSubCommand(RemovePageCommand);
			addSubCommand(NextFlowCommand);
		}
		
	}
}