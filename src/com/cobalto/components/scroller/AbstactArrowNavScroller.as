package com.cobalto.components.scroller
{
	import flash.events.Event;
	import com.cobalto.components.arrows.AbstractArrowNav;
	
	public class AbstactArrowNavScroller extends AbstractArrowNav
	{
		public function AbstactArrowNavScroller()
		{
			super();
		}
		
		override protected function onArrowClick(e:Event):void
		{
			if(e.target.id == 0)
			{
				

				if(_activeId-1 == 0)
				{
					
					showArrow(0, false);
				
				}else{
					
					showArrow(1, true);
					
				}
				
				_activeId--;
				dispatchEvent(new Event(ARROW_BACK_CLICK, true));
				
			}else{
				
				if(_activeId+1 == _itemsNum-1)
				{
					
					showArrow(1, false);
					
					
				}else{
					
					showArrow(0, true);
					
					
				}
				
				_activeId++;
				dispatchEvent(new Event(ARROW_NEXT_CLICK, true));
				
			}
			
		}

	}
}