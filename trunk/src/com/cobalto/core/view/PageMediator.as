package com.cobalto.core.view
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.components.pages.Page;
	import com.cobalto.components.pages.PageHolder;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PageMediator extends Mediator implements IMediator
	{
		public static var NAME:String = "PageMediator";
		
		protected var page:Page;
		
		public function PageMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
			//pageHolder.addEventListener(Page.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
			//pageHolder.addEventListener(Page.TRANSITION_IN_COMPLETE, onTransitionInComplete);
		}
		
		// Return list of Nofitication names that Mediator is interested in
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.STAGE_RESIZE,
				//ApplicationFacade.TRANSITION_OUT,
				//ApplicationFacade.TRANSITION_IN
					];
		
		}
		
		// Handle all notifications this Mediator is interested in
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case ApplicationFacade.TRANSITION_OUT:
					//transitionOut(note as Array);
					break;
				
				case ApplicationFacade.TRANSITION_IN:
					// transitionIn();
					break;
			}
		}
		
		protected function onTransitionInComplete(e:Event=null):void
		{
			//sendNotification(ApplicationFacade.TRANSITION_IN_COMPLETE);
		}
		
		protected function onTransitionOutComplete(e:Event=null):void
		{
			//sendNotification(ApplicationFacade.TRANSITION_OUT_COMPLETE);
		}
		
		public function addNewPage(newPageInstance:DisplayObjectContainer,depth:uint):void
		{
			pageHolder.addNewPage(newPageInstance,depth);
		}
		
		public function removePageComponent(depth:int,pageInstance:Page):void
		{
			pageHolder.removePage(depth,pageInstance);
			pageInstance = null;
		}
		
		public function hasPage():Boolean
		{
			var val:Boolean = false;
			
			if(page != null)
				val = true;
			
			return val;
		}
		
		protected function get pageHolder():PageHolder
		{
			// ? andrea
			return viewComponent as PageHolder;
		}
	
	}
}