package com.cobalto.extended.magnolia.view
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.components.pages.Page;
	import com.cobalto.core.view.AbstractPageMediator;
	import com.cobalto.core.view.ProgressMediator;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.extended.magnolia.pages.MagnoliaFooter;
	import com.cobalto.extended.magnolia.view.components.MagnoliaPage;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	

	
	public class MagnoliaPageMediator extends AbstractPageMediator implements IMediator
	{
		public static var NAME:String = "MagnoliaPageMediator";
		
		public function MagnoliaPageMediator(mediatorName:String=null,viewComponent:Object=null)
		{
			super(mediatorName,viewComponent);
			viewComponent.addEventListener(MagnoliaPage.FOOTER_UPDATE,onFooterUpdate,false,0,true);
			
			Page(viewComponent).addEventListener(Page.TRANSITION_IN_COMPLETE,onTransitionInComplete,false,0,true);
			Page(viewComponent).addEventListener(Page.TRANSITION_OUT_COMPLETE,onTransitionOutComplete,false,0,true);
			Page(viewComponent).addEventListener(Page.PAGE_ON_ADMIN_MODE,isOnAdminMode,false,0,true);
		}
		
		override public function populatePage(data:Object):void
		{
			//trace(data.indexes.toString() +" compare mediator"+ params.indexes.toString());
			if(data.indexes.toString() == params.indexes.toString())
			{
				MagnoliaPage(viewComponent).build(data.pageData);
			}
		}
		
		protected function onFooterUpdate(e:Event):void
		{
			//sendNotification(MagnoliaSiteFacade.FOOTER_UPDATE,MagnoliaPage(viewComponent).getFooterData());
		}
		
		protected function isOnAdminMode(event:Event):void
		{
			sendNotification(ApplicationFacade.PAGE_ON_EDIT_MODE);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			Page(viewComponent).removeEventListener(Page.TRANSITION_IN_COMPLETE,onTransitionInComplete);
			Page(viewComponent).removeEventListener(Page.TRANSITION_OUT_COMPLETE,onTransitionOutComplete);
			Page(viewComponent).removeEventListener(Page.TRANSITION_OUT_COMPLETE,isOnAdminMode);
		}
	}
}