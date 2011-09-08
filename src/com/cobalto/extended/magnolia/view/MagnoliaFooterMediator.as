package com.cobalto.extended.magnolia.view
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.components.pages.Footer;
	import com.cobalto.core.view.FooterMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class MagnoliaFooterMediator extends FooterMediator
	{
		
		public static const NAME:String = 'MagnoliaFooterMediator';
		
		public function MagnoliaFooterMediator(viewComponent:Footer)
		{
			super(viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.STAGE_RESIZE,ApplicationFacade.FOOTER_UPDATE,ApplicationFacade.MAIN_ASSETS_AVAILABLE,
				MagnoliaSiteFacade.LOGIN_STATUS, ApplicationFacade.MANAGE_FOOTER,ApplicationFacade.PAGE_DATA_COMPLETE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.STAGE_RESIZE:
					Footer(viewComponent).organizeItems();
					break;
				
				case ApplicationFacade.FOOTER_UPDATE:
					Footer(viewComponent).updateFooter(notification.getBody() as Array)
					break;
				
				case ApplicationFacade.MAIN_ASSETS_AVAILABLE:
					Footer(viewComponent).build();
					break;
				
				case MagnoliaSiteFacade.LOGIN_STATUS :
					Footer(viewComponent).setLoginStatus(notification.getBody() as Boolean);
					break;
				
				case ApplicationFacade.MANAGE_FOOTER :
					
					var loginOpened : Boolean = notification.getBody() as Boolean;
					if(loginOpened)
					{
						trace(' login openend ',loginOpened)
					}
					(loginOpened) ? Footer(viewComponent).freezeFooter() : Footer(viewComponent).deFreezeFooter();
					break;
			}
		}
		
	}
}