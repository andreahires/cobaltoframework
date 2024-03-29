package com.cobalto.core.controller
{

	import com.cobalto.core.model.SoundProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	

	public class StartUpSoundCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{

			var object:Object={};
			object.type="sound";
			object.url="assets/SoundLibrary.swf"
			var soundProxy:SoundProxy = new SoundProxy([object]);
			facade.registerProxy(soundProxy);

		}
		
	}
}