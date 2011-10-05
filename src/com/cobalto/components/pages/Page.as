// ActionScript file
package com.cobalto.components.pages
{
	import com.cobalto.api.IViewComponent;
	
	import flash.events.Event;
	
	import org.casalib.display.CasaSprite;
	
	public class Page extends CasaSprite implements IViewComponent
	{
		public static const TRANSITION_IN_COMPLETE:String = "transitionInComplete";
		public static const TRANSITION_OUT_COMPLETE:String = "transitionOutComplete";
		public static const PAGE_ON_ADMIN_MODE:String = "PageOnAdminMode";
		
		protected static const INIT:String = "Init";
		protected static const POPULATE_DONE:String = "PopulateDone";
		protected static const TRANSITION_IN_DONE:String = "TransitionInDone";
		protected static const TRANSITION_OUT_DONE:String = "TransitionOutDone";
		
		protected var _id:int;
		protected var isPagePopulated:Boolean = false;
		protected var pageState:String = INIT;
		
		// ** Constructor
		public function Page()
		{
		}
		
		// * Organize Items		
		public function organizeItems():void
		{
		}
		
		public function build(pageData:Object=null):void
		{
			isPagePopulated = true;
			pageState = "populateDone";
		}
		
		// * Transition Managers
		public function transitionIn():void
		{
			if(pageState == TRANSITION_IN_DONE || pageState == INIT)
			{
				onTransitionInEnd();
				trace("page TransitionIn already done");
				return;
			}
			else
			{
				transitionInTween();
			}
		}
		
		protected function transitionInTween():void
		{
		
		}
		
		public function transitionOut():void
		{
			
			if(pageState == TRANSITION_OUT_DONE || pageState == POPULATE_DONE || pageState == INIT)
			{
				onTransitionOutEnd();
				trace("page TransitionOut already done or the page is not populated yet " + this);
			}
			else
			{
				transitionOutTween();
			}
		}
		
		protected function transitionOutTween():void
		{
			
		}
		
		protected function onTransitionInEnd():void
		{
			pageState = TRANSITION_IN_DONE;
			dispatchEvent(new Event(TRANSITION_IN_COMPLETE,false));
		
		}
		
		protected function onTransitionOutEnd():void
		{
			pageState = TRANSITION_OUT_DONE;
			dispatchEvent(new Event(TRANSITION_OUT_COMPLETE,false));
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		public function set id(pageId:int):void
		{
			_id = pageId;
		}
		
		public function get id():int
		{
			return _id;
		}
	}
}