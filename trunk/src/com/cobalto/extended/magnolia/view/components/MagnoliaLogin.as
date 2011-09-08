
//////////////////////////////////////////////////////////////////////
//																	\\
//  MOTOGUZZI_RLOGINFORM ~ by  Zulu*								//---------/////////
//																	\\
//////////////////////////////////////////////////////////////////////

package com.cobalto.extended.magnolia.view.components
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.api.IViewComponent;
	import com.cobalto.components.pages.Page;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MagnoliaLogin extends Page implements IViewComponent
	{
		public static const SEND_LOGIN_DATA:String = "SendLoginData";
		public static const CLOSE_CLICKED:String = "CloseClicked";
		
		public static const MAGNOLIA_TRANSITION_IN:String = "MagnoliaTransitionIn";
		public static const MAGNOLIA_TRANSITION_OUT:String = "MagnoliaTransitionOut";
		
		protected var holder:Sprite;
		protected var visibleState:Boolean = false;
		
		public function MagnoliaLogin()
		{
			super();
		}
		
		override public function build(pageData:Object=null):void
		{
			super.build(pageData);
		}
		
		public function showLogin():void
		{
			visibleState = true;
			dispatchEvent(new Event(ApplicationFacade.MANAGE_FOOTER,true));
		}
		
		public function hideLogin():void
		{
			visibleState = false;
			dispatchEvent(new Event(MAGNOLIA_TRANSITION_OUT,true));
			dispatchEvent(new Event(ApplicationFacade.MANAGE_FOOTER,true));
		}
		
		public function get loginData():Object
		{
			return [];
		}
		
		public function get loginVisibleState():Boolean
		{
			return visibleState;
		}
	
	}
}