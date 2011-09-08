package com.cobalto.core.view
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.components.pages.Page;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AbstractPageMediator extends Mediator implements IMediator
	{
		public static var NAME:String = "AbstractPageMediator";
		protected var _params:Object = {};
		
		public function AbstractPageMediator(mediatorName:String=null,viewComponent:Object=null)
		{
			super(mediatorName,viewComponent);
			
			Page(viewComponent).addEventListener(Page.TRANSITION_IN_COMPLETE,onTransitionInComplete);
			Page(viewComponent).addEventListener(Page.TRANSITION_OUT_COMPLETE,onTransitionOutComplete);
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.STAGE_RESIZE,ApplicationFacade.TRANSITION_OUT,ApplicationFacade.TRANSITION_IN];
		
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				
				case ApplicationFacade.STAGE_RESIZE:
					Page(viewComponent).organizeItems();
					break;
				
				case ApplicationFacade.PAGE_DATA_COMPLETE:
					populatePage(notification.getBody() as Object);
					break;
				
				case ApplicationFacade.TRANSITION_OUT:
					var indexArray:Array = notification.getBody().indexes as Array;
					transitionOut(indexArray);
					break;
				
				case ApplicationFacade.TRANSITION_IN:
					
					//trace(notification.getBody().params + " trans in called in: " + this);
					var indexArray2:Array = notification.getBody().indexes as Array;
					transitionIn(indexArray2);
					break;
			}
		}
		
		public function populatePage(data:Object):void
		{
			//trace(data.indexes.toString() +" compare mediator"+ params.indexes.toString());
			if(data.indexes.toString() == params.indexes.toString())
			{
				Page(viewComponent).build(data.pageData);
			}
		}
		
		protected function transitionIn(indexArray:Array):void
		{
			//trace(indexArray.toString() + " compare params  " + params.indexes.toString() + " this: " + this);
			
			if(indexArray.toString() == _params.indexes.toString())
			{
				Page(viewComponent).transitionIn();
			}
		}
		
		protected function transitionOut(indexArray:Array):void
		{
			//trace(indexArray.toString() +" compare "+ params.indexes.toString());
			if(indexArray.toString() == params.indexes.toString())
			{
				//trace("trans out called:"+Page(viewComponent));
				Page(viewComponent).transitionOut();
			}
		}
		
		protected function onTransitionInComplete(e:Event=null):void
		{
			sendNotification(ApplicationFacade.TRANSITION_IN_COMPLETE,{indexes:params.indexes.concat(),pageDepth:params.pageDepth});
		}
		
		protected function onTransitionOutComplete(e:Event=null):void
		{
			//Page(viewComponent).removeEventListener(Page.TRANSITION_IN_COMPLETE, onTransitionInComplete);
			//Page(viewComponent).removeEventListener(Page.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
			//trace("transition out complete note: "+params.indexes);
			sendNotification(ApplicationFacade.TRANSITION_OUT_COMPLETE,{indexes:params.indexes.concat(),pageDepth:params.pageDepth});
		}
		
		public function destroy():void
		{
			Page(viewComponent).removeEventListener(Page.TRANSITION_IN_COMPLETE,onTransitionInComplete);
			Page(viewComponent).removeEventListener(Page.TRANSITION_OUT_COMPLETE,onTransitionOutComplete);
			//_params = null;
		}
		
		public function set params(par:Object):void
		{
			_params = par;
		}
		
		public function get params():Object
		{
			return _params;
		}
	
	}
}