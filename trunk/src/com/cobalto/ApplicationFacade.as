package com.cobalto
{
	import com.cobalto.components.menu.ApplicationMenu;
	import com.cobalto.components.menu.MainMenu;
	import com.cobalto.components.menu.RootMainMultiLevel;
	import com.cobalto.components.pages.Footer;
	import com.cobalto.components.pages.Layer;
	import com.cobalto.components.progress.ProgressViewComponent;
	import com.cobalto.core.controller.AddressChangeCommand;
	import com.cobalto.core.controller.InitPageCommand;
	import com.cobalto.core.controller.NextFlowCommand;
	import com.cobalto.core.controller.PageDataCommand;
	import com.cobalto.core.controller.PageDataCompleteCommand;
	import com.cobalto.core.controller.RemovePageCommand;
	import com.cobalto.core.controller.SiteTreeCommand;
	import com.cobalto.core.controller.StartPageCommand;
	import com.cobalto.core.controller.StartupCommand;
	import com.cobalto.core.controller.StopFlowCommand;
	import com.cobalto.core.controller.TitleChangeCommand;
	import com.cobalto.core.controller.TransitionOutCompleteCommand;
	import com.cobalto.core.controller.TreeLoadedCommand;
	import com.cobalto.core.controller.TryMacroCommand;
	import com.cobalto.core.controller.sendTargetUrlCommand;
	import com.cobalto.core.model.AbstractPageAssetsProxy;
	import com.cobalto.core.view.AbstractPageMediator;
	import com.cobalto.core.view.FooterMediator;
	import com.cobalto.core.view.LayerMediator;
	import com.cobalto.core.view.MainMenuMediator;
	import com.cobalto.core.view.ProgressMediator;
	import com.cobalto.core.view.StageMediator;
	
	import flash.display.Stage;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade implements IFacade
	{
		
		public static var stageRef:Stage;
		
		public static var currentMenuTitle:String;
		public static var commonLabelXML:XML;
		
		public static var compareURLToLoadLocalAssets:String = "http://piaggio-author.openmindonline.it";
		public static var debugWithLocalAssets:Boolean = false;
		public static var nonLatinLanguage:Boolean = false;
		
		public static const PAGE_ON_EDIT_MODE:String = 'PageOnEditMode';
		public static const STARTUP:String = "Startup";
		public static const STARTUPSOUND:String = "StartupSound";
		public static const STAGE_RESIZE:String = "StageResize";
		public static const LANGUAGES_AVAILABLE:String = "LanguagesAvailable";
		public static const SITE_TREE_AVAILABLE:String = "SiteTreeAvailable";
		public static const MAIN_ASSETS_PROGRESS:String = "MainAssetsProgress";
		public static const MAIN_ASSETS_AVAILABLE:String = "MainAssetsAvailable";
		public static const MAIN_SOUNDS_AVAILABLE:String = "MainSoundsAvailable";
		
		//*** flow events
		public static const PAGE_CHANGE:String = "PageChange";
		public static const INIT_PAGE:String = "InitPage";
		public static const LOAD_PAGE_DATA:String = "LoadPageData";
		public static const TRANSITION_OUT:String = "TransitionOut";
		public static const TRANSITION_IN:String = "TransitionIn";
		public static const TRANSITION_IN_COMPLETE:String = "TransitionInComplete";
		public static const TRANSITION_OUT_COMPLETE:String = "TransitionOutComplete";
		public static const PAGE_DATA_COMPLETE:String = "PageDataComplete";
		public static const STOP_FLOW:String = "StopFlow";
		public static const PAGE_REMOVED:String = "PageRemoved";
		public static const BREAK_LAST_FLOW:String = "PageRemoved";
		public static const MENU_STATE_UPDATE:String = "MenuStateUpdate";
		
		//*** progress bar
		public static const GENERAL_PROGRESS_START:String = "GeneralProgressStart";
		public static const GENERAL_PROGRESS:String = "GeneralProgress";
		public static const GENERAL_COMPLETE:String = "GeneralComplete";
		
		//**** Footer freeze Handler
		public static var MANAGE_FOOTER:String = 'ManageFooter';
		public static const FOOTER_UPDATE:String = 'FooterUpdate';
		
		//*** swfAddress
		public static const ADDRESS_CHANGE:String = "address_change";
		public static const TITLE_CHANGE:String = "title_change";
		public static const SEND_TARGET_URL:String = "SendTargetUrl";
		
		// Font** Setting Default Fonts : "standard 07_57","Klavika Medium"
		public static var FONT_LIST:Array = ["KlavikaMedium"];
		
		public static var ERROR_PAGE_ADDRESS:String = "";
		public static const MENU_HIDDEN_LABEL:String = "hidden";
		
		public static var baseURL:String;
		public static var staticLanguage:String;
		public static var basePackage:String = "motoguzzi";
		public static var soundLoaded:Boolean = undefined;
		public static var lastPageCreatedRefClass:String;
		public static var lastTitle:String;
		
		public static var _defaultMediatorClass:Class = AbstractPageMediator;
		public static var _defaultProxyClass:Class = AbstractPageAssetsProxy;
		
		// *** stage
		public static var _stageMediatorClass:Class = StageMediator;
		
		//*** MainHolder StartLibrary
		public static var _mainHolderClass:Class = MainHolder;
		
		// *** Menu
		public static var _mainMenuClass:Class = MainMenu;
		public static var _menuMediatorClass:Class = MainMenuMediator;
		public static var _ApplicationMenuMainComponentClass:Class = ApplicationMenu;
		public static var _rootMainMenuClass:Class = RootMainMultiLevel;
		public static var _subLevelMenuClass:Class = RootMainMultiLevel;
		
		//*** Progress
		public static var _progressComponentClass:Class = ProgressViewComponent;
		public static var _progressMediatorClass:Class = ProgressMediator;
		
		//*** Layer 
		public static var _LayerComponentClass:Class = Layer;
		public static var _layerMediatorClass:Class = LayerMediator;
		
		//*** Footer
		public static var _footerClass:Class = Footer;
		public static var _footerMediatorClass:Class = FooterMediator;
		
		//** fontsArray
		override protected function initializeController():void
		{
			printAscii();
			/*trace("ApplicationFacade Being Called: ");
			trace("================================");*/
			
			super.initializeController();
			registerCommand(STARTUP,StartupCommand);
			registerCommand(LANGUAGES_AVAILABLE,SiteTreeCommand);
			registerCommand(SITE_TREE_AVAILABLE,TreeLoadedCommand);
			//registerCommand(MAIN_ASSETS_AVAILABLE,StartHomeCommand);
			registerCommand(MAIN_ASSETS_AVAILABLE,TryMacroCommand);
			registerCommand(PAGE_CHANGE,StartPageCommand);
			registerCommand(INIT_PAGE,InitPageCommand);
			registerCommand(LOAD_PAGE_DATA,PageDataCommand);
			registerCommand(PAGE_DATA_COMPLETE,PageDataCompleteCommand);
			registerCommand(TRANSITION_OUT_COMPLETE,TransitionOutCompleteCommand);
			registerCommand(TRANSITION_IN_COMPLETE,NextFlowCommand);
			registerCommand(PAGE_REMOVED,RemovePageCommand);
			registerCommand(STOP_FLOW,StopFlowCommand);
			registerCommand(BREAK_LAST_FLOW,RemovePageCommand);
			registerCommand(ADDRESS_CHANGE,AddressChangeCommand);
			registerCommand(TITLE_CHANGE,TitleChangeCommand);
			registerCommand(SEND_TARGET_URL,sendTargetUrlCommand);
		
		}
		
		protected function declareDynamicClasses():void
		{
		
		/*
		   // declaration Dynamic Classes on the subclass
		   Home;
		   HomeMediator;
		   HomeProxy;
		 */
		}
		
		public function sendInternalURL(url:String):void
		{
			sendNotification(ADDRESS_CHANGE,url);
		}
		
		public function startup(app:Stage,flashVars:Object):void
		{
			stageRef = app;
			baseURL = flashVars['contextUrl'];
			var appURL:String = String(flashVars['contextUrl'] + flashVars['languagesUrl']);
			staticLanguage = flashVars['currentLanguage'];
			sendNotification(STARTUP,{app:app,url:appURL,lang:flashVars['currentLanguage']});
			
			if(ApplicationFacade.baseURL == ApplicationFacade.compareURLToLoadLocalAssets)
			{
				ApplicationFacade.debugWithLocalAssets = true;
			}
		
		}
		
		public static function getInstance():ApplicationFacade
		{
			if(instance == null)
				instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		public static function get mainMenuClass():Class
		{
			return _mainMenuClass;
		}
		
		public static function get progressComponentClass():Class
		{
			return _progressComponentClass;
		}
		
		public static function get layerComponentClass():Class
		{
			return _LayerComponentClass;
		}
		
		public static function get applicationMenuMainComponentClass():Class
		{
			return _ApplicationMenuMainComponentClass;
		}
		
		public static function get footerComponentClass():Class
		{
			return _footerClass;
		}
		
		private function printAscii():void
		{
			var seedNum:uint = 0;
			trace("---------------------------------------------------------");
			trace("");
			
			switch(seedNum)
			{
				case 0:
					trace("                  \`.  |\								");
					trace("              \`-. \ `.| \!,,							");
					trace("             \ \  `.\  _   (__							");
					trace("         _ `-.> \ ___   \    __							");
					trace("          `-/,o-./O  `.      ._`							");
					trace("          -//   j_    |   `` _<`							");
					trace("           |\__(  \--'      '  \     .					");	
					trace("           >   _    `--'      _/     ;					");
					trace("           |  / `----..   . /       (					");
					trace("           | (         `.  Y         )					");
					trace("            \ \     ,-.-.| |_       (_					");
					trace("             `.`.___\  \ \/=.`.     __)					");
					trace("               `--,==\    )==\,\   (_					");
					trace("                ,'\===`--'====\,\    `-.					");
					trace("              ,'.` ============\,\  (`-'					");
					trace("             /`=.`Y=============\,\ .'					");
					trace("            /`-. `|==============\_,-._					");
					trace("           /`-._`=|=___=========,'^, c-)					");
					trace("           \`-----+' ._)=====_(_`-' ^-'`-.				");
					trace("       -----`=====, \  `.-==(^_ ^c_,.^ `^_\-----			");
					trace("                 (__/`--'('(_,-._)-._,-.,__)`)  hjw		");
					trace("                          `-._`._______.'_.-'			");
					trace("                              `---------'				");
					
				break;	
				
			}
			trace("");
			trace("		WELCOME TO COBALTO FRAMEWORK");
			trace("");
			trace("---------------------------------------------------------");
		}
	
	}
}