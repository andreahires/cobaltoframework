
//////////////////////////////////////////////////////////////////////
//																	\\
//  FORM ~ by  Zulu*												//---------/////////
//\\ 																\\
//////////////////////////////////////////////////////////////////////

package com.cobalto.components.Forms
{
	
	import com.cobalto.components.InputField.InputField;
	import com.cobalto.components.ListBox.ListBox;
	import com.cobalto.components.core.IForm;
	import com.cobalto.utils.AssetManager;
	import com.cobalto.utils.StringUtils;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.net.URLVariables;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	public class Form extends Sprite implements IForm
	{
		private var _name:String;
		private var _id:int;
		private var _holder:MovieClip;
		private var _componentsListArray:Array;
		private var _mandatory:Boolean;
		private var _fieldCamparisonArray:Array;
		private var _displayDataXmlList:XMLList;
		
		protected var isFormValidationSuccess:Boolean = true;
		protected var dataVariable:URLVariables;
		
		private const PasswordArrayIndex:int = 0;
		private const EmailArrayIndex:int = 1;
		
		protected var inputClassObject:Class;
		protected var listBoxClassObject:Class;
		protected var checkBoxClassObject:Class;
		protected var radioButtonClassObject:Class;
		protected var formButtonClassObject:Class;
		protected var autoFocusObject:InteractiveObject;
		
		public var regForm:MovieClip;
		protected var component:PlaceHolder;
		
		public static const TEXT_TYPE_INPUT:String = 'INPUT';
		public static const TEXT_TYPE_PASSWORD:String = 'PASSWORD';
		public static const TEXT_TYPE_STATIC:String = 'STATIC';
		public static const TEXT_TYPE_EMAIL:String = 'EMAIL';
		
		public static const FORM_VALIDATION_SUCCESS:String = 'FORM_VALIDATION_SUCCES';
		public static const FORM_EMAIL_VALIDATION_ERROR:String = 'FORM_EMAIL_VALIDATION_ERROR';
		public static const FORM_EMAIL_COMPARISON_ERROR:String = 'FORM_EMAIL_COMPARISON_ERROR';
		public static const FORM_PASSWORD_COMPARISON_ERROR:String = 'FORM_PASSWORD_COMPARISON_ERROR';
		public static const FORM_RESET:String = 'FORM_RESET';
		public static const FORM_MISSING_FIELDS_ERROR:String = 'FORM_MISSING_FIELDS_ERROR';
		public static const FORM_INVALID_DATE_ERROR:String = 'FORM_INVALID_DATE_ERROR';
		
	
		protected var totalComponents:uint;
		
		public function Form(objectClassName:String,displayDataXmlList:XMLList=null)
		{
			name = objectClassName;
			displayData = displayDataXmlList;
			_fieldCamparisonArray = new Array();
			configureHandlers();
		}
		
		public function build():void
		{
			regForm = AssetManager.getItem(name) as MovieClip;
			holder = regForm.form;
			addChild(regForm);
			regForm.alpha = 1;
			filterComponents();
			
			this.tabEnabled = false;
			holder.tabEnabled = false;
			holder.tabChildren = true;
		}
		
		private function configureHandlers():void
		{
			addEventListener(FocusEvent.FOCUS_IN,onComponentFocusIn);
			addEventListener(FocusEvent.FOCUS_OUT,onComponentFocusOut);
			addEventListener(ListBox.EXPAND_LIST,onListBoxEpandHandler);
			addEventListener(ListBox.COLLAPSE_LIST,onListBoxCollapseHandler);
		}
		
		/*
			   public function assignClassObjects():void
			   {
			   for(var i:int = 0; i<_componentsListArray.length; ++i)
			   {
			   if(isSuperClass(_componentsListArray[i]) === 'ListBox')
			   {
			   listBoxClassObject = getClass(_componentsListArray[i] as Class);
			   }
			   else if(isSuperClass(_componentsListArray[i]) === 'InputField')
			   {
			   inputClassObject = getClass(_componentsListArray[i] as Class);
			   }
			   else if(isSuperClass(_componentsListArray[i]) === 'CheckBox')
			   {
			   checkBoxClassObject = getClass(_componentsListArray[i] as Class);
			   }
			   else if(isSuperClass(_componentsListArray[i]) === 'RadioButton')
			   {
			   radioButtonClassObject = getClass(_componentsListArray[i] as Class);
			   }
			   else if(isSuperClass(_componentsListArray[i]) === 'ListButton')
			   {
			   formButtonClassObject = getClass(_componentsListArray[i] as Class);
			   }
			   }
			
			   }
		 */
		
		public function filterComponents():void
		{
			var children:int = holder.numChildren;
			totalComponents = children;
		
			var i:int = 0;
			
			while(i < children)
			{
				switch((getComponent(i).ComponentType).toUpperCase())
				{
					case 'LISTBOX':
						addListBox(i);
						break;
					case 'TEXT':
						addTextBox(i);
						break;
					case 'RADIOBUTTON':
						addRadioButton(i);
						break;
					case 'CHECKBOX':
						addCheckBox(i);
						break;
					case 'BUTTON':
						addButton(i);
						break;
				}
				
				++i;
			}
			
			if(i===totalComponents)
			{
				ivokeDefaultMethodInsideForm();
			}
		}
		
		protected function ivokeDefaultMethodInsideForm():void
		{
		
		}
		
		public function setAutoFocus():void
		{
			this.stage.focus = autoFocusObject;
		}
		
		protected function isSuperClass(classObj:*):String
		{
			var className:String = getQualifiedSuperclassName(classObj).split("::").pop();
			return className;
		}
		
		protected function getClass(classObj:*):Class
		{
			var className:String = getQualifiedClassName(classObj).split("::").join(".");
			return getDefinitionByName(className) as Class;
		}
		
		protected function addListBox(index:int):void
		{
			component = getComponent(index);
		}
		
		protected function addCheckBox(index:int):void
		{
			component = getComponent(index);
		}
		
		protected function addRadioButton(index:int):void
		{
			component = getComponent(index);
		}
		
		protected function addButton(index:int):void
		{
			component = getComponent(index);
		}
		
		protected function addTextBox(index:int):void
		{
			component = getComponent(index);
		}
		
		public function transitionIn():void
		{
		}
		
		public function transitionOut():void
		{
		}
		
		protected function getComponent(index:int):PlaceHolder
		{
			return holder.getChildAt(index) as PlaceHolder;
		}
		
		protected function onComponentFocusIn(event:Event):void
		{
			autoFocusObject = InteractiveObject(event.target) as InteractiveObject;
			onSetFocusInSkinHandler(autoFocusObject);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
		}
		
		protected function onComponentFocusOut(event:Event):void
		{
			autoFocusObject = InteractiveObject(event.target) as InteractiveObject;
			onSetFocusOutSkinHandler(autoFocusObject);
			
			if(this.stage)
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
		}
		
		protected function onListBoxEpandHandler(event:Event):void
		{
			var ln:int = holder.numChildren;
			
			for(var i:int = 0;i < ln;i++)
			{
				var t:* = holder.getChildAt(i);
				
				if(isSuperClass(t) === 'ListBox')
				{
					var k:ListBox = t as ListBox;
					
					if(k.isExpanded === true && k !== event.target)
					{
						k.collapseList();
					}
				}
			}
		}
		
		protected function onListBoxCollapseHandler(event:Event):void
		{
			//trace('List Collapsed')
		}
		
		protected function keyDownHandler(keyBoardEvent:KeyboardEvent):void
		{
			if(keyBoardEvent.keyCode == Keyboard.ENTER)
			{
				send();
			}
		
		}
		
		public function reset():void
		{
			var num:int = holder.numChildren;
			var i:int = 0;
			
			while(i < num)
			{
				var mc:IForm = holder.getChildAt(i) as IForm;
				
				if(mc)
					mc.reset();
				++i;
			}
			
			dispatchEvent(new Event(FORM_RESET,true));
		}
		
		public function send():void
		{
			resetComparisonFieldArray();
			
			var num:int = holder.numChildren;
			var mc:IForm;
			var i:int = 0;
			
			while(i < num)
			{
				mc = holder.getChildAt(i) as IForm;
				
				if(mc)
					if(mc.mandatory)
						addEmailAndPasswordFieldsToArray(mc);
				++i;
			}
			
			i = 0;
			
			while(i < num)
			{
				mc = holder.getChildAt(i) as IForm;
				
				if(mc)
				{
					if(mc.mandatory)
					{
						validateIForms(mc);
					}
				}
				
				++i;
			}
			
			if(isFormValidationSuccess)
				validateIfConfirmFieldAvailable();
			
			if(isFormValidationSuccess)
				validateDateMonthYearStringLength();
			
			if(isFormValidationSuccess)
				checkDateChars();
			
			if(isFormValidationSuccess)
			{
				onFieldValidationSucces();
			}
			else if(!isFormValidationSuccess)
			{
				isFormValidationSuccess = true;
			}
		}
		
		protected function addEmailAndPasswordFieldsToArray(componentClip:IForm):void
		{
			var data:Object = componentClip.getData();
			var dataValue:String = data.fieldValue;
			var type:String = data.type;
			
			if(type.toUpperCase() === TEXT_TYPE_EMAIL)
			{
				if(!_fieldCamparisonArray[EmailArrayIndex])
					_fieldCamparisonArray[EmailArrayIndex] = new Array();
				_fieldCamparisonArray[EmailArrayIndex].push({value:dataValue,clip:componentClip});
			}
			
			if(type.toUpperCase() === TEXT_TYPE_PASSWORD)
			{
				if(!_fieldCamparisonArray[PasswordArrayIndex])
					_fieldCamparisonArray[PasswordArrayIndex] = new Array();
				_fieldCamparisonArray[PasswordArrayIndex].push({value:dataValue,clip:componentClip});
			}
		
		}
		
		protected function validateIForms(componentClip:IForm):void
		{
			var data:Object = componentClip.getData();
			var value:String = data.fieldValue;
			var type:String = data.type;
			var name:String = data.name;
			
			if(!StringUtils.hasText(value))
			{
				showFieldErrorMessage(InteractiveObject(componentClip));
			}
			else if(type.toUpperCase() === TEXT_TYPE_EMAIL)
			{
				if(!validateEmail(value))
				{
					showEmailError(InteractiveObject(componentClip));
				}
			}
		/*else if(type.toUpperCase() ==='INPUT')
		   {
		   if(InputField(componentClip).getName=='Month' || InputField(componentClip).getName=='Year' || InputField(componentClip).getName=='Date')
		   {
		   validateDateMonthYearStringLength(InputField(componentClip));
		   }
		
		 }*/
		}
		
		protected function validateDateMonthYearStringLength():void
		{
			var monthLabels:Array = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
			
			var num:int = holder.numChildren;
			var mc:IForm;
			var i:int = 0;
			
			var month:int;
			var date:int;
			var year:int;
			var array:Array = [];
			
			while(i < num)
			{
				mc = holder.getChildAt(i) as IForm;
				
				if(mc)
				{
					if(mc.mandatory)
					{
						var data:Object = mc.getData();
						var value:String = data.fieldValue;
						var type:String = data.type;
						
						if(type.toUpperCase() === 'INPUT')
						{
							switch(InputField(mc).getName.toString().toUpperCase())
							{
								case 'MONTH':
									month = int(value);
									array.push(InputField(mc));
									break;
								
								case 'DATE':
									date = int(value);
									array.push(InputField(mc));
									break;
								
								case 'YEAR':
									year = int(value);
									array.push(InputField(mc));
									break;
							}
						}
						
					}
				}
				
				++i;
			}
			
			i = 0;
			num = array.length;
			
			if(num > 1)
			{
				
				var userDate:Date = new Date(Number(year),Number(month - 1),Number(date));
				var todaysDate:Date = new Date();
				
				if(monthLabels[userDate.getMonth().toString()] !== monthLabels[month - 1] || userDate.getTime() > todaysDate.getTime())
				{
					while(i < num)
					{
						array[i].reset();
						isFormValidationSuccess = false;
						onErrorSkinHandler(array[i] as InteractiveObject);
						++i;
					}
					
					dispatchEvent(new Event(FORM_INVALID_DATE_ERROR,true));
				}
				else
				{
					isFormValidationSuccess = true;
					
				}
				
			}
		
		}
		
		protected function checkDateChars():void
		{
			var num:int = holder.numChildren;
			var mc:IForm;
			var i:int = 0;
			
			while(i < num)
			{
				mc = holder.getChildAt(i) as IForm;
				
				if(mc)
				{
					if(mc.mandatory)
					{
						var data:Object = mc.getData();
						var value:String = data.fieldValue;
						var type:String = data.type;
						
						if(type.toUpperCase() === 'INPUT')
						{
							switch(InputField(mc).getName.toString().toUpperCase())
							{
								case 'MONTH':
									if(String(value).length < 2)
										showFieldErrorMessage(InteractiveObject(mc));
									break;
								
								case 'DATE':
									if(String(value).length < 2)
										showFieldErrorMessage(InteractiveObject(mc));
									break;
								
								case 'YEAR':
									if(String(value).length < 4)
										showFieldErrorMessage(InteractiveObject(mc));
									break;
							}
						}
						
					}
				}
				
				++i;
			}
		}
		
		protected function validateIfConfirmFieldAvailable():void
		{
			var length:int = _fieldCamparisonArray.length;
			var i:int = 0;
			
			while(i < length)
			{
				if(_fieldCamparisonArray[i])
				{
					if(_fieldCamparisonArray[i].length > 1)
					{
						if(!matchString(i))
						{
							showComparisonError(_fieldCamparisonArray[i][0].clip,_fieldCamparisonArray[i][1].clip);
						}
					}
				}
				
				++i;
			}
		
			//resetComparisonFieldArray();
		}
		
		private function resetComparisonFieldArray():void
		{
			var iLength:int = _fieldCamparisonArray.length;
			var i:int = 0;
			
			while(i < iLength)
			{
				_fieldCamparisonArray[i] = [];
				++i;
			}
		
		}
		
		private function matchString(index:int):Boolean
		{
			var iLength:int = _fieldCamparisonArray[index].length;
			
			var found:Boolean = false;
			var string:String = null;
			
			for(var j:int = 0;j < iLength;++j)
			{
				if(!_fieldCamparisonArray[index][j].value)
					return false;
				
				if(string === _fieldCamparisonArray[index][j].value.toString())
				{
					found = true;
				}
				else
				{
					string = _fieldCamparisonArray[index][j].value.toString();
				}
			}
			
			return found;
		}
		
		protected function showFieldErrorMessage(componentClip:InteractiveObject):void
		{
			isFormValidationSuccess = false;
			onErrorSkinHandler(componentClip);
			dispatchEvent(new Event(FORM_MISSING_FIELDS_ERROR,true));
		}
		
		protected function showEmailError(componentClip:InteractiveObject):void
		{
			isFormValidationSuccess = false;
			onErrorSkinHandler(componentClip);
			dispatchEvent(new Event(FORM_EMAIL_VALIDATION_ERROR,true));
		}
		
		protected function validateEmail(value:String):Boolean
		{
			var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var result:Object = pattern.exec(value);
			
			if(result === null)
				return false;
			
			return true;
		}
		
		private function showComparisonError(componentClip1:IForm,componentClip2:IForm):void
		{
			var type:String = (componentClip1.getData().type).toUpperCase();
			
			switch(type)
			{
				case TEXT_TYPE_EMAIL:
					showEmailCamparisonError(InteractiveObject(componentClip2));
					break;
				
				case TEXT_TYPE_PASSWORD:
					showPasswordCamparisonError(InteractiveObject(componentClip2));
					break;
			}
		}
		
		protected function showPasswordCamparisonError(componentClip2:InteractiveObject):void
		{
			isFormValidationSuccess = false;
			onErrorSkinHandler(componentClip2);
			dispatchEvent(new Event(FORM_PASSWORD_COMPARISON_ERROR,true));
		}
		
		protected function showEmailCamparisonError(componentClip2:InteractiveObject):void
		{
			isFormValidationSuccess = false;
			onErrorSkinHandler(componentClip2);
			dispatchEvent(new Event(FORM_EMAIL_COMPARISON_ERROR,true));
		}
		
		protected function onFieldValidationSucces():void
		{
			if(dataVariable)
				dataVariable = null;
			dataVariable = new URLVariables();
			
			var num:int = holder.numChildren;
			var mc:IForm;
			var i:int = 0;
			
			while(i < num)
			{
				mc = holder.getChildAt(i) as IForm;
				
				if(mc)
				{
					if(mc.mandatory)
					{
						var data:Object = mc.getData();
						var fieldName:String = data.fieldName;
						var fieldValue:String = data.fieldValue;
						(fieldName) ? dataVariable[fieldName] = fieldValue : dataVariable[data.name] = fieldValue;
					}
				}
				
				++i;
			}
			
			//trace('form validation  >>>>>>>>>>>>  SUCCESS***');
			
			isFormValidationSuccess = true;
			dispatchEvent(new Event(FORM_VALIDATION_SUCCESS,true));
		}
		
		public function onSetFocusInSkinHandler(target:InteractiveObject):void
		{
			this.stage.focus = target;
		}
		
		public function onSetFocusOutSkinHandler(target:InteractiveObject):void
		{
		};
		
		public function onDisableSkinHandler(target:InteractiveObject):void
		{
		};
		
		public function onEnableSkinHandler(target:InteractiveObject):void
		{
			(target as IForm).onEnableSkinHandler(target);
		}
		
		public function onErrorSkinHandler(target:InteractiveObject):void
		{
			(target as IForm).onErrorSkinHandler(target);
		}
		
		public function get mandatory():Boolean
		{
			return _mandatory
		};
		
		public function set mandatory(value:Boolean):void
		{
			_mandatory = value
		};
		
		public function set holder(value:MovieClip):void
		{
			_holder = value;
		}
		
		public function get holder():MovieClip
		{
			return _holder;
		}
		
		public function set id(index:int):void
		{
			_id = index;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function getData():Object
		{
			return dataVariable;
		}
		
		override public function set name(value:String):void
		{
			_name = value;
		}
		
		override public function get name():String
		{
			return _name;
		}
		
		public function set fieldName(value:String):void
		{
		}
		
		public function get fieldName():String
		{
			return null;
		}
		
		public function set displayData(value:XMLList):void
		{
			_displayDataXmlList = value;
		}
		
		public function get displayData():XMLList
		{
			return _displayDataXmlList;
		}
		
		public function set fieldValue(value:String):void
		{
		}
		
		public function get fieldValue():String
		{
			return null;
		}
		
		protected function removeComponent(index:int):void
		{
			holder.removeChildAt(index)
		}
	}
}