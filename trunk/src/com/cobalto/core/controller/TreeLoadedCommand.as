package com.cobalto.core.controller
{
	import org.puremvc.as3.patterns.command.MacroCommand;

	public class TreeLoadedCommand extends MacroCommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(FlowStartupCommand);
			addSubCommand(MainAssetsCommand);
		}
		
	}
}