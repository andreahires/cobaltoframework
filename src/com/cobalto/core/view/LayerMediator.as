package com.cobalto.core.view
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.extended.magnolia.view.MagnoliaLoginMediator;
	import com.cobalto.extended.magnolia.view.components.MagnoliaLogin;
	import com.cobalto.components.pages.Layer;
	import com.cobalto.components.pages.Page;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	
	public class LayerMediator extends Mediator implements IMediator
	{
		
		public function LayerMediator(viewComponent:Layer):void
		{
			super("LayerMediator",viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return[ApplicationFacade.MAIN_ASSETS_AVAILABLE];
		
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				
				case ApplicationFacade.MAIN_ASSETS_AVAILABLE:
					break;
			}
		}

		protected function get layer():Layer
		{
			return viewComponent as Layer;
		}
	
	}
}