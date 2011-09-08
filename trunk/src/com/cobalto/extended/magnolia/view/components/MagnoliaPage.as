// ActionScript file
package com.cobalto.extended.magnolia.view.components
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.api.IViewComponent;
	import com.cobalto.components.pages.Page;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.utils.UrlLoader;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	
	public class MagnoliaPage extends Page implements IViewComponent
	{
		public static const TRANSITION_IN_COMPLETE:String = "transitionInComplete";
		public static const TRANSITION_OUT_COMPLETE:String = "transitionOutComplete";
		
		protected static const INIT:String = "Init";
		protected static const POPULATE_DONE:String = "PopulateDone";
		protected static const TRANSITION_IN_DONE:String = "TransitionInDone";
		protected static const TRANSITION_OUT_DONE:String = "TransitionOutDone";
		public static const FOOTER_UPDATE:String = 'FooterUpdate'
		
		protected var _mode:String = "mode not set";
		protected var _permissions:String = "R";
		protected var _currentFooterLinks:Array = [];
		protected var _xml:XML;
		protected var _footerLinks:XMLList;
		protected var adminBar:MagnoliaBar;
		protected var isEditMode:Boolean = false;
		
		//* Server Data rewuest and data response;
		protected var serverLoaderDataFormat:String;
		protected var serverRequestMethod:String;
		public static const NOTIFY_REGISTER_DATA_TO_SERVER_REQUEST:String = 'NotifyRegisterDataToServerRequest';
		public static const NOTIFY_CONTACT_DATA_TO_SERVER_REQUEST:String = 'NotifyContactDataToServerRequest';
		
		// ** Constructor
		public function MagnoliaPage()
		{
			super();
		}
		
		override public function build(pageData:Object=null):void
		{
			super.build(pageData);
			
			// Added By Zulu August 25.2010
			
			if(pageData[0])
			{
				_xml = XML(pageData[0].toString()) as XML;
				/* trace("------------------------------PAGE XML-------------------------------");
				   trace(_xml);
				 trace("---------------------------------------------------------------------"); */
				
				initMode();
			}
			
			// Old ****   _xml.properties.footerlinks.link
			_footerLinks = XMLList(ApplicationFacade.commonLabelXML..footerlinks);
			
			updateFooter(footerLinksArray());
			organizeItems();
		}
		
		public function initMode():void
		{
			_mode = _xml.@mode;
			_permissions = _xml.@permissions;
			
			if(_mode == "edit" && _permissions == "W")
			{
				isEditMode = true;
				dispatchEvent(new Event(PAGE_ON_ADMIN_MODE,true));
				buildAdminTools();
			}
			else if(_mode == "preview" && _permissions == "W")
			{
				buildPreviewTools();
			}
		}
		
		protected function buildAdminTools():void
		{
			var buttonsXML:XMLList = _xml.buttons;
			adminBar = new MagnoliaBar(stage.stageWidth,buttonsXML);
			addChild(adminBar);
			
			organizeItems();
		}
		
		protected function buildPreviewTools():void
		{
			var buttonsXML:XMLList = _xml.buttons;
			adminBar = new MagnoliaBar(stage.stageWidth,buttonsXML,true);
			addChild(adminBar);
			
			organizeItems();
		}
		
		public function updateFooter(newArray:Array):void
		{
			if(newArray.length > 0)
			{
				if(hasChangeInFooterLink(newArray))
					NotifyToMagnoliaPageMediator();
			}
		
		}
		
		protected function footerLinksArray():Array
		{
			var footerLinksAsArray:Array = [];
			var length:uint = _footerLinks.link.length();
			var i:uint = 0;
			
			while(i < length)
			{
				footerLinksAsArray.push({target:_footerLinks.link[i].@target,href:_footerLinks.link[i].@href,label:_footerLinks.link[i].toString()});
				++i;
			}
			
			if(MagnoliaSiteFacade.LOGIN_STATUS === true)
			{
				//footerLinksAsArray.push({target:'_self',href:ApplicationFacade.baseURL+'/motoguzzi/IT/it/home?mgnlLogout=true',label:'logout'});
			}
			else
			{
				
			}
			
			return footerLinksAsArray;
		}
		
		// Edited & Added by Zulu
		private function hasChangeInFooterLink(newArray:Array):Boolean
		{
			var hasChanges:Boolean = false;
			
			var currFooterLength:int = _currentFooterLinks.length;
			var newFooterLength:int = newArray.length;
			var bigNum:int = currFooterLength;
			
			if(newFooterLength > bigNum)
				bigNum = newFooterLength;
			var iValue:int = 0;
			
			if(currFooterLength > 0)
			{
				while(iValue < bigNum)
				{
					if(_currentFooterLinks[iValue].label.toString().toUpperCase() !== newArray[iValue].label.toString().toUpperCase())
					{
						hasChanges = true;
						_currentFooterLinks = newArray;
						break;
					}
					
					++iValue;
				}
				
			}
			else
			{
				_currentFooterLinks = newArray;
				hasChanges = true;
			}
			
			return hasChanges;
		}
		
		protected function dispatchRegisterRequest():void
		{
			dispatchEvent(new Event(NOTIFY_REGISTER_DATA_TO_SERVER_REQUEST,true));
		}
		
		protected function dispatchContactRequest():void
		{
			dispatchEvent(new Event(NOTIFY_CONTACT_DATA_TO_SERVER_REQUEST,true));
		}
		
		public function getFormData():Object
		{
			return Object;
		}
		
		public function showServerResponse(serverResponse:Object):void
		{
		
		}
		
		private function NotifyToMagnoliaPageMediator():void
		{
			dispatchEvent(new Event(FOOTER_UPDATE,true));
		}
		
		public function getFooterData():Array
		{
			return _currentFooterLinks;
		}
		
		override public function organizeItems():void
		{
			if(adminBar && stage)
			{
				adminBar.setWidth(stage.stageWidth);
				this.swapChildrenAt(this.getChildIndex(adminBar),this.numChildren - 1);
			}
		}
	
	}
}