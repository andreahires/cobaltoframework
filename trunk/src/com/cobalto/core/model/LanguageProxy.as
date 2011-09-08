package com.cobalto.core.model
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.loading.XmlLoader;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class LanguageProxy extends Proxy implements IProxy
	{
		// Cannonical name of the Proxy
        public static const NAME:String = 'LanguageProxy';
        
		protected var languages_array:Array = new Array();
		protected var activeLanguage:String =null;
		
		public function LanguageProxy(dataRef:Object):void
		{
			super(NAME, dataRef);
			
		}
		
		override public function onRegister():void
		{
			loadLanguages();
		}
		
		protected function loadLanguages():void
		{
			
			var xmlLoader:XmlLoader = new XmlLoader(dataSource);
			xmlLoader.addEventListener(XmlLoader.XML_AVAILABLE, onLanguagesLoaded);
			//onLanguagesLoaded();
		}

		protected function onLanguagesLoaded(e:Event = null):void
		{
		
			var languageData:XMLList = new XML(e.target.textData).language;
			var activeLangId:int= -1;
			
			for(var i:int=0; i < languageData.length(); i++)
			{
				if(dataLanguage == languageData[i].@code)
				{
					activeLangId = i;
				}

				var assetList:XMLList = languageData[i].assets.asset;
				var assetArray:Array = new Array();
				
				for(var j:int = 0; j<assetList.length(); j++)
				{
					assetArray.push({url:ApplicationFacade.baseURL+assetList[j].@url.toString(), type:assetList[j].@type.toString()});
				}
				
				languages_array.push({code:languageData[i].@code, label:languageData[i].label,assetList:assetArray, treeUrl:languageData[i].url});
			}
			
			if(activeLangId == -1)
			{
				//activeLangId = 0;
				var strHome:String = "#/home/"
				ExternalInterface.call("switchLanguageTo('"+languageData[0].@code+"','"+strHome+"')");
			}
			else
			{		
				activeLanguage = languages_array[activeLangId].code;
				var treeUrl:String=ApplicationFacade.baseURL+String(languages_array[activeLangId].treeUrl);		
						
				sendNotification(ApplicationFacade.LANGUAGES_AVAILABLE, treeUrl);
			}
			
			
			
		}
		
		protected function get languageList():Array
		{
			return languages_array;
		}
		
		public function getAssetList():Array
		{
			var tempList:Array;
			for(var i:int = 0; i<languages_array.length; i++)
			{
				if(languages_array[i].code == activeLanguage)
				{
					tempList = languages_array[i].assetList;		
				}
			}
			return tempList;
		}
		
		public function get selectedLanguage():String
		{
			return activeLanguage;
		}
		
		protected function get dataSource():String
		{
			return data.url;
		}
		protected function get dataLanguage():String
		{
			return data.lang;
		}

	}
}