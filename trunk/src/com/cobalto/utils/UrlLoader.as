package com.cobalto.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	
	public class UrlLoader extends EventDispatcher implements IEventDispatcher
	{
		private var resultDataString : String;
		protected var UrlVariables : URLVariables = new URLVariables();
		protected var loader : URLLoader = new URLLoader();
		protected var UrlRequest : URLRequest = new URLRequest();
		
		public static const INIT : String = 'Init';
		public static const ON_PROGRESS : String = 'OnProgress';
		public static const ON_COMPLETE : String = 'OnComplete';
		public static const ON_SECURITY_ERROR : String = 'OnSecurityError';
		public static const ON_HTTP_STATUS : String = 'OnHttpStatus';
		public static const ON_IO_ERROR : String = 'OnIOError';
		
																			//Default methos is POST			    	// Default Format is TEXT
		public function UrlLoader(Url:String, Data:Object, RequestMethod:String="POST", UrlDataFormat:String="text")
		{
			super();
			trace(" ");
			trace(" final data from vanGoGh-UrlLoader");
			trace(" ");
			trace('=========================================');
			trace('');
			for (var prop:* in Data)
			{ 
				trace("Data."+prop+" = "+Data[prop]); 
				UrlVariables[prop] = Data[prop];
			} 
			trace('');
			trace('=========================================');
	
			UrlRequest.url = Url;
			UrlRequest.data = UrlVariables;
			UrlRequest.method = RequestMethod;
			loader.dataFormat = UrlDataFormat;
			loader.load(UrlRequest);
			
			addLoaderListeners();
		}

		private function addLoaderListeners():void 
		{
			loader.addEventListener(Event.OPEN,init);
			loader.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.addEventListener(Event.COMPLETE,onComplete);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
		}
		
		private function init(e:Event):void 
		{
			//ExternalInterface.call("console.log",{response:"Init"});
			dispatchEvent(new Event(INIT,true));
		}
		
		private function onProgress(e:ProgressEvent):void 
		{
			//ExternalInterface.call("console.log",{response:"Progress"});
			dispatchEvent(new Event(ON_PROGRESS,true));
		}
		
		private function onComplete(e:Event):void 
		{
			var finalStr:String=unescape(String(e.target.data.toString()));
			resultData = finalStr;
			trace('Final Str ',finalStr)
			//ExternalInterface.call("console.log",{response:"Complete"});
			dispatchEvent(new Event(ON_COMPLETE,true));
		}
		
		private function securityError(e:SecurityErrorEvent):void 
		{
			//ExternalInterface.call("console.log",{response:"Security error"});
			dispatchEvent(new Event(ON_SECURITY_ERROR,true));
		}
		
		private function httpStatus(e:HTTPStatusEvent):void 
		{
			//ExternalInterface.call("console.log",{response:"HttpStatus"});
			dispatchEvent(new Event(ON_HTTP_STATUS,true));
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			//ExternalInterface.call("console.log",{response:"ioError"});
			dispatchEvent(new Event(ON_IO_ERROR,true));
		}
		
		public function destroy() :void
		{
			loader.removeEventListener(Event.OPEN,init);
			loader.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.removeEventListener(Event.COMPLETE,onComplete);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatus);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			loader=null;
			resultData=null;
		}
		
		public function set resultData(value:String):void
		{
			resultDataString = value;
		}
		
		public function get resultData():String
		{
			return resultDataString;
		}
	}
}
