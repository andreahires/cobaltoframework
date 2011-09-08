package com.cobalto.components.gallery
{
	import flash.events.Event;
	

	
	public class GallerySteps extends AbstractGallery
	{
		

		
		public function GallerySteps(urlArray:Array)
		{
			
			super(urlArray);
			
		}
		
		override public function startMultiLoader():void
		{
			
			super.startMultiLoader();
			createStepHolders();
			
		}
		
		protected function createStepHolders():void
		{
						
			
		}

		// * handlers
		protected function onStepClick(e:Event):void
		{
			
		}

		protected function onStepOver(e:Event):void
		{
			
		}
		
		protected function onStepOut(e:Event):void
		{
			
		}
		
	}
}