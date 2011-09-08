

	//////////////////////////////////////////////////////////////////////
	//																	\\
	//  IREGISTER ~ by  Zulu*											//---------/////////
	//\\ 																\\
	//////////////////////////////////////////////////////////////////////



package com.cobalto.components.core
{
	public interface IRegister
	{
		function registerClass(classObj:Class ):void;
		function getClass( className:Class ):Class;
		function isRegistered( className:String ):Boolean;
	}
}