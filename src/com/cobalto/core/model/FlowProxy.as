package com.cobalto.core.model
{
	import com.cobalto.ApplicationFacade;
	
	import flash.display.DisplayObjectContainer;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class FlowProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "FlowProxy";
		
		//*** flow types
		public static const PRELOAD_FLOW:String = "preloadFlow";
		public static const NORMAL_FLOW:String = "normalFlow";
		public static const REVERSE_FLOW:String = "reverseFlow";
		public static const CROSS_FLOW:String = "crossFlow";
		
		//*** application states
		public static const PRELOAD_COMPLETE:String = "PreloadComplete";
		public static const TRANSITION_OUT_COMPLETE:String = "TransitionOutComplete";
		public static const TRANSITION_IN_COMPLETE:String = "TrantisionInComplete";
		public static const CROSS_TRANSITION_COMPLETE:String = "Cross";
		
		protected var appState:String = "home";
		protected var lastStepEvent:String;
		protected var newPageProxy:AbstractAssetsProxy;
		protected var activePageId:int = 0;
		protected var activeFlowType:String;
		protected var flowArray:Array = new Array();
		protected var pagesArray:Array = new Array();
		protected var _isFlowing:Boolean = false;
		protected var historyArray:Array = [0];
		protected var newIndexArray:Array = [];
		protected var newPageDepth:int = 0;
		protected var siteTreeProxy:SiteTreeProxy;
		
		public function FlowProxy(siteTreeArray:Array)
		{
			super(NAME,siteTreeArray);
			siteTreeProxy = facade.retrieveProxy(SiteTreeProxy.NAME) as SiteTreeProxy;
		}
		
		override public function onRegister():void
		{
			buildFlowArray();
		}
		
		protected function buildFlowArray():void
		{
			flowArray[PRELOAD_FLOW] = [ApplicationFacade.LOAD_PAGE_DATA,ApplicationFacade.TRANSITION_OUT,ApplicationFacade.TRANSITION_IN];
			flowArray[REVERSE_FLOW] = [ApplicationFacade.LOAD_PAGE_DATA,ApplicationFacade.TRANSITION_IN,ApplicationFacade.TRANSITION_OUT];
			flowArray[NORMAL_FLOW] = [ApplicationFacade.TRANSITION_OUT,ApplicationFacade.LOAD_PAGE_DATA,ApplicationFacade.TRANSITION_IN];
		}
		
		public function startNewFlow(indexArray:Array,pageDepth:int):void
		{
			
			//*** if the depth is zero it means it's a nested page and it take the length as depth reference
			if(pageDepth == 0)
				pageDepth = indexArray.length;
			
			//*** if the history length is zero it means it's the first page requested since the app startUp
			if(pagesArray.length == 0)
			{
				
				initPage(indexArray.concat(),pageDepth);
				
					//*** if the history length is superior than zero it means it's not the first page requested 
			}
			else
			{
				
				//*** if the requested page is different than the last created
				if(indexArray.toString() != getLastIndexArray().toString())
				{
					//trace(pageDepth+"requested depth - pages length "+ pagesArray.length);
					//*** if the requested page level is at the same level of the last created
					
					if(pageDepth == pagesArray.length)
					{
						initPage(indexArray.concat(),pageDepth);
						
							//*** if the depth of the requested page is mayor than the current one
					}
					else if(pageDepth > pagesArray.length)
					{
						
						//*** it pass here just for nested pages
						//*** create all the parent pages of the requested page and the page itself
						for(var i:int = 1;i <= pageDepth;i++)
						{
							
							var pageIndexArray:Array = indexArray.slice(0,i);
							
							//trace("checking if parents already exist at level: "+i+" - for page requested: "+indexArray);
							
							//*** check if already exist some parents of the requested page
							
							if(getLastIndexArrayAt(i))
							{
								if(getLastIndexArrayAt(i).toString() != pageIndexArray.toString())
								{
									//*** create page
									initPage(pageIndexArray,i);
								}
							}
							else
							{
								initPage(pageIndexArray,i);
							}
							
						}
						
					}
					else if(pageDepth < pagesArray.length)
					{
						
						//*** it pass here just for nested pages
						//*** create the requested page and its parents if they don't exist already
						for(var j:int = 1;j <= pagesArray.length;j++)
						{
							// *** check for the depth in common with the requested page
							if(j <= pageDepth)
							{
								var pageIndexArray2:Array = indexArray.slice(0,j);
								
								if(getLastIndexArrayAt(j).toString() != indexArray.toString())
								{
									initPage(indexArray,j);
								}
								
							}
							else if(pageDepth == j)
							{
								if(getLastIndexArrayAt(j).toString() != indexArray.toString())
								{
									initPage(indexArray,pageDepth);
								}
							}
							else
							{
								//*** transition out the extra levels
								var lastIndexesAtDepth:Array = getLastIndexArrayAt(j);
								
								sendNotification(ApplicationFacade.TRANSITION_OUT,{indexes:lastIndexesAtDepth,pageDepth:j});
							}
							
						}
						
					}
					
				}
				
			}
		
		}
		
		protected function initPage(indexArray:Array,pageDepth:int):void
		{
			
			//*** code to manage the breaking of the flow if the user interrupt the loading of the requested page
			/* if(_isFlowing)
			   {
			   if(getPageNum(historyArray.length) > 0)
			   {
			   sendNotification(ApplicationFacade.BREAK_LAST_FLOW, getPageNum(historyArray.length));
			   }else{
			   sendNotification(ApplicationFacade.BREAK_LAST_FLOW, 0);
			   }
			 } */
			
			_isFlowing = true;
			
			//** set the new page id
			//activePageId = newPageId;
			
			//** set the new flow type for the brand new page ---- to do
			activeFlowType = siteTreeProxy.getFlowType(indexArray.concat());
			
			//** send the notification to create the new page
			//trace("intiPage depth"+pageDepth);
			facade.sendNotification(ApplicationFacade.INIT_PAGE,{indexes:indexArray.concat(),pageDepth:pageDepth});
		
		}
		
		public function handleNewFlow(flowIndexArray:Array,pageDepth:int):String
		{
			
			var newEvent:String;
			var noteObject:Object;
			
			var newFlowIndexArray:Array = flowIndexArray.concat();
			
			if(activeFlowType == NORMAL_FLOW)
			{
				newEvent = ApplicationFacade.TRANSITION_OUT;
				
				//*** check if exist other pages in the requested level 
				var currentLevelPageArray:Array = pagesArray[pageDepth - 1];
				
				if(currentLevelPageArray.length > 1)
				{
					// ** if exist other pages
					// ** find the indexArray of the last page
					
					noteObject = {indexes:pagesArray[pageDepth - 1][0].indexArray,pageDepth:pageDepth};
					
				}
				else
				{
					
					//** if the page is the first one for this depth skip the transition out and load directly the data
					noteObject = {indexes:newFlowIndexArray,pageDepth:pageDepth};
					newEvent = ApplicationFacade.LOAD_PAGE_DATA;
					
				}
				
			}
			else
			{
				noteObject = {indexes:newFlowIndexArray,pageDepth:pageDepth};
				newEvent = ApplicationFacade.LOAD_PAGE_DATA;
				
			}
			
			lastStepEvent = newEvent;
			
			sendNotification(newEvent,noteObject);
			
			return lastStepEvent;
		
		}
		
		public function getNextStep(lastStep:String,indexArrayFlow:Array,pageDepth:int):String
		{
			var nextEvent:String;
			
			if(lastStep == ApplicationFacade.TRANSITION_OUT)
			{
				var currentLevelPageArray:Array = pagesArray[pageDepth - 1];
				
				//trace(currentLevelPageArray[0].indexArray+" catching getstep after transition out: "+pageDepth);
				
				if(!currentLevelPageArray)
				{
					
					return null;
				}
				
			}
			
			for(var i:int = 0;i < flowArray[activeFlowType].length;i++)
			{
				//trace("compare last event "+flowArray[activeFlowType][i]+" == "+lastStepEvent);
				if(flowArray[activeFlowType][i] == lastStep)
				{
					nextEvent = flowArray[activeFlowType][i + 1];
					break;
				}
			}
			
			if(nextEvent == ApplicationFacade.TRANSITION_OUT && pagesArray[0].length == 1)
			{
				nextEvent = getNextStep(nextEvent,indexArrayFlow,pageDepth);
			}
			
			if(nextEvent == null)
			{
				/// *** if the completed page is the last requested stop the flow
				nextEvent = ApplicationFacade.STOP_FLOW;
				_isFlowing = false;
			}
			
			lastStepEvent = nextEvent;
			
			return nextEvent;
		
		}
		
		public function checkHistory(flowIndexArray:Array):Array
		{
			if(flowIndexArray.length > newIndexArray.length)
			{
				historyArray.pop();
				return newIndexArray;
			}
			else
			{
				return getLastIndexArrayAt(flowIndexArray.length);
			}
		}
		
		public function manageNestedTransitions(lastPageIndexes:Array,pageDepth:int):void
		{
			
			historyArray.pop();
			startNewFlow(newIndexArray.concat(),newPageDepth);
		}
		
		public function getLastIndexArrayAt(depth:int):Array
		{
			var lastIndexArray:Array;
			
			if(pagesArray[depth - 1])
			{
				if(pagesArray[depth - 1].length > 0)
				{
					lastIndexArray = pagesArray[depth - 1][pagesArray[depth - 1].length - 1].indexArray;
				}
			}
			return lastIndexArray;
		}
		
		public function getLastIndexArray():Array
		{
			var lastIndexArray:Array;
			
			for(var i:int = pagesArray.length - 1;i >= 0;i--)
			{
				if(pagesArray[i])
				{
					//trace(pagesArray[i].length+" check depth length: "+i);
					if(pagesArray[i].length > 0)
					{
						lastIndexArray = pagesArray[i][pagesArray[i].length - 1].indexArray;
						break;
					}
				}
			}
			
			return lastIndexArray;
		}
		
		public function getFirstIndexArray():Array
		{
			var firstIndexArray:Array = pagesArray[0][0].indexArray;
			return firstIndexArray;
		}
		
		public function addNewPage(indexArray:Array,pageDepth:int,pageViewComponent:DisplayObjectContainer,pageMediator:IMediator,pageProxy:IProxy,refClass:String):void
		{
			//trace("addPage:"+indexArray+" with depth: "+pageDepth);
			if(!pagesArray[pageDepth - 1])
				pagesArray[pageDepth - 1] = new Array();
			
			pagesArray[pageDepth - 1].push({indexArray:indexArray.concat(),pageDepth:pageDepth,viewComponent:pageViewComponent,mediator:pageMediator,proxy:pageProxy,refClass:refClass});
		
		}
		
		public function removePage(depth:int,id:int):void
		{
			
			pagesArray[depth - 1].splice(id,1);
			
			//*** clear level
			if(pagesArray[depth - 1].length == 0)
			{
				pagesArray.pop();
			}
		
		}
		
		public function getPageViewComponent(depth:int,id:int):DisplayObjectContainer
		{
			return pagesArray[depth - 1][id].viewComponent;
		}
		
		public function getPageProxy(depth:int,id:int):IProxy
		{
			return pagesArray[depth - 1][id].proxy;
		}
		
		public function getPageMediatorAt(depth:uint):IMediator
		{
			return pagesArray[depth - 1][pagesArray[depth - 1].length - 1].mediator;
		}
		
		public function getPageProxyAt(depth:uint):IProxy
		{
			var pageArrayLevel:Array = pagesArray[depth - 1];
			//trace(pagesArray.length+" getLastProxy length");
			return pageArrayLevel[pageArrayLevel.length - 1].proxy;
		}
		
		public function getDepth():uint
		{
			return historyArray.length;
		}
		
		public function getPageMediator(depth:int,id:int):IMediator
		{
			return pagesArray[depth - 1][id].mediator;
		}
		
		public function getPageNum(depth:int):int
		{
			var pageNum:uint;
			
			if(pagesArray[depth - 1])
			{
				pageNum = pagesArray[depth - 1].length;
			}
			else
			{
				pageNum = 0;
			}
			return pageNum;
		}
		
		public function get siteTree():Array
		{
			return data as Array;
		}
		
		public function get activePage():int
		{
			return activePageId;
		}
		
		public function getFlowId():int
		{
			return activePageId;
		}
		
		public function get isFlowing():Boolean
		{
			return _isFlowing;
		}
		
		public function get lastFlowType():String
		{
			return activeFlowType;
		}
	
	}
}