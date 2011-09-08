package com.cobalto.core.view
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.extended.magnolia.view.MagnoliaPageMediator;
	import com.cobalto.components.pages.Footer;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class FooterMediator extends MagnoliaPageMediator implements IMediator
	{
		public static const NAME:String = 'FooterMediator';
		
		public function FooterMediator(viewComponent:Footer):void
		{
			super(NAME,viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.STAGE_RESIZE,ApplicationFacade.FOOTER_UPDATE,ApplicationFacade.MAIN_ASSETS_AVAILABLE];
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

			}
		}
		
		protected function get footer():Footer
		{
			return viewComponent as Footer;
		}
	}
}