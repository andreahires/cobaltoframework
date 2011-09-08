package com.cobalto.components.textarea
{
	import com.cobalto.components.InputField.InputField;
	import com.cobalto.components.core.IForm;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;

	public class TextArea extends InputField implements IForm
	{
		public function TextArea(textString:String, name:String, width:int=0, height:int=0)
		{
			super(textString, name, width, height);
		}
	}
}