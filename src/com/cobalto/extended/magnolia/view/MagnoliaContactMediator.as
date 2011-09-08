package com.cobalto.extended.magnolia.view
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.components.pages.Page;
	import com.cobalto.core.view.AbstractPageMediator;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.extended.magnolia.pages.MagnoliaContact;
	import com.cobalto.extended.magnolia.pages.MagnoliaFooter;
	import com.cobalto.extended.magnolia.view.components.MagnoliaPage;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class MagnoliaContactMediator extends MagnoliaPageMediator implements IMediator
	{
		public static var NAME:String = "MagnoliaContactMediator";
		
		public function MagnoliaContactMediator(mediatorName:String=null,viewComponent:Object=null)
		{
			super(mediatorName,viewComponent);
			viewComponent.addEventListener(MagnoliaPage.FOOTER_UPDATE,onFooterUpdate,false,0,true);
			viewComponent.addEventListener(MagnoliaPage.NOTIFY_CONTACT_DATA_TO_SERVER_REQUEST,onServerDataRequest,false,0,true);
		}
		
		override public function populatePage(data:Object):void
		{
			//trace(data.indexes.toString() +" compare mediator"+ params.indexes.toString());
			if(data.indexes.toString() == params.indexes.toString())
			{
				MagnoliaPage(viewComponent).build(data.pageData);
			}
		
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.STAGE_RESIZE,ApplicationFacade.TRANSITION_OUT,ApplicationFacade.TRANSITION_IN,MagnoliaSiteFacade.CONTACT_DATA_RESPONSE];
		
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
				
				case MagnoliaSiteFacade.CONTACT_DATA_RESPONSE:
					//trace(notification.getBody().params + " trans in called in: " + this);
					MagnoliaContact(viewComponent).showServerResponse(notification.getBody() as Object);
					break;
			}
		}
		
		protected function onServerDataRequest(event:Event):void
		{
			sendNotification(MagnoliaSiteFacade.SEND_CONTACT_DATA_REQUEST,MagnoliaPage(viewComponent).getFormData())
		}
		
		override protected function onFooterUpdate(e:Event):void
		{
			//sendNotification(MagnoliaSiteFacade.FOOTER_UPDATE,MagnoliaPage(viewComponent).getFooterData());
		}
	}
}