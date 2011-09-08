package com.cobalto.api
{
	import flash.events.IEventDispatcher;
	
	public interface IModel extends IEventDispatcher
	{
		function init():void;
		function loadLanguages(url:String = ""):void;
		function loadMainData(urlToLoad:Array):void;
		function loadSiteTree(url:String = ""):void;
		
		function get mainDataPercent():Number;
		function getLanguages():Array;
		function getActiveLanguage():String;
	}
}