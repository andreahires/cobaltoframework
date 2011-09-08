package com.cobalto.utils
{
	import com.cobalto.ApplicationFacade;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	
	public class AssetManager
	{
		public static var _instance:AssetManager;
		private static var _fontAppDomain:ApplicationDomain;
		private static var _av1Movie:MovieClip;
		
		public static var Start_Library_Domain:ApplicationDomain;
		public static var Main_Library_Domain:ApplicationDomain;
		public static var Sound_Library_Domain:ApplicationDomain;
		
		//*****************************
		// Constructor
		//*****************************
		public function AssetManager()
		{
			super();
		}
		
		//*****************************
		// Set LoderInfo.ApplicationDomain
		//*****************************
		public static function set startLibraryApplicationDom(appDomain:ApplicationDomain):void
		{
			Start_Library_Domain = appDomain;
		}
		
		public static function set soundApplicationDom(appDomain:ApplicationDomain):void
		{
			Sound_Library_Domain = appDomain;
			
			//trace("sound library domain" + Sound_Library_Domain);
			
		}
		
		public static function set mainLibraryApplicationDom(appDomain:ApplicationDomain):void
		{
			
			Main_Library_Domain = appDomain;
		}
		
		public static function set fontsApplicationDom(appDomain:ApplicationDomain):void
		{
			_fontAppDomain = appDomain;
		}
		
		public static function set introMovie(av1Movie:MovieClip):void
		{
			_av1Movie = av1Movie;
		}
		
		public static function getIntroMovie():MovieClip
		{
			return _av1Movie;
		}
		
		//*****************************
		// Register Fontlist
		//*****************************
		public static function registerFonts(fontList:Array):void
		{
			var i:uint = 0;
			
			//greek language
			/*if (ApplicationFacade.staticLanguage == "gr-GR")
			{
				for(i = 0;i < fontList.length;i++)
				{
					trace("fontList[i] = "+fontList[i]);
					var currentFont:String = fontList[i];
					Font.registerFont(getFontGR()[fontList[i]]);
				}
				
			}*/
			
			//other language
			//else
			//{
				for(i = 0;i < fontList.length;i++)
				{
					//trace("fontList[i] = "+fontList[i]);
					Font.registerFont(getFont(fontList[i]));
				}
				
			//}
			
			//trace("-----------enumerating Fonts");
			//trace(Font.enumerateFonts());
		}
		
		//*****************************
		// To get Library Font | Linkage name
		//*****************************
		public static function getFont(id:String):Class
		{
			//trace ("font ID = "+id);
			return _fontAppDomain.getDefinition(id) as Class;
		}
		
		public static function getFontGR():Class
		{
			return _fontAppDomain.getDefinition("Fonts") as Class;
		}
		
		//*****************************
		// To get Library MovieClip | Linkage name
		//*****************************
		public static function getItem(id:String,appDomain:ApplicationDomain=null):MovieClip
		{
			var itemClass:Class = getItemClass(id,appDomain);
			return new itemClass as MovieClip;
		}
		
		//*****************************
		// To get Library Bitmapdata | Linkage name
		//*****************************
		public static function getBitmapData(id:String,appDomain:ApplicationDomain):BitmapData
		{
			var itemClass:Class = getItemClass(id,appDomain);
			return new itemClass(0,0) as BitmapData;
		}
		
		//*****************************
		// To get Library Sound | Linkage name
		//*****************************
		
		public static function getSound(id:String,appDomain:ApplicationDomain=null):Sound
		{
			
			//trace("stringa item sound class" + id);
			
			var itemClass:Class = getSoundItemClass(id,appDomain);
			return new itemClass as Sound;
		}
		
		public static function getSoundItemClass(id:String,appDomain:ApplicationDomain):Class
		{
			
			if(appDomain == null)
			{
				return Sound_Library_Domain.getDefinition(id) as Class;
			}
			else
			{
				return appDomain.getDefinition(id) as Class;
			}
			
		}
		
		//*****************************
		// Returns id:String as Class
		//*****************************
		public static function getItemClass(id:String,appDomain:ApplicationDomain):Class
		{
			
			if(appDomain == null)
			{
				return Main_Library_Domain.getDefinition(id) as Class;
			}
			else
			{
				return appDomain.getDefinition(id) as Class;
			}
		}
		
	}
}
