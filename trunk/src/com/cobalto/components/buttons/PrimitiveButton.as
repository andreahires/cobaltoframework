package com.cobalto.components.buttons
{
	
	import com.cobalto.display.Drawer;
	import com.cobalto.utils.MemoryUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/*
	   The class is useful to create a simple button
	   the button create by itself a hitArea movieclip of 100X100 pixel
	   the clickable area adapt itself when the skin properties is set on the skin dimensions
	   it's possible to set the start width and height of the hitarea throught the contructor optional params
	 */
	
	public class PrimitiveButton extends Sprite
	{
		// *** the id of the button
		private var _id:int;
		protected var _hitArea:PrimitiveHitArea;
		protected var _skin:DisplayObject;
		private var _buttonWidth:int;
		private var _buttonHeight:int;
		protected var _state:String;
		
		protected var activated:Boolean = false;
		private var _isActivable:Boolean = false;
		
		public static const BUTTON_CLICKED:String = "ButtonClicked";
		public static const BUTTON_OVER:String = "ButtonOver";
		public static const BUTTON_OUT:String = "ButtonOut";
		public static const BUTTON_RELEASE:String = "ButtonRelease";
		public static const BUTTON_UP_OUTSIDE:String = "ButtonUpOutside";
		public static const BUTTON_ACTIVATED:String = "ButtonActivated";
		public static const BUTTON_DEACTIVATED:String = "ButtonDeactivated";
		
		//*** states 
		public static const STATE_INIT:String = "initState";
		public static const STATE_BUILD:String = "buildState";
		public static const STATE_TRANSITION_IN_COMPLETE:String = "transitionInCompleteState";
		public static const STATE_TRANSITION_OUT_COMPLETE:String = "transitionOutCompleteState";
		
		//** @param w and h: optional dimension of the hitarea
		
		public function PrimitiveButton(w:int=0,h:int=0)
		{
			
			super();
			
			_buttonWidth = w;
			_buttonHeight = h;
			_state = STATE_INIT;
			drawHitArea();
			
			addEventListener(Event.REMOVED_FROM_STAGE,destroy);
		}
		
		//** create the hitArea
		protected function drawHitArea():void
		{
			//** the hitArea is a MovieClip because need to contain the id property
			_hitArea = new PrimitiveHitArea();
			
			//** if any width and height is specified it create the default rect with drawer (100x100 px)
			if(_buttonWidth == 0 && _buttonHeight == 0)
				Drawer.DrawRect(_hitArea);
			else
				Drawer.DrawRect(_hitArea,_buttonWidth,_buttonHeight);
			
			//** hide the hitArea
			showHitArea(false);
			
			// add to the displayList
			addChild(_hitArea);
			
			configureHandlers();
		
		}
		
		//*** add the interactive listener to the hitArea
		protected function configureHandlers():void
		{
			_hitArea.mouseChildren = false;
			_hitArea.buttonMode = true;
			
			_hitArea.addEventListener(MouseEvent.MOUSE_DOWN,clicked,false,0,true);
			_hitArea.addEventListener(MouseEvent.MOUSE_OVER,over,false,0,true);
			_hitArea.addEventListener(MouseEvent.MOUSE_OUT,out,false,0,true);
		
		}
		
		//*** on the click of the hitArea the Primitive Button dispatch the BUTTON_CLICKED EVENT
		//*** it always bubble through the display list
		//*** if is activable dispatch activated event and disable the btn mode
		protected function clicked(e:MouseEvent):void
		{
			var ev:Event
			
			//if activable run activate animation and dispatch event
			if(this.isActivable == true && activated == false)
			{
				ev = new Event(BUTTON_ACTIVATED,true);
				e.target.dispatchEvent(ev);
				
				activated = true;
				
				// disable button mode
				this.enable = false;
			}
			
			if(this.isActivable == false)
			{
				ev = new Event(BUTTON_CLICKED,true);
				e.target.dispatchEvent(ev);
				
			}
			
			//** listen when the mouse is released
			if(stage)
				stage.addEventListener(MouseEvent.MOUSE_UP,up,true,0,false);
		
		}
		
		//**this function is used to deactivate the button
		public function deactivate():void
		{
			// enable button mode
			this.enable = true;
			
			dispatchEvent(new Event(BUTTON_DEACTIVATED,true));
			activated = false;
		}
		
		//** check when the mouse is up
		protected function up(e:MouseEvent):void
		{
			
			if(e.target != _hitArea)
			{
				//** dispatch the onReleaseOutside case when the target is different from the hitArea itself
				var ev:Event = new Event(BUTTON_UP_OUTSIDE,true);
				e.target.dispatchEvent(ev);
			}
			
			if(stage)
				stage.removeEventListener(MouseEvent.MOUSE_UP,up);
		
		}
		
		//*** dispatch button release
		private function release(e:MouseEvent):void
		{
			var ev:Event = new Event(BUTTON_RELEASE,true);
			e.target.dispatchEvent(ev);
		}
		
		//*** over handler
		protected function over(e:MouseEvent):void
		{
			var ev:Event = new Event(BUTTON_OVER,true);
			e.target.dispatchEvent(ev);
		
		}
		
		//** outHandler
		protected function out(e:MouseEvent):void
		{
			var ev:Event = new Event(BUTTON_OUT,true);
			e.target.dispatchEvent(ev);
		}
		
		//*** enable or disable the button
		public function set enable(state:Boolean):void
		{
			_hitArea.mouseEnabled = state;
			//mouseChildren = true;
		}
		
		//** hide or show the hitArea for debugging purpose
		public function showHitArea(visibility:Boolean):void
		{
			if(visibility == true)
				_hitArea.alpha = 0.6;
			else
				_hitArea.alpha = 0;
		}
		
		//*** set the skin of the button
		// *** the skin is usually a Sprite that contains textFields and graphics
		public function set skin(btSkin:DisplayObject):void
		{
			//** if the skin already exist it remove the old one
			if(_skin)
			{
				removeChild(skin);
				_skin = null;
			}
			
			_skin = btSkin;
			// *** set the hitArea dimensions and position to the skin's ones
			_hitArea.width = _skin.width;
			_hitArea.height = _skin.height;
			_hitArea.x = _skin.x;
			_hitArea.y = _skin.y;
			
			//*** add to the display list under the hitArea
			addChildAt(_skin,0);
			
			_state = STATE_BUILD;
		}
		
		// ** get the id of the primitiveButton through the hitArea
		public function get id():int
		{
			return _hitArea.id;
		}
		
		// ** set the id of the primitiveButton, stored on the hitArea
		public function set id(n:int):void
		{
			_hitArea.id = n;
		}
		
		public function get hit():Sprite
		{
			return _hitArea;
		}
		
		public function get skin():DisplayObject
		{
			return _skin;
		}
		
		//This can be used to check if the button is activated
		public function get isActivated():Boolean
		{
			return activated;
		}
		
		public function get isActivable():Boolean
		{
			return _isActivable;
		}
		
		public function set isActivable(value:Boolean):void
		{
			_isActivable = value;
		}
		
		public function destroy(e:Event=null):void
		{
			
			removeEventListener(Event.REMOVED_FROM_STAGE,destroy);
			
			if(_hitArea)
			{
				
				_hitArea.removeEventListener(MouseEvent.MOUSE_DOWN,clicked);
				_hitArea.removeEventListener(MouseEvent.MOUSE_OVER,over);
				_hitArea.removeEventListener(MouseEvent.MOUSE_OUT,out);
				MemoryUtils.removeFromStage(_hitArea);
			}
			
			if(stage)
			{
			}
			
			MemoryUtils.removeFromStage(_skin);
			_state = null;
		
		}
	}
}