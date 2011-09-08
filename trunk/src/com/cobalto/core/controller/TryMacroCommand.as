package com.cobalto.core.controller
{
	import org.puremvc.as3.patterns.command.MacroCommand;

	public class TryMacroCommand extends MacroCommand
	{
		
		override protected function initializeMacroCommand():void
		{

			super.initializeMacroCommand();
			addSubCommand(StartHomeCommand);
			//addSubCommand(StartUpSoundCommand);			
		}
		
	}
}