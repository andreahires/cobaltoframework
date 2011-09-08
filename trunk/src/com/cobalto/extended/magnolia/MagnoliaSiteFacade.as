package com.cobalto.extended.magnolia
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.extended.magnolia.controller.ContactDataSendCommand;
	import com.cobalto.extended.magnolia.controller.LoginDataSendCommand;
	import com.cobalto.extended.magnolia.controller.RegisterDataSendCommand;
	import com.cobalto.extended.magnolia.model.MagnoliaContactProxy;
	import com.cobalto.extended.magnolia.model.MagnoliaPageProxy;
	import com.cobalto.extended.magnolia.model.MagnoliaRegisterProxy;
	import com.cobalto.extended.magnolia.pages.MagnoliaContact;
	import com.cobalto.extended.magnolia.pages.MagnoliaRegister;
	import com.cobalto.extended.magnolia.view.MagnoliaContactMediator;
	import com.cobalto.extended.magnolia.view.MagnoliaFooterMediator;
	import com.cobalto.extended.magnolia.view.MagnoliaLoginMediator;
	import com.cobalto.extended.magnolia.view.MagnoliaPageMediator;
	import com.cobalto.extended.magnolia.view.MagnoliaRegisterMediator;
	import com.cobalto.extended.magnolia.view.components.MagnoliaLayer;
	import com.cobalto.extended.magnolia.view.components.MagnoliaLayerMediator;
	import com.cobalto.extended.magnolia.view.components.MagnoliaLogin;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class MagnoliaSiteFacade extends ApplicationFacade implements IFacade
	{
		
		public static var _loginMediatorClass:Class = MagnoliaLoginMediator;
		public static var _loginComponentClass:Class = MagnoliaLogin;
		
		public static var _registerMediatorClass:Class = MagnoliaRegisterMediator;
		public static var _registerComponentClass:Class = MagnoliaRegister;
		public static var _registerProxyClass:Class = MagnoliaRegisterProxy;
		
		public static var _contactMediatorClass:Class = MagnoliaContactMediator;
		public static var _contactComponentClass:Class = MagnoliaContact;
		public static var _contactProxyClass:Class = MagnoliaContactProxy;
		
		public static const REGISTER_DATA_RESPONSE:String = 'RegisterDataResponse';
		public static const CONTACT_DATA_RESPONSE:String = 'ContactDataResponse';
		
		public static const LOGIN_REQUEST:String = 'LoginRequest';
		public static const LOGIN_DATA_SEND:String = 'LoginDataSend';
		
		public static const SEND_REGISTER_DATA_REQUEST:String = 'SendRegisterdataRequest';
		public static const SEND_CONTACT_DATA_REQUEST:String = 'SendContactdataRequest';
		public static var HIDE_LOGIN_PANEL_IF_OPENED:String = 'HideLoginPanelIfOpened';
		
		//**** Handling Login status 
		public static var LOGIN_STATUS:String = 'LoginStatus';
		
		public static var LOGIN_CALLBACK:Function;
		public static var USER:String = "none";
		public static var PWD:String = "none";
		public static var APPENDLOGIN:String = " ";
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			//trace("MagnoliaSiteFacade Being Called: ");
			//trace("================================");
			
			_layerMediatorClass = MagnoliaLayerMediator;
			_LayerComponentClass = MagnoliaLayer;
			_footerMediatorClass = MagnoliaFooterMediator;
			_defaultMediatorClass = MagnoliaPageMediator;
			_defaultProxyClass = MagnoliaPageProxy;
			
			registerCommand(LOGIN_DATA_SEND,LoginDataSendCommand);
			registerCommand(SEND_REGISTER_DATA_REQUEST,RegisterDataSendCommand);
			registerCommand(SEND_CONTACT_DATA_REQUEST,ContactDataSendCommand);
		
		}
		
		override protected function declareDynamicClasses():void
		{
		
		}
		
		public static function getInstance():MagnoliaSiteFacade
		{
			if(instance == null)
				instance = new MagnoliaSiteFacade();
			return instance as MagnoliaSiteFacade;
		}
	
	}
}