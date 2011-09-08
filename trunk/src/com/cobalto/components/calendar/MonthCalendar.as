package com.cobalto.components.calendar
{
	import com.cobalto.api.IViewComponent;
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.utils.AssetManager;
	import com.cobalto.utils.Web;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MonthCalendar extends MovieClip implements IViewComponent
	{
		private var gapX:uint = 30;
		private var gapY:uint = 25;
		
		private var _skin:MovieClip;
		
		private var _eventList:Array = new Array();
		
		private var _current_date:Date = new Date();
		
		private var _currentYear:uint = _current_date.getFullYear();
		private var _currentMonth:uint = _current_date.getMonth();
		private var _currentDay:uint = _current_date.date;
		
		private var _selectedMonth:uint = _current_date.getMonth();
		private var _selectedYear:uint = _current_date.getFullYear();
		
		private var monthdaysOlympic_arr:Array = new Array(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		private var monthdaysNormal_arr:Array = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		
		
		public function MonthCalendar()
		{
			super();
		}
		
		private function dayStart(month:uint, year:uint):uint {
			var tmpDate:Date = new Date(year, month, 0);
			return (tmpDate.getDay());
		}
		private function daysMonth(month:uint, year:uint):uint {
			var tmp:Number = year % 4;
			if (tmp == 0) {
				return (monthdaysOlympic_arr[month]);
			} else {
				return (monthdaysNormal_arr[month]);
			}
		}
		
		private function clearCalendar():void {
			var total:uint = _skin.mList.numChildren;
			for (var i:uint=0; i<total; i++) {
				_skin.mList.removeChildAt(0);
			}
		}
		
		public function build():void {
			clearCalendar();
			var totalDay:uint = daysMonth(_selectedMonth, _selectedYear);
			var firstDay:uint = dayStart(_selectedMonth, _selectedYear);
			var hisY:Number = 0;
			for (var i:uint = 1; i <= totalDay; i++) 
			{
				var item:PrimitiveButton = new PrimitiveButton;
				var itemSkin:MovieClip = AssetManager.getItem("DateItem") as MovieClip;
				itemSkin.dayHolder.txt.text = String(i);
				item.skin = itemSkin;
				item.enable = false;
				item.x = gapX * firstDay;
				item.y = hisY;
				if (firstDay >= 6) {
					firstDay = 0;
					hisY += gapY;
				} else {
					firstDay++;
				}
				_skin.mList.addChild(item);
				
				itemSkin.dayHolder.gotoAndStop(3);
				itemSkin.bg.gotoAndStop(1);
				
				//* display current day
				
				
				//* display events and current day
				var numEvent:uint = _eventList.length
				var currentDay:Boolean = false;
					
				//**check currennt day
				if(i == _currentDay && _selectedMonth == _currentMonth && _selectedYear == _currentYear)
				{
					currentDay = true;
					itemSkin.dayHolder.gotoAndStop(1);
					itemSkin.bg.gotoAndStop(1);
				}
					
				if (numEvent > 0)
				{
					for(var event:uint = 0; event< numEvent; event++)
					{	
						
						var eventDay:uint = _eventList[event].day;
						var eventMonth:uint = _eventList[event].month;
						var eventYear:uint = _eventList[event].year;
							
						
						//**check for event and current day
						if(currentDay == true && i == eventDay && _selectedMonth + 1 == eventMonth && _selectedYear == eventYear )
						{
							itemSkin.dayHolder.gotoAndStop(2);
							itemSkin.bg.gotoAndStop(4);
							item.addEventListener(PrimitiveButton.BUTTON_CLICKED,onCalendarEventClicked);
							item.id = event;
							item.enable = true;
						}						
						
						//**check for event
						else if(i == eventDay +1 && _selectedMonth + 1 == eventMonth && _selectedYear == eventYear)
						{
							itemSkin.dayHolder.gotoAndStop(2);
							itemSkin.bg.gotoAndStop(3);
							item.addEventListener(PrimitiveButton.BUTTON_CLICKED,onCalendarEventClicked);
							item.id = event;
							item.enable = true;
						}
						
					}
				}	
				
					
				//**check for next days
				if(i < _currentDay && _selectedMonth == _currentMonth && _selectedYear == _currentYear)
				{
					itemSkin.dayHolder.gotoAndStop(1);
					itemSkin.bg.gotoAndStop(1);
				}
				else if(_selectedMonth < _currentMonth && _selectedYear <= _currentYear)
				{
					itemSkin.dayHolder.gotoAndStop(1);
					itemSkin.bg.gotoAndStop(1);
				}
				
			}
		}
		
		//** this is used to open the page of the selected event
		private function onCalendarEventClicked(e:Event):void
		{
			var call:String
			call = _eventList[e.target.id].path;
			
			Web.getURL(call,"_self");
		}
		
		public function organizeItems():void
		{
		}
		
		public function transitionIn():void
		{
		}
		
		public function transitionOut():void
		{
		}
		
		//This function can be used to visualize a given month
		//@params {month:uint, year:uint}
		public function showMonth(data:Object):void
		{
			_selectedMonth = data.month;
			_selectedYear = data.year;

			build();
		}
		
		//** This function is used to set the skin of the calen
		public function set skin(skin:MovieClip):void
		{
			_skin = skin;
			addChild(_skin);
		}
		
		//** This is used to return the current year
		public function get currentYear():uint
		{
			return _currentYear;
		}
		
		//** This is used to return the current month in a range from 0 to 11
		public function get currentMonth():uint
		{
			return _currentMonth;
		}
		
		//** This function is used to set events to display
		// @params [{day:uint, month:uint, year:uint},{day:uint, month:uint, year:uint}]
		public function set eventList(data:Array):void
		{
			_eventList = data;	
		}
		
		public function set id(pageId:int):void
		{
		}
		
		public function get id():int
		{
			return 0;
		}
	}
}
