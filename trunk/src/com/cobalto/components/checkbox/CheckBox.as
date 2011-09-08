package com.cobalto.components.checkbox
{
	import com.cobalto.components.buttons.CheckBoxButton;
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.components.core.IForm;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import style.Styles;
	
	import style.Styles;
	
	public class CheckBox extends Sprite implements IForm
	{
		//** Reserved for the future
		private var DefaultCheckBoxButtonId:int;
		private var _name:String;
		private var Id:int;
		private var Mandatory:Boolean;
		protected var SelectedId:int = -1;
		protected var TextValue:String = null;
		
		protected var Data:Array;
		protected var LabelStyle:Object;
		protected var DataLength:uint;
		protected var button:Class;
		protected var FieldName:String;
		protected var FieldValue:String;
		protected var CurrentSKin:DisplayObject;
		
		public static const ON_CHANGE:String = 'OnCheckBoxChange';
		
		public function CheckBox(Button:CheckBoxButton,DataArray:Array,Name:String)
		{
			super();
			
			ConfigureHandlers();
			///////////////////////////
			this.focusRect = false;
			this.tabEnabled = true;
			this.tabChildren = true;
			
			///////////////////////////
			setName = Name;
			Data = DataArray;
			DataLength = Data.length;
			button = getClass(Button);
			
			///////////////////////////
			defineStyle();
		}
		
		private function getClass(classObj:CheckBoxButton):Class
		{
			var className:String = getQualifiedClassName(classObj).split("::").join(".");
			return getDefinitionByName(className) as Class;
		}
		
		protected function ConfigureHandlers():void
		{
			addEventListener(FocusEvent.FOCUS_IN,onFocusInHandler);
			addEventListener(FocusEvent.FOCUS_OUT,onFocusOutHandler);
		}
		
		public function onFocusInHandler(focusEvent:FocusEvent):void
		{
			this.stage.focus = focusEvent.target as InteractiveObject;
		}
		
		public function onFocusOutHandler(focusEvent:FocusEvent):void
		{
		
		}
		
		protected function defineStyle():void
		{
			LabelStyle = Styles.FAGO_11_YELLOW;
		}
		
		public function build():void
		{
			var i:uint = 0;
			
			while(i < DataLength)
			{
				var btn:CheckBoxButton = new button();
				btn.setLabel(listDataOf('label')[i].toString());
				btn.id = i;
				addChild(btn);
				btn.setState(DefaultCheckBoxButtonId);
				btn.build();
				btn.addEventListener(PrimitiveButton.BUTTON_CLICKED,onButtonClickHandler);
				alignCheckBoxOnAddedToStage(btn as CheckBoxButton);
				
				++i;
			}
		}
		
		protected function listDataOf(value:String):Array
		{
			var resultArray:Array = [];
			var i:int = 0;
			
			while(i < DataLength)
			{
				resultArray.push(Data[i][value]);
				++i;
			}
			
			return resultArray;
		}
		
		protected function onButtonClickHandler(event:Event):void
		{
			SelectedId = -1;
			
			var button:CheckBoxButton = event.target.parent as CheckBoxButton;
			
			if(button.getCurrentState() === 0)
				button.setState(1),SelectedId = button.id;
			else if(button.getCurrentState() === 1)
				button.setState(0);
			CurrentSKin = button.buttonSkin.getChildByName('focusStroke');
			/*fieldValue = listDataOf('value')[SelectedId];
			 TextValue = listDataOf('label')[SelectedId];*/
			onChangeHandler(event);
			deSelectOthers();
		}
		
		public function setButtonClick(buttonUID:int):void
		{
			SelectedId = -1;
			var button:CheckBoxButton = this.getChildAt(buttonUID) as CheckBoxButton;
			
			if(button.getCurrentState() === 0)
				button.setState(1),SelectedId = button.id;
			else if(button.getCurrentState() === 1)
				button.setState(0);
			CurrentSKin = button.buttonSkin.getChildByName('focusStroke');
			/*fieldValue = listDataOf('value')[SelectedId];
			TextValue = listDataOf('label')[SelectedId];*/
			onChangeHandler();
			deSelectOthers();
		}
		
		public function onChangeHandler(event:Event=null):void
		{
			var length:int = this.numChildren;
			var i:int = 0;
			
			while(i < length)
			{
				var btn:CheckBoxButton = this.getChildAt(i) as CheckBoxButton;
				btn.buttonSkin.getChildByName('errorBg').alpha = 0;
				
				++i;
			}
		}
		
		protected function deSelectOthers():void
		{
			var length:int = this.numChildren;
			var i:int = 0;
			
			while(i < length)
			{
				var btn:CheckBoxButton = this.getChildAt(i) as CheckBoxButton;
				
				if(SelectedId !== btn.id)
					btn.setState(0);
				
				++i;
			}
			
			dispatchEvent(new Event(ON_CHANGE,true));
		}
		
		protected function alignCheckBoxOnAddedToStage(target:CheckBoxButton):void
		{
		
		}
		
		public function onSetFocusInSkinHandler(target:InteractiveObject):void
		{
		};
		
		public function onSetFocusOutSkinHandler(target:InteractiveObject):void
		{
		};
		
		public function onDisableSkinHandler(target:InteractiveObject):void
		{
		};
		
		public function onEnableSkinHandler(target:InteractiveObject):void
		{
		};
		
		public function onErrorSkinHandler(target:InteractiveObject):void
		{
			var length:int = this.numChildren;
			var i:int = 0;
			
			while(i < length)
			{
				var btn:CheckBoxButton = this.getChildAt(i) as CheckBoxButton;
				btn.buttonSkin.getChildByName('errorBg').alpha = 1;
				++i;
			}
		
		}
		
		public function reset():void
		{
			SelectedId = -1;
			(SelectedId !== -1) ? fieldValue = listDataOf('value')[SelectedId].toString() : fieldValue = null;
			var i:uint = 0;
			var length:uint = this.numChildren;
			
			while(i < length)
			{
				(this.getChildAt(i) as CheckBoxButton).setState(0);
				(this.getChildAt(i) as CheckBoxButton).buttonSkin.getChildByName('errorBg').alpha = 0;
				
				++i;
			}
		}
		
		public function getData():Object
		{
			(SelectedId !== -1) ? fieldValue = listDataOf('value')[SelectedId].toString() : fieldValue = null;
			
			if(!fieldName)
				fieldName = getName;
			return {textValue:TextValue,type:'checkBox',name:getName,fieldName:fieldName,fieldValue:fieldValue};
		}
		
		public function setData(value:String):void
		{
			if(value)
			{
				SelectedId = -1;
				var i:int = 0;
				
				while(i < DataLength)
				{
					if(value.toUpperCase() === Data[i].value.toString().toUpperCase())
					{
						SelectedId = i;
						break;
					}
					
					++i;
				}
				
				var button:CheckBoxButton = getChildAt(SelectedId) as CheckBoxButton;
				
				if(button.getCurrentState() === 0)
					button.setState(1),SelectedId = button.id;
				else if(button.getCurrentState() === 1)
					button.setState(0);
				CurrentSKin = button.buttonSkin.getChildByName('focusStroke');
				onChangeHandler();
				deSelectOthers();
			}
		}
		
		public function set id(index:int):void
		{
			Id = index;
		}
		
		public function get id():int
		{
			return Id;
		}
		
		public function set mandatory(value:Boolean):void
		{
			Mandatory = value;
		}
		
		public function get mandatory():Boolean
		{
			return Mandatory;
		}
		
		private function set setName(value:String):void
		{
			_name = value;
		}
		
		protected function get getName():String
		{
			return _name;
		}
		
		public function set fieldName(value:String):void
		{
			FieldName = value;
		}
		
		public function get fieldName():String
		{
			return FieldName;
		}
		
		public function set fieldValue(value:String):void
		{
			FieldValue = value;
		}
		
		public function get fieldValue():String
		{
			return FieldValue;
		}
		
		public function get selectedId():int
		{
			return SelectedId;
		}
	}
}