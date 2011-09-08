package com.cobalto.events
{
	import flash.events.EventDispatcher;

	public class EventManager extends EventDispatcher
	{
		public static const TRANSITION_OUT_COMPLETE:String = "TransitionOutComplete";
		public static const TRANSITION_IN_COMPLETE:String = "TransitionInComplete";
		public static const ON_MENU_CLICK:String = "OnMenuClick";
		public static const MAINMENU_ADDED:String = "MainMenuAdded";
		public static const MENU_OUT_COMPLETE:String = "MenuOutComplete";
		public static const SECTION_READY:String = "SectionReady";
		//public static const ON_LANGUAGE_SELECT:String = "OnLanguageSelect";
		
		public static const ON_3D_THUMB_CLICK:String =  "on3DThumbClick";
		public static const ON_3D_OUT_END:String =  "on3DOutEnd";
		public static const ON_DESC_OUT_END:String = "onDescOutEnd";
		public static const ON_MASK_OUT_END:String = "OnMaskOutEnd";
		public static const ON_CUEPOINT:String = "OnCuepoint";
		public static const ON_PROJECT_MENU_CLICK:String = "OnProjectMenuClick";
		
		public static const  ON_DRAG_OVER:String = "OnDragOver";
		public static const  ON_DRAG_OUT:String = "OnDragOut";
		public static const  ON_DRAG_DOWN:String = "OnDragDown";
		public static const  ON_DRAG_RELEASE:String = "OnDragRelease";
		
	}
}