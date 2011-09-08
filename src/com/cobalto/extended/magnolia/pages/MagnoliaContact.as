package com.cobalto.extended.magnolia.pages
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.components.Forms.Form;
	import com.cobalto.extended.magnolia.view.components.MagnoliaPage;
	import com.cobalto.text.HtmlTextBuilder;
	import com.cobalto.text.TextBuilder;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.greensock.TweenLite;
	
	public class MagnoliaContact extends MagnoliaPage
	{
		protected var contentHolder:Sprite;
		protected var contactHolder:Sprite;
		protected var contactForm: Form;

		protected var compulsoryText:TextBuilder;
		protected var statusMessage:HtmlTextBuilder
		
		private static const TRUE:String = 'TRUE';
		private static const FALSE:String = 'FALSE';
		
		public function MagnoliaContact()
		{
			super();
		}
		
		override public function build(pageData:Object=null):void
		{
			super.build(pageData);
			contentHolder = new Sprite();
			
			contactHolder = new Sprite();
			contactHolder.tabEnabled = false;
			contactHolder.tabChildren = true;

			buildForm();
			
			buildCompulsoryText();
			organizeItems();
		}
		
		protected function buildForm():void
		{
			contactForm = new Form('ContactForm', _xml.properties.formlabeldata);
			contactForm.build();
			addFormListeners();
		}
		protected function addFormListeners():void
		{
			contactForm.addEventListener(Form.FORM_VALIDATION_SUCCESS,onFormValidationSuccess);
			contactForm.addEventListener(Form.FORM_EMAIL_COMPARISON_ERROR,onEmailComparisonError);
			contactForm.addEventListener(Form.FORM_EMAIL_VALIDATION_ERROR,onEmailValidationError);
			contactForm.addEventListener(Form.FORM_MISSING_FIELDS_ERROR,onMissingFieldsError);
			contactForm.addEventListener(Form.FORM_PASSWORD_COMPARISON_ERROR,onPasswordComparisonError);
			contactForm.addEventListener(Form.FORM_RESET,onFormReset);
			contactForm.addEventListener(Form.FORM_INVALID_DATE_ERROR,onDateError);
			contactForm.addEventListener(Event.ADDED_TO_STAGE,onFormAdded);
			contactForm.transitionIn();
			contactForm.y = 80;
			contactHolder.addChild(contactForm);
		}
		protected function onFormAdded(event:Event):void
		{
			contactForm.setAutoFocus();
		}
		
		protected function createMessageWithStatus(Status:String):void
		{
			
		}
		
		protected function buildCompulsoryText():void
		{
			
		}
		protected function createMandatory():void
		{
			
		}
		
		protected function onFormValidationSuccess(event:Event):void
		{
			freezeForm();
			createMessageWithStatus(ApplicationFacade.commonLabelXML.properties.sendData);
			dispatchContactRequest();
		}
		
		override public function showServerResponse(serverResponse:Object):void
		{
			switch(serverResponse.toString().toUpperCase())
			{
				case 'INIT':
					init();
					break;
				case 'PROGRESS':
					onProgress();
					break;
				case 'SECURITYERROR':
					securityError();
					break;
				case 'HTTPSTATUS':
					httpStatus();
					break;
				case 'IOERROR':
					ioError();
					break;
				default:
					status(String(serverResponse.result.toString()), serverResponse.errors);
					break;
			}
			
		}
		
		private function onEmailComparisonError(event:Event):void
		{
			createMessageWithStatus(ApplicationFacade.commonLabelXML.properties.mailComparisonError);
		}
		
		private function onMissingFieldsError(event:Event):void
		{
			createMessageWithStatus(ApplicationFacade.commonLabelXML.properties.emptyFields);
		}
		
		private function onPasswordComparisonError(event:Event):void
		{
			createMessageWithStatus(ApplicationFacade.commonLabelXML.properties.passwordComparisonError);
		}
		
		private function onEmailValidationError(event:Event):void
		{
			createMessageWithStatus(ApplicationFacade.commonLabelXML.properties.mailValidationError);
		}
		
		private function onFormReset(event:Event):void
		{
			createMessageWithStatus('');
		}
		
		private function onDateError(event:Event):void
		{
			createMessageWithStatus(ApplicationFacade.commonLabelXML.properties.InvalidDate);
		}
		
		
		protected function init():void
		{
			freezeForm();
		}
		
		protected function onProgress():void
		{
			
		}
		
		protected function onComplete():void
		{
			
		}
		
		protected function securityError():void
		{
			createMessageWithStatus(ApplicationFacade.commonLabelXML.properties.generalError);
			deFreezeForm();
		}
		
		protected function httpStatus():void
		{
		}
		
		protected function ioError():void
		{
			createMessageWithStatus(ApplicationFacade.commonLabelXML.properties.generalError);
			deFreezeForm();
		}
		
		public function freezeForm():void
		{
			contactHolder.mouseEnabled = false;
			contactHolder.mouseChildren = false;
		}
		
		public function deFreezeForm():void
		{
			contactHolder.mouseEnabled = true;
			contactHolder.mouseChildren = true;
		}
		
		protected function status(Result:String,ErrorCodes:XMLList=null):void
		{
			
		}
		
		protected function showErrorOnFields(ErrorCodes:XMLList):void
		{
			
		}
		
		override protected function transitionInTween():void
		{
			super.transitionInTween();
		}
		
		override protected function transitionOutTween():void
		{
			super.transitionOutTween();
		}
		
		override public function organizeItems():void
		{
			super.organizeItems();
		
		}
	
	}
}