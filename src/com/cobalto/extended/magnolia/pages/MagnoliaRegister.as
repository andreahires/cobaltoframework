package com.cobalto.extended.magnolia.pages
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.components.Forms.Form;
	import com.cobalto.components.buttons.ListButton;
	import com.cobalto.components.window.Window;
	import com.cobalto.extended.magnolia.MagnoliaSiteFacade;
	import com.cobalto.extended.magnolia.pages.MagnoliaRegister;
	import com.cobalto.extended.magnolia.view.components.MagnoliaPage;
	import com.cobalto.text.HtmlTextBuilder;
	import com.cobalto.text.TextBuilder;
	import com.cobalto.utils.UrlLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	

	
	public class MagnoliaRegister extends MagnoliaPage
	{
		protected var contentHolder:Sprite;
		protected var registerHolder:Sprite;
		protected var registrationForm:Form;
		protected var compulsoryText:TextBuilder;
		protected var statusMessage:TextBuilder;
		protected var loader:UrlLoader;
		protected var action:String;
		
		private static const FAILED:String = 'FAILED';
		private static const OK:String = 'OK';
		
		public function MagnoliaRegister()
		{
			super();	
		}
		
		override public function build(pageData:Object=null):void
		{
			super.build(pageData);
	
			contentHolder = new Sprite();
			addChild(contentHolder);
			
			registerHolder = new Sprite();
			registerHolder.tabEnabled = false;
			registerHolder.tabChildren = true;
			
			action = ApplicationFacade.baseURL + _xml.properties.action;
			
			buildForm();
			
			organizeItems();
		}
		
		protected function buildForm():void
		{
			registrationForm = new Form('RegistrationForm',_xml.properties.formlabeldata);
			registrationForm.build();
			
			addFormListeners();
		}
		
		protected function addFormListeners():void
		{
			registrationForm.addEventListener(Form.FORM_VALIDATION_SUCCESS,onFormValidationSuccess);
			registrationForm.addEventListener(Form.FORM_EMAIL_COMPARISON_ERROR,onEmailComparisonError);
			registrationForm.addEventListener(Form.FORM_EMAIL_VALIDATION_ERROR,onEmailValidationError);
			registrationForm.addEventListener(Form.FORM_MISSING_FIELDS_ERROR,onMissingFieldsError);
			registrationForm.addEventListener(Form.FORM_PASSWORD_COMPARISON_ERROR,onPasswordComparisonError);
			registrationForm.addEventListener(Form.FORM_RESET,onFormReset);
			registrationForm.addEventListener(Form.FORM_INVALID_DATE_ERROR,onDateError);
			registrationForm.addEventListener(Event.ADDED_TO_STAGE,onFormAdded);
			registrationForm.transitionIn();
			registerHolder.addChild(registrationForm);
		}
		
		protected function onFormAdded(event:Event):void
		{
			registrationForm.setAutoFocus()
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
			dispatchRegisterRequest();
		}
		
		override public function getFormData():Object
		{
			
			return null; 
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
		
		protected function onEmailComparisonError(event:Event):void
		{
			createMessageWithStatus(ApplicationFacade.commonLabelXML.properties.mailComparisonError);
		}
		
		protected function onMissingFieldsError(event:Event):void
		{
			createMessageWithStatus(ApplicationFacade.commonLabelXML.properties.emptyFields);
		}
		
		protected function onPasswordComparisonError(event:Event):void
		{
			createMessageWithStatus(ApplicationFacade.commonLabelXML.properties.passwordComparisonError);
		}
		
		protected function onEmailValidationError(event:Event):void
		{
			createMessageWithStatus(ApplicationFacade.commonLabelXML.properties.mailValidationError);
		}
		
		protected function onFormReset(event:Event):void
		{
			createMessageWithStatus('');
		}
		
		protected function onDateError(event:Event):void
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
			registerHolder.mouseEnabled = false;
			registerHolder.mouseChildren = false;
		}
		
		public function deFreezeForm():void
		{
			registerHolder.mouseEnabled = true;
			registerHolder.mouseChildren = true;
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