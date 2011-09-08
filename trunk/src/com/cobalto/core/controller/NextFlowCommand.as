package com.cobalto.core.controller
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.core.model.FlowProxy;
	import com.cobalto.core.model.SiteTreeProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NextFlowCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var flowProxy:FlowProxy = FlowProxy(facade.retrieveProxy(FlowProxy.NAME));
			var indexArrayFlow:Array = notification.getBody().indexes as Array;
			var pageDepth:int = notification.getBody().pageDepth as int;
			
			var lastStep:String;
			
			if(notification.getName() == ApplicationFacade.PAGE_DATA_COMPLETE)
			{
				lastStep = ApplicationFacade.LOAD_PAGE_DATA;
				
			}
			else if(notification.getName() == ApplicationFacade.TRANSITION_OUT_COMPLETE)
			{
				
				lastStep = ApplicationFacade.TRANSITION_OUT;
					//*** after the transition out of the old page we need to refresh the indexArray getting the last one requested
				
			}
			else if(notification.getName() == ApplicationFacade.TRANSITION_IN_COMPLETE)
			{
				lastStep = ApplicationFacade.TRANSITION_IN;
				
			}
			
			var nextEvent:String = flowProxy.getNextStep(lastStep,indexArrayFlow,pageDepth);
			
			//*** update the indexArray and depth
			
			if(nextEvent != null)
			{
				//trace(nextEvent+" nextEvent");
				if(flowProxy.lastFlowType == FlowProxy.PRELOAD_FLOW && nextEvent == ApplicationFacade.TRANSITION_OUT)
				{
					indexArrayFlow = flowProxy.getFirstIndexArray();
				}
				else
				{
					indexArrayFlow = flowProxy.getLastIndexArrayAt(pageDepth);
				}
				
				pageDepth = SiteTreeProxy(facade.retrieveProxy(SiteTreeProxy.NAME)).getDepth(indexArrayFlow.concat());
				checkMenuState(nextEvent);
				
				sendNotification(nextEvent,{indexes:indexArrayFlow,pageDepth:pageDepth});
			}
		
		}
		
		protected function checkMenuState(newEvent:String):void
		{
			var val:Boolean = false;
			
			//if(newEvent == ApplicationFacade.LOAD_PAGE_DATA || newEvent == ApplicationFacade.STOP_FLOW)
			if(newEvent == ApplicationFacade.STOP_FLOW)
			{
				val = true;
			}
			sendNotification(ApplicationFacade.MENU_STATE_UPDATE,val);
		
		}
	
	}
}