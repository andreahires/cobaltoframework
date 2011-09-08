package com.cobalto.core.controller
{
	import org.puremvc.as3.patterns.command.MacroCommand;

	public class StartupCommand extends MacroCommand
	{
		
		override protected function initializeMacroCommand():void
		{

			super.initializeMacroCommand();
			addSubCommand(ModelPrepCommand);
			addSubCommand(ViewPrepCommand);
			addSubCommand(SwfAddressCommand);
			
		}
		
	}
}