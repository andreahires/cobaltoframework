package com.cobalto.core.view
{
	
	import com.cobalto.ApplicationFacade;
	import com.cobalto.MainHolder;
	import com.cobalto.api.IProgressComponent;
	import com.cobalto.api.IViewComponent;
	import com.cobalto.components.pages.Footer;
	import com.cobalto.components.pages.Layer;
	import com.cobalto.components.pages.Page;
	import com.cobalto.components.pages.PageHolder;
	import com.cobalto.components.progress.ProgressViewComponent;
	import com.cobalto.core.view.LayerMediator;
	import com.cobalto.utils.StageSetup;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import site.SiteFacade;
	
	// Mediator for interacting with the Stage.
	public class StageMediator extends Mediator implements IMediator
	{
		
		// Cannonical name of the Mediator
		public static const NAME:String = 'StageMediator';
		
		// display objects
		protected var mainHolder:MainHolder;
		protected var mainMenuMediator:IMediator;
		
		protected var layer:Layer;
		protected var layerMediator:IMediator;
		
		protected var footer:Footer;
		protected var footerMediator:IMediator;
		
		protected var pageHolder:PageHolder;
		protected var pageMediator:IMediator;
		
		protected var progressComponent:IViewComponent;
		
		// Constructor
		public function StageMediator(viewComponent:Stage)
		{
			// pass the viewComponent to the superclass
			super(NAME,viewComponent);
			
			var stageSetup:StageSetup = new StageSetup(viewComponent);
			stageSetup.addEventListener(StageSetup.STAGE_RESIZE,onStageResize);
			
			mainHolder = new ApplicationFacade._mainHolderClass;
			viewComponent.addChild(mainHolder);

			var progressComponentClass:Class = ApplicationFacade.progressComponentClass;
			progressComponent = new progressComponentClass();
			
			var progressMediatorClass:Class = ApplicationFacade._progressMediatorClass;
			facade.registerMediator(new progressMediatorClass(progressComponent as IProgressComponent) as Mediator);
			
			var layerClass:Class = ApplicationFacade.layerComponentClass;
			layer = new layerClass();
			viewComponent.addChild(layer);
			
			var layerMediator:LayerMediator = new LayerMediator(layer);
			
			facade.registerMediator(layerMediator as Mediator);
			
			var footerClass:Class = ApplicationFacade.footerComponentClass;
			footer = new footerClass();
			viewComponent.addChild(footer);
			
			var footerMediatorClass:Class = ApplicationFacade._footerMediatorClass;
			facade.registerMediator(new footerMediatorClass(footer) as Mediator);
			
			viewComponent.addChild(progressComponent as Page);
		}
		
		//*** display list activity
		public function createSubMediators():void
		{
			pageHolder = new PageHolder();
			stageRef.addChildAt(pageHolder,2);
			
			pageMediator = new PageMediator(pageHolder);
			facade.registerMediator(pageMediator);
			
			var mainMenuMediatorClass:Class = ApplicationFacade._menuMediatorClass;
			mainMenuMediator = new mainMenuMediatorClass(stageRef);
			facade.registerMediator(mainMenuMediator);
		
			//stageRef.swapChildren(pageHolder,footer);
		}
		
		protected function onStageResize(e:Event):void
		{
			sendNotification(ApplicationFacade.STAGE_RESIZE);
		}
		
		// Return list of Nofitication names that Mediator is interested in
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.STAGE_RESIZE,ApplicationFacade.LANGUAGES_AVAILABLE,ApplicationFacade.MAIN_ASSETS_PROGRESS,ApplicationFacade.MAIN_ASSETS_AVAILABLE,ApplicationFacade.PAGE_ON_EDIT_MODE];
		
		}
		
		// Handle all notifications this Mediator is interested in
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case ApplicationFacade.STAGE_RESIZE:
					mainHolder.organizeItems();
					layer.organizeItems();
					
					break;
				
				case ApplicationFacade.MAIN_ASSETS_AVAILABLE:
					mainHolder.addMainLibraryAssets();
					layer.build();
					break;
				
				case ApplicationFacade.PAGE_ON_EDIT_MODE:
					mainHolder.onPageEditMode();
					break;
			
			}
		}
		
		// Get the Mediator name
		override public function getMediatorName():String
		{
			return NAME;
		}
		
		public function get stageRef():Stage
		{
			return viewComponent as Stage;
		}
	
	}
}