package com.cobalto.components.progress
{
	import com.cobalto.api.IProgressComponent;
	import com.cobalto.components.pages.Page;
	
	import flash.display.Shape;
	
	public class ProgressViewComponent extends Page implements IProgressComponent
	{
		protected var bar:Shape;
		
		public function ProgressViewComponent()
		{
			super();
		}
		
		public function start():void
		{
		}
		
		public function update(percent:Number):void
		{
		}
		
		public function reset():void
		{
		}
	}
}