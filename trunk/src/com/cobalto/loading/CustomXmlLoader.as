package com.cobalto.loading{
	import flash.events.EventDispatcher;
			public class CustomXmlLoader extends XmlLoader 	{		private var _dataObject:Object;		public function CustomXmlLoader(pDataUrl:String, dataObject:Object)		{			_dataObject = dataObject;			super(pDataUrl);		}				public function get dataObject():Object		{			return _dataObject				}			}}