package com.cobalto.components.video
{
	
	//import DesignBuilder.Drawer;
	
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.display.Drawer;
	import com.cobalto.utils.AssetManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.SoundTransform;
	
	import gs.*;
	import com.greensock.easing.*;
	
	//import utils.AssetManager;
	//import utils.ToolTip;
	
	public class FlvPlayer extends FlvViewer
	{
		
	    
		
		private var _playerContainer:Sprite;
		private var _playerBarContainer:Sprite;
		private var _playPause:MovieClip;
		private var _barBackground:Sprite;
		private var _barBuffer:Sprite;
		private var _barReproduction:Sprite;
		private var _barTexture:Sprite;
		private var _maskBackground:Sprite;
		private var _maskBuffer:Sprite;
		private var _maskReproduction:Sprite;
		private var _maskTexture:Sprite;
		private var _reproductionScroll:PrimitiveButton;
		private var _playBtn:PrimitiveButton;
		private var _resizeBarEasing:Function;
		private var _resizeBarEasingTime:Number;
		private var _controllerYPos:Number;
		private var _controllerXPos:Number;
		private var _controllerWidth:Number;
		private var _volume:Number;
		private var _sndTransform:SoundTransform;
		private var _nextX:int;
		
		private var _showVolume:Boolean;
		private var _volumeIcon:MovieClip;
		
		private var _showFullScreen:Boolean;
		private var _fullScreenIcon:MovieClip;
		
		private var _superReproductionReady:Boolean;
		private var _playerBuilt:Boolean;
		//private var _toolTip:ToolTip;
		
		public static const CONNECTION_INIT:String = FlvViewer.CONNECTION_INIT;
		public static const METADATA_INIT:String = FlvViewer.METADATA_INIT;
		public static const REPRODUCTION_CHANGE_SEEK:String = FlvViewer.REPRODUCTION_CHANGE_SEEK;
		public static const REPRODUCTION_END:String = FlvViewer.REPRODUCTION_END;
		public static const BUFFER_IS_FULL:String = FlvViewer.BUFFER_IS_FULL;
		public static const BUFFER_IS_EMPTY:String = FlvViewer.BUFFER_IS_EMPTY;
		public static const BUFFER_PERCENT:String = FlvViewer.BUFFER_PERCENT;
		public static const CUE_POINT_FOUND:String = FlvViewer.CUE_POINT_FOUND;
		public static const VIDEO_START:String = FlvViewer.VIDEO_START;
		public static const REPRODUCTION_READY:String = 'PlayerBuiltReproductionReady';
		public static const PLAYER_BUILT:String = 'PlayerBuilt';
		public static const GO_FULLSCREEN:String = 'GoFullScreen';
		
				
		public function FlvPlayer():void
		{
			
			super();
			
		}
		
		public function initPlayer(flvSource:String, bufferTime:Number):void
		{
			activateListener();
			init(flvSource, bufferTime);
			setResizeBarTime(1);
			setResizeBarEasing(Expo.easeOut);
		}
		private function activateListener():void
		{
			addEventListener(FlvViewer.REPRODUCTION_READY,onReproductionReady, false, 0, true);
			addEventListener(FlvViewer.METADATA_INIT,buildPlayer, false, 0, true);
			addEventListener(FlvViewer.REPRODUCTION_CHANGE_SEEK,resumeUpdate, false, 0, true);
		}
		private function onReproductionReady(e:Event):void
		{
			removeEventListener(FlvViewer.REPRODUCTION_READY,onReproductionReady);
			_superReproductionReady = true;
			if(_playerBuilt)dispatchReproductionPlayerReady();
			
			if(showVolume)
			{
				if(!volume)volume = .5;
				if(!_sndTransform) _sndTransform = new SoundTransform(volume);
				_netStream.soundTransform=_sndTransform;
				_volumeIcon.volumeDrag.scaleX = (100*volume)/100;
			}	
		}
		private function buildPlayer(e:Event):void
		{
			removeEventListener(FlvViewer.METADATA_INIT,buildPlayer);
			
			_playerContainer = new Sprite();
			if(!controllerYPosition)_playerContainer.y = Math.round(_video.height + 10);
			if(controllerYPosition)_playerContainer.y = controllerYPosition;
			
			if(!controllerXPosition)_playerContainer.x = 0;
			if(controllerXPosition)_playerContainer.x = controllerXPosition;
			
			// 
			buildPlayerItems();
			buildPlayerBtn();
			activatePlayerControl();
			
			_playerContainer.addChild(_playerBarContainer);
			_playerContainer.addChild(_playPause);
			
			if(showVolume)_playerContainer.addChild(_volumeIcon);
			if(showFullScreen)_playerContainer.addChild(_fullScreenIcon);
			
			addChild(_playerContainer);
			
			dispatchPlayerBuilt();
			activateTimer(true);
		}
		
		private function buildPlayerItems():void
		{
			
			_playerBarContainer = new Sprite();
			
			if(showFullScreen)
			{
				_fullScreenIcon =AssetManager.getItem('FullScreenIcon') as MovieClip;
				_fullScreenIcon.buttonMode = true;
				_fullScreenIcon.mouseEnabled=true;
				_fullScreenIcon.mouseChildren=false;
				_fullScreenIcon.y = -Math.round(_fullScreenIcon.height*.5);
				_nextX += Math.round(_fullScreenIcon.width+10);	
			}
			
			if(showVolume)
			{
				_volumeIcon =AssetManager.getItem('VolumeIcon') as MovieClip;
				_volumeIcon.buttonMode = true;
				_volumeIcon.mouseEnabled=true;
				_volumeIcon.mouseChildren=false;
				_volumeIcon.x=_nextX;
				_volumeIcon.y = -Math.round(_volumeIcon.height*.5);
				_nextX += Math.round(_volumeIcon.width+10);	
			}
			
			_playPause = AssetManager.getItem('PlayPause');
			_playPause.stop();
			_playPause.x = _nextX;
			
			_playerBarContainer.x = Math.round((_playPause.x+_playPause.width) + 10);
			
			createProgressElements();
			
		}
		private function createProgressElements():void
		{
			
			if(_maskBackground)
			{
				_playerBarContainer.removeChild(_maskBackground);
				_maskBackground=null;
			}
			
			if(_maskReproduction)
			{
				_playerBarContainer.removeChild(_maskReproduction);
				_maskReproduction = null;
			}
			
			if(_maskTexture)
			{
				_playerBarContainer.removeChild(_maskTexture);
				_maskTexture = null;
			}
			
			if(_barBackground)
			{
				_playerBarContainer.removeChild(_barBackground);
				_barBackground = null;
			}
			
			if(_barBuffer)
			{
				_playerBarContainer.removeChild(_barBuffer);
				_barBuffer = null;
			}
			if(_barReproduction)
			{
				_playerBarContainer.removeChild(_barReproduction);
				_barReproduction=null;
			}
			if(_barTexture)
			{
				_playerBarContainer.removeChild(_barTexture);
				_barTexture=null;
			}
			if(_maskBuffer)
			{
				_playerBarContainer.removeChild(_maskBuffer);
				_maskBuffer=null;
			}		
			
			_barBackground = AssetManager.getItem('BarBackground');
			_barBuffer = AssetManager.getItem('BarBuffer');
			_barReproduction = AssetManager.getItem('BarReproduction');
			_barTexture = AssetManager.getItem('BarTexture');
			
			_maskBackground = new Sprite();
			_maskBuffer = new Sprite();
			_maskReproduction = new Sprite();
			_maskTexture = new Sprite();
			
			if(!controllerWidth)controllerWidth=_video.width;
			Drawer.DrawRect(_maskBackground, Math.round(controllerWidth - _playerBarContainer.x), _barBackground.height, 0xFF0000);
			Drawer.DrawRect(_maskBuffer, Math.round(controllerWidth - _playerBarContainer.x), _barBuffer.height, 0xFF0000);
			Drawer.DrawRect(_maskReproduction, Math.round(controllerWidth - _playerBarContainer.x), _barReproduction.height, 0xFF0000);
			Drawer.DrawRect(_maskTexture, Math.round(controllerWidth - _playerBarContainer.x), _barTexture.height, 0xFF0000);
			
			_barBackground.mask = _maskBackground;
			_barBuffer.mask = _maskBuffer;
			_barReproduction.mask = _maskReproduction;
			_barTexture.mask = _maskTexture;
			
			_playerBarContainer.addChild(_maskBackground);
			_playerBarContainer.addChild(_maskReproduction);
			_playerBarContainer.addChild(_maskTexture);
			
			_playerBarContainer.addChild(_barBackground);
			_playerBarContainer.addChild(_barBuffer);
			_playerBarContainer.addChild(_barReproduction);
			_playerBarContainer.addChild(_barTexture);
			_playerBarContainer.addChild(_maskBuffer);
		
		}
		private function buildPlayerBtn():void
		{
			_playBtn = new PrimitiveButton(_playPause.width, _playPause.height);
			_reproductionScroll = new PrimitiveButton(_maskBuffer.width, _maskBuffer.height);
			_playPause.addChild(_playBtn);
			_playerBarContainer.addChild(_reproductionScroll);
		}
		
		private function activatePlayerControl():void
		{
			_playBtn.addEventListener(PrimitiveButton.BUTTON_CLICKED, onPlayPauseClicked, false, 0, true);
			_playBtn.addEventListener(MouseEvent.MOUSE_OVER,function(e:Event):void{showToolTip(_playBtn,'Play / Pause')});
			_playBtn.addEventListener(MouseEvent.MOUSE_OUT,function(e:Event):void{hideToolTip()});
				
			if(showVolume)
			{
				_volumeIcon.addEventListener(MouseEvent.MOUSE_DOWN,onVolumeDown);
				_volumeIcon.addEventListener(MouseEvent.MOUSE_OVER,function(e:Event):void{showToolTip(_volumeIcon,'Volume')});
				_volumeIcon.addEventListener(MouseEvent.MOUSE_OUT,function(e:Event):void{hideToolTip()});
				_volumeIcon.addEventListener(MouseEvent.MOUSE_UP,onVolumeRelease);
				////////////////
				 this.stage.addEventListener(MouseEvent.MOUSE_UP,onVolumeRelease);
			}
			if(showFullScreen)
			{
				_fullScreenIcon.addEventListener(MouseEvent.MOUSE_DOWN,function(e:Event):void
				{
					dispatchEvent(new Event(GO_FULLSCREEN, true));
				});
				_fullScreenIcon.addEventListener(MouseEvent.MOUSE_OVER,function(e:Event):void{showToolTip(_fullScreenIcon,'Fullscreen')});
				_fullScreenIcon.addEventListener(MouseEvent.MOUSE_OUT,function(e:Event):void{hideToolTip()});
			}
			
			_reproductionScroll.addEventListener(PrimitiveButton.BUTTON_CLICKED, onReproductionClicked, false, 0, true);
		}
		 private function hideToolTip():void
		{
			/* if(_toolTip)
			{
				_toolTip.parent.removeChild(_toolTip)
				_toolTip=null;
			} */
		}
		private function showToolTip(target:*, str:String):void
		{
			/* if(!_toolTip)
			{
				_toolTip = new ToolTip(str);
				addChild(_toolTip);
				if(target==_playBtn)
				{
					_toolTip.x =(_playerContainer.x+target.parent.x)//-target.width*.5;
					_toolTip.y =(_playerContainer.y-(target.height+14));
				}
				else
				{
					_toolTip.x =(_playerContainer.x+target.x)//-target.width*.5;
					_toolTip.y =(_playerContainer.y-(target.height+14));
				}
				
			} */
			
		} 
		private function onPlayPauseClicked(e:Event):void
		{
			playPauseVideo();
			activateTimer(true);
		}
		
		private function onReproductionClicked(e:Event):void
		{
			var reproductionTime:Number = (_playerBarContainer.mouseX*_duration)/_maskBackground.width;
			super.setSeek(reproductionTime);
			activateTimer(true);
		}
		
		private function resumeUpdate(e:Event):void
		{
			
			activateTimer(true);
			
		}
		
		private function activateTimer(n:Boolean):void
		{
			
			if(n)addEventListener(Event.ENTER_FRAME,updateStream, false, 0, true);
			else removeEventListener(Event.ENTER_FRAME,updateStream);
			
		}
		
		private function updateStream(e:Event = null):void
		{
			
			var t:Number;
			var d:Number;
			
			if(_netStream.time && _duration)
			{
				t = Math.round(_netStream.time);
				d = Math.round(_duration);
				
				var bufferPercent:Number = _netStream.bytesLoaded/_netStream.bytesTotal;
				var reproductionPercent:Number = _netStream.time/_duration;
				
				TweenMax.to(_maskBuffer, _resizeBarEasingTime, {ease:_resizeBarEasing, scaleX:bufferPercent});
				TweenMax.to(_maskReproduction, _resizeBarEasingTime, {ease:_resizeBarEasing, scaleX:reproductionPercent});
				_reproductionScroll.scaleX = bufferPercent;
				
				if(t >= d)
				{
					TweenMax.to(_maskBuffer, _resizeBarEasingTime, {ease:_resizeBarEasing, scaleX:1});
					TweenMax.to(_maskReproduction, _resizeBarEasingTime, {ease:_resizeBarEasing, scaleX:1});
					_reproductionScroll.scaleX = 1;
					activateTimer(false);
				}
			}
		}
		private function dispatchPlayerBuilt():void
		{
			dispatchEvent(new Event(PLAYER_BUILT,true));
			_playerBuilt = true;
			if(_superReproductionReady)dispatchReproductionPlayerReady();
		}
		private function dispatchReproductionPlayerReady():void
		{
			dispatchEvent(new Event(REPRODUCTION_READY, true));
		}
		private function onVolumeDown(e:Event):void
		{
			_volumeIcon.addEventListener(Event.ENTER_FRAME,onVolumeEnter)
		}
		private function onVolumeEnter(e:Event):void
		{
			var currVol:Number = (_volumeIcon.mouseX)/_volumeIcon.width;
			if((currVol>=0) && ((_volumeIcon.mouseX*100)/100 <= _volumeIcon.width))
			{
				_sndTransform.volume =currVol;
				_netStream.soundTransform=_sndTransform;
				TweenLite.to(_volumeIcon.volumeDrag,0.8,{ease:Expo.easeOut,width:(_volumeIcon.mouseX*100)/100})
			}
		}
		private function onVolumeRelease(e:Event):void
		{
			_volumeIcon.removeEventListener(Event.ENTER_FRAME,onVolumeEnter)
		}
		override public function rewindVideo():void
		{
			_playPause.gotoAndStop(1);
			_netStream.pause();
			setSeek(0);
			TweenMax.to(_maskReproduction, _resizeBarEasingTime, {ease:_resizeBarEasing, scaleX:0});
		}
		override public function playPauseVideo():void
		{
			if(_playPause.currentFrame == 1) _playPause.gotoAndStop(2);
			else _playPause.gotoAndStop(1);
			_netStream.togglePause();
			updateStream();
		}
		override public function pauseVideo():void
		{
			if(_playPause)_playPause.gotoAndStop(1);
			_netStream.pause();
		}
		override public function resumeVideo():void
		{
			_playPause.gotoAndStop(2);
			_netStream.resume();
		}
		override public function removeAllListener():void
		{
			_netConnection.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
			_netStream.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
			
			removeEventListener(FlvViewer.METADATA_INIT,buildPlayer);
			removeEventListener(FlvViewer.REPRODUCTION_CHANGE_SEEK,resumeUpdate);
			removeEventListener(FlvViewer.REPRODUCTION_READY,onReproductionReady);
			removeEventListener(Event.ENTER_FRAME, dispatchBufferPercent);
			removeEventListener(Event.ENTER_FRAME,updateStream);
			
			if(_playBtn)_playBtn.removeEventListener(PrimitiveButton.BUTTON_CLICKED, onPlayPauseClicked);
			if(_reproductionScroll)_reproductionScroll.removeEventListener(PrimitiveButton.BUTTON_CLICKED, onReproductionClicked);
		}
		public function setResizeBarTime(n:Number):void
		{
			_resizeBarEasingTime = n;
		}
		public function setResizeBarEasing(ease:Function):void
		{
			_resizeBarEasing = ease;
		}
		public function reArrangeController():void
		{
			
			_maskBackground.width=Math.round(controllerWidth - _playerBarContainer.x)
			_maskBuffer.width=Math.round(controllerWidth - _playerBarContainer.x)
			_maskTexture.width=Math.round(controllerWidth - _playerBarContainer.x);
			
			 _playerContainer.y = controllerYPosition;
			 createProgressElements();
		}
		public function set controllerYPosition(yPos:Number):void
		{
			_controllerYPos = yPos;
		
		}
		public function get controllerYPosition():Number
		{
			return _controllerYPos;
		
		}
		public function set controllerXPosition(xPos:Number):void
		{
			_controllerXPos = xPos;
		
		}
		public function get controllerXPosition():Number
		{
			return _controllerXPos;
		
		}
		public function set controllerWidth(wNum:Number):void
		{
			_controllerWidth = wNum;
		}
		public function get controllerWidth():Number
		{
			return _controllerWidth;
		
		}
		public function set showVolume(showBool:Boolean):void
		{
			_showVolume = showBool;
		}
		public function get showVolume():Boolean
		{
			return _showVolume;
		}
		public function set showFullScreen(showBool:Boolean):void
		{
			_showFullScreen = showBool;
		}
		public function get showFullScreen():Boolean
		{
			return _showFullScreen;
		}
		public function set volume(vol:Number):void
		{
			_volume=vol;
		}
		public function get volume():Number
		{
			return _volume;
		}
		
		// ANDREA GETTER AND SETTERS
		
		public function get playerBarContainer():Sprite
		{
			return _playerBarContainer;
		}
		
		public function get barBuffer():MovieClip
		{
			return (_barBuffer as MovieClip);
		}
		
		public function get  playPause():MovieClip
		{
			
			return (_playPause as MovieClip);
		
		}
		
		public function setPlayPauseBotton(x:Number,y:Number):void
		{
			_playPause.x=x;
			_playPause.y=y;
			
		}
		
		
		
		
		
		
	}
	
}