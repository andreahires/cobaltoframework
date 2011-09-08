package com.cobalto.extended.magnolia.view
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.extended.magnolia.model.MagnoliaPageProxy;
	import com.cobalto.extended.magnolia.view.components.MagnoliaLogin;
	import com.cobalto.extended.magnolia.view.components.MagnoliaPage;
	import com.cobalto.core.model.FlowProxy;
	import com.cobalto.components.pages.Page;
	import com.cobalto.core.view.AbstractPageMediator;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MagnoliaLoginMediator extends Mediator implements IMediator
	{
		public static var NAME:String = "MagnoliaLoginMediator";
		
		public function MagnoliaLoginMediator(mediatorName:String=null,viewComponent:Object=null)
		{
			super(mediatorName,viewComponent);
			MagnoliaLogin(viewComponent).addEventListener(MagnoliaLogin.SEND_LOGIN_DATA,onSendData,false,0,true);
			MagnoliaLogin(viewComponent).addEventListener(MagnoliaLogin.CLOSE_CLICKED,onCloseClicked,false,0,true);
			MagnoliaLogin(viewComponent).addEventListener(MagnoliaLogin.MAGNOLIA_TRANSITION_IN,onHideMenu,false,0,true);
			MagnoliaLogin(viewComponent).addEventListener(MagnoliaLogin.MAGNOLIA_TRANSITION_OUT,onShowMenu,false,0,true);
			MagnoliaLogin(viewComponent).addEventListener(ApplicationFacade.MANAGE_FOOTER,onManageFooterHandler,false,0,true);
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.STAGE_RESIZE,MagnoliaSiteFacade.LOGIN_REQUEST,MagnoliaSiteFacade.HIDE_LOGIN_PANEL_IF_OPENED];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				
				case ApplicationFacade.STAGE_RESIZE:
					MagnoliaLogin(viewComponent).organizeItems();
					break;
				
				case ApplicationFacade.MAIN_ASSETS_AVAILABLE:
					MagnoliaLogin(viewComponent).build();
					break;
				
				case MagnoliaSiteFacade.LOGIN_REQUEST:
					MagnoliaSiteFacade.LOGIN_CALLBACK = notification.getBody() as Function;
					MagnoliaLogin(viewComponent).showLogin();
					
					break;
				
				case MagnoliaSiteFacade.HIDE_LOGIN_PANEL_IF_OPENED:
					MagnoliaLogin(viewComponent).hideLogin();
					break;
			}
		}
		
		protected function onSendData(e:Event):void
		{
			var loginData:Object = MagnoliaLogin(viewComponent).loginData;
			sendNotification(MagnoliaSiteFacade.LOGIN_DATA_SEND,loginData);
		}
		
		protected function onManageFooterHandler(event:Event):void
		{
			sendNotification(ApplicationFacade.MANAGE_FOOTER,(MagnoliaLogin(viewComponent).loginVisibleState));
		}
		
		protected function onHideMenu(e:Event):void
		{
		
		}
		
		protected function onShowMenu(e:Event):void
		{
		
		}
		
		protected function onCloseClicked(e:Event):void
		{
			sendNotification(ApplicationFacade.MENU_STATE_UPDATE,true);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			MagnoliaLogin(viewComponent).removeEventListener(MagnoliaLogin.SEND_LOGIN_DATA,onSendData);
			MagnoliaLogin(viewComponent).removeEventListener(MagnoliaLogin.CLOSE_CLICKED,onCloseClicked);
			MagnoliaLogin(viewComponent).removeEventListener(MagnoliaLogin.MAGNOLIA_TRANSITION_IN,onHideMenu);
			MagnoliaLogin(viewComponent).removeEventListener(MagnoliaLogin.MAGNOLIA_TRANSITION_OUT,onShowMenu);
			MagnoliaLogin(viewComponent).removeEventListener(ApplicationFacade.MANAGE_FOOTER,onManageFooterHandler);
		}
	
	}
}