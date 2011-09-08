/**
 * Base PureMVC Project
 */
package com.cobalto
{
	import com.cobalto.ApplicationFacade;
	
	import flash.display.Sprite;
	
	/**
	 * A simple Document Class for a PureMVC Structured project
	 *
	 * @see org.puremvc.as3.* PureMVC
	 */
	public class MainBase extends Sprite
	{
		private var facade:ApplicationFacade;
		
		public function MainBase()
		{
			/**
			 * intialize the framework
			 */
			facade = ApplicationFacade.getInstance();
			facade.startup(this.stage,{});
		}
	}
}
