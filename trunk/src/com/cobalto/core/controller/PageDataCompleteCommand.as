package com.cobalto.core.controller
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class PageDataCompleteCommand extends MacroCommand
	{
		override protected function initializeMacroCommand():void
		{
			
			addSubCommand(PopulatePageCommand);
			addSubCommand(NextFlowCommand);
		}
	
	}
}