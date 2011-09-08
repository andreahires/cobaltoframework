package com.cobalto.extended.magnolia.view.components
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.components.pages.Layer;
	import com.cobalto.components.pages.Page;
	import com.cobalto.core.view.LayerMediator;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class MagnoliaLayerMediator extends LayerMediator
	{
		public static var NAME:String = "MagnoliaLayerMediator";
		
		public function MagnoliaLayerMediator(viewComponent:Layer)
		{
			super(viewComponent as Layer);
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.MAIN_ASSETS_AVAILABLE,
				ApplicationFacade.PAGE_ON_EDIT_MODE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.MAIN_ASSETS_AVAILABLE:
					initLogin();
					break;
			
				case ApplicationFacade.PAGE_ON_EDIT_MODE:
					MagnoliaLayer(viewComponent).onPageEditMode();
					break;
				
			}
		}
		
		protected function initLogin():void
		{
			var loginComponentClass:Class = MagnoliaSiteFacade._loginComponentClass;
			var loginComponent:MagnoliaLogin = new loginComponentClass();
			Page(viewComponent).addChild(loginComponent);
			loginComponent.build();
			
			var loginMediatorClass:Class = MagnoliaSiteFacade._loginMediatorClass;
			var loginMediator:IMediator = new loginMediatorClass("LoginMediator",loginComponent) as IMediator;
			facade.registerMediator(loginMediator);
		}
		
	}
}