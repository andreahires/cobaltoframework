package com.cobalto.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MemoryUtils extends EventDispatcher
	{
		public function MemoryUtils(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function removeFromStage(clip:DisplayObject):void
		{
			if(clip)
			{
				if(clip.parent)
				{
					if(clip is MovieClip)
					{
						MovieClip(clip).stop();
						
						if(MovieClip(clip).loaderInfo)
						{
							if(MovieClip(clip).loaderInfo.loader)
							{
								MovieClip(clip).loaderInfo.loader.unloadAndStop(true);
							}
							
						}
					}
					recursiveMemoryFreeDisplayList(clip as DisplayObjectContainer);
					clip.parent.removeChild(clip);
					clip = null;
				}
			}
		}
		
		public static function recursiveMemoryFreeDisplayList(clip:DisplayObjectContainer):void
		{
			if(clip)
			{
				while(clip.numChildren > 0)
				{
					var child:*;
					
					try
					{
						child = clip.getChildAt(0);
					}
					catch(e:Error)
					{
						return;
					}
					
					if(child)
					{
						
						if(child is MovieClip)
						{
							//trace(child + " stopping");
							MovieClip(child).stop();
							
							if(MovieClip(child).loaderInfo)
							{
								if(MovieClip(child).loaderInfo.loader)
								{
									MovieClip(child).loaderInfo.loader.unloadAndStop(true);
								}
								
							}
						}
						
						if(child.parent)
						{
							if(child.parent is Loader)
							{
								
							}else{
								child.parent.removeChild(child);
							}
						}
						
						recursiveMemoryFreeDisplayList(child as DisplayObjectContainer);
						child = null;
					}
					
				}
				
			}
		}
	}
}