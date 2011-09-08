package com.cobalto.core.view
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.api.IProgressComponent;
	import com.cobalto.components.pages.Page;
	import com.cobalto.components.progress.ProgressViewComponent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ProgressMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ProgressMediator";
		
		public function ProgressMediator(progressComponent:IProgressComponent):void
		{
			super(NAME,progressComponent);
			Page(progressComponent).build();
		}
		
		// Return list of Nofitication names that Mediator is interested in
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.STAGE_RESIZE,ApplicationFacade.MAIN_ASSETS_PROGRESS,ApplicationFacade.MAIN_ASSETS_AVAILABLE,ApplicationFacade.GENERAL_PROGRESS_START,ApplicationFacade.GENERAL_PROGRESS,ApplicationFacade.GENERAL_COMPLETE];
		
		}
		
		// Handle all notifications this Mediator is interested in
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case ApplicationFacade.STAGE_RESIZE:
					Page(progressComponent).organizeItems();
					break;
				
				case ApplicationFacade.MAIN_ASSETS_PROGRESS:
					progressComponent.update(note.getBody() as Number);
					break;
				
				case ApplicationFacade.MAIN_ASSETS_AVAILABLE:
					progressComponent.reset();
					break;
				
				case ApplicationFacade.GENERAL_PROGRESS_START:
					ProgressViewComponent(progressComponent).start();
					break;
				
				case ApplicationFacade.GENERAL_PROGRESS:
					//createSubMediators();
					progressComponent.update(note.getBody() as Number);
					break;
				
				case ApplicationFacade.GENERAL_COMPLETE:
					//createSubMediators();
					progressComponent.reset();
					break;
			}
		
		}
		
		public function reset():void
		{
			progressComponent.reset();
		}
		
		protected function get progressComponent():IProgressComponent
		{
			return viewComponent as IProgressComponent;
		}
	
	}
}