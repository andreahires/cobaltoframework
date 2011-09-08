
//////////////////////////////////////////////////////////////////////
//																	\\
//  INPUT_FIELD ~ by  Zulu*											//---------/////////
//\\ 																\\
//////////////////////////////////////////////////////////////////////

package com.cobalto.components.InputField
{
	import com.cobalto.components.core.IForm;
	import com.cobalto.text.TextBuilder;
	import com.cobalto.utils.StringUtils;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class InputField extends TextBuilder implements IForm
	{
		private var Id:int;
		private var Mandatory:Boolean;
		private var Restrict:String;
		private var TextType:String;
		private var MaxChars:Number;
		private var _name:String;
		
		protected var skinHolder:Sprite;
		protected var DefinedWidth:int;
		protected var DefinedHeight:int;
		protected var FieldName:String;
		protected var FieldValue : String;
		
		private static const TEXT_TYPE_INPUT:String = 'INPUT';
		private static const TEXT_TYPE_PASSWORD:String = 'PASSWORD';
		private static const TEXT_TYPE_STATIC:String = 'STATIC';
		private static const TEXT_TYPE_EMAIL:String = 'EMAIL';
		
		public static const COMPONENT_FOCUS_IN:String = 'COMPONENT_FOCUS_IN';
		
		public function InputField(TextString:String, Name:String, width:int=0, height:int=0)
		{
			DefinedWidth = width;
			DefinedHeight = height;
			setName = Name;
			
			super(TextString,width);
			ConfigureHandlers();
			
			this.focusRect = false;
			this.tabEnabled = false;
			this.tabChildren = true;
			this.textField.restrict = restrict;
			this.textField.maxChars = maxChars;
		}
		
		protected function ConfigureHandlers():void
		{
			addEventListener(FocusEvent.FOCUS_IN,onFocusInHandler);
			addEventListener(FocusEvent.FOCUS_OUT,onFocusOutHandler);
			this.textField.addEventListener(TextEvent.TEXT_INPUT, onChangeHandler);
		}
		
		public function build():void
		{
			skinHolder = new Sprite();
			addChild(skinHolder);
			swapChildren(textField,skinHolder);
			
			switch(textType.toUpperCase())
			{
				case TEXT_TYPE_INPUT:
					inputTypeSkin();
					break;
				
				case TEXT_TYPE_EMAIL:
					emailTypeSkin()
					break;
				
				case TEXT_TYPE_PASSWORD:
					passwordTypeSkin();
					break;
				
				case TEXT_TYPE_STATIC:
					staticTypeSkin();
					break;
			}
			
			setComponentSkin();
			emptyField();
		}
		
		public function setComponentSkin():void
		{
		}
		
		public function inputTypeSkin():void
		{
			objectField = {type:TextFieldType.INPUT,selectable:true,border:false,maxChars:maxChars};
		}
		
		public function emailTypeSkin():void
		{
			objectField = {type:TextFieldType.INPUT,selectable:true,border:false,maxChars:maxChars};
		}
		
		public function passwordTypeSkin():void
		{
			objectField = {type:TextFieldType.INPUT,displayAsPassword:true,selectable:true,border:false,maxChars:maxChars};
		}
		
		public function staticTypeSkin():void
		{
			objectField = {type:TextFieldType.DYNAMIC,selectable:false,border:false,maxChars:maxChars};
		}
		
		public function emptyField():void
		{
			textField.autoSize = TextFieldAutoSize.NONE;
			textField.width = DefinedWidth;
			textField.height = DefinedHeight;
			textField.mouseWheelEnabled = false;
			textField.scrollV = 1;
			textField.setSelection(textField.length,textField.length);
			textField.text = String("");
		}
		
		public function onFocusInHandler(focusEvent:FocusEvent):void
		{
			this.stage.focus = focusEvent.target as InteractiveObject;
			dispatchEvent(new Event(COMPONENT_FOCUS_IN,true));
		}
		
		public function onFocusOutHandler(focusEvent:FocusEvent):void
		{
			
		}
		
		public function onChangeHandler (event : TextEvent):void
		{
			
		}
		
		public function onSetFocusInSkinHandler(target:InteractiveObject):void
		{
		}
		
		public function onSetFocusOutSkinHandler(target:InteractiveObject):void
		{
		}
		
		public function onDisableSkinHandler(target:InteractiveObject):void
		{
		}
		
		public function onEnableSkinHandler(target:InteractiveObject):void
		{
		}
		
		public function onErrorSkinHandler(target:InteractiveObject):void
		{
		}
		
		public function reset():void
		{
			textField.text = String('');
		}
		
		public function getData():Object
		{
			var textvalue:String = textField.text.toString();
			if(!StringUtils.hasText(textvalue)) textvalue = null;
			fieldValue=textvalue;
			return {value:textvalue,type:textType,name:getName,fieldName:fieldName,fieldValue:fieldValue};
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
		
		public function set restrict(value:String):void
		{
			Restrict = value;
		}
		
		public function get restrict():String
		{
			return Restrict;
		}
		
		public function set textType(value:String):void
		{
			TextType = value;
		}
		
		public function get textType():String
		{
			return TextType;
		}
		
		public function set maxChars(value:Number):void
		{
			MaxChars = value;
		}
		
		public function get maxChars():Number
		{
			return MaxChars
		}
		
		public function set setName(value:String):void
		{
			_name = value;
		}
		
		public function get getName():String
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
		
		public function setData(value:String):void
		{
			textField.text = value;
		}
	}
}