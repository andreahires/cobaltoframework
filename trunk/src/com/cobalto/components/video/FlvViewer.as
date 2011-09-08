package com.cobalto.components.video
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.text.*;
	
	public class FlvViewer extends Sprite
	{
		
		private var _bufferTimeValue:Number;
		private var _lockSize:Boolean;
		private var _client:Object;
		private var _flv:String;
		private var _cuePointName:String;
		private var _cuePointTime:Number;
		
		protected var _bufferFullDataReady:Boolean;
		protected var _metaDataReady:Boolean;
		protected var _reproductionStartReady:Boolean;
		protected var _reproductionReadyDispatched:Boolean;
		
		protected var firstTime:Boolean = true;
		
		protected var _video:Video;
		protected var _netConnection:NetConnection;
		protected var _netStream:NetStream;
		protected var _duration:uint;
		
		public static const CONNECTION_INIT:String = 'ConnectionInit';
		public static const METADATA_INIT:String = 'MetaDataInit';
		public static const REPRODUCTION_CHANGE_SEEK:String = 'ReproductionChangeSeek';
		public static const REPRODUCTION_END:String = 'ReproductionEnd';
		public static const BUFFER_IS_FULL:String = 'BufferIsFull';
		public static const BUFFER_IS_EMPTY:String = 'BufferIsEmpty';
		public static const BUFFER_PERCENT:String = 'BufferPercent';
		public static const CUE_POINT_FOUND:String = 'CuePointFound';
		public static const VIDEO_START:String = 'VideoStart';
		public static const REPRODUCTION_READY:String = 'ReproductionReady';
		public static const VIDEO_LOADED:String = 'VideoLoaded';
		
		public function FlvViewer():void
		{
			
			super();
		
		}
		
		private function setDuration(d:uint):void
		{
			
			_duration = d;
		
		}
		
		private function buildVideo():void
		{
			
			_video = new Video();
			_video.visible = false;
		
		}
		
		private function setConnection():void
		{
			
			_netConnection = new NetConnection();
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false,0,true);
			_netConnection.connect(null);
		
		}
		
		protected function onNetStatus(e:NetStatusEvent):void
		{
			
			//trace('NET_STATUS: ' + e.info.code);
			
			switch(e.info.code)
			{
				
				case 'NetConnection.Connect.Success':
					setStream();
					break;
				case 'NetStream.Seek.Failed':
					onBufferEmpty();
					dispatchReproductionChangeSeek();
					break;
				case 'NetStream.Seek.InvalidTime':
					onBufferEmpty();
					dispatchReproductionChangeSeek();
					break;
				case 'NetStream.Play.Stop':
					dispatchReproductionStop();
					break;
				case 'NetStream.Buffer.Full':
					_bufferFullDataReady = true;
					checkReproductionReady();
					onBufferFull();
					dispatchBufferFull();
					break;
				case 'NetStream.Play.Start':
					_reproductionStartReady = true;
					checkReproductionReady();
					onBufferEmpty();
					dispatchVideoStart();
					break;
				case 'NetStream.Buffer.Empty':
					onBufferEmpty();
					dispatchBufferEmpty();
					break;
				case 'NetStream.Play.StreamNotFound':
					trace('Video Not Found');
					break;
			
			}
		
		}
		
		private function setStream():void
		{
			
			_netStream = new NetStream(_netConnection);
			_netStream.bufferTime = _bufferTimeValue;
			_netStream.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false,0,true);
			
			_client = new Object();
			_client.onMetaData = onMetaDataFunction;
			_client.onCuePoint = onCuePointFunction;
			
			_netStream.client = _client;
			
			_video.attachNetStream(_netStream);
			addChild(_video);
			
			dispatchConnectionInit();
		
		}
		
		protected function checkReproductionReady():void
		{
			
			if(_metaDataReady && _reproductionStartReady && _bufferFullDataReady)
			{
				
				if(_reproductionReadyDispatched)
					return;
				
				/* trace('METADATA: ' + _metaDataReady);
				   trace('REPRODUCTION: ' + _reproductionStartReady);
				 trace('BUFFER: ' + _bufferFullDataReady); */
				
				_reproductionReadyDispatched = true;
				setSeek(0);
				pauseVideo();
				dispatchReproductionReady();
				
			}
		}
		
		protected function onBufferEmpty():void
		{
			
			if(bufferPercent != 100)
				addEventListener(Event.ENTER_FRAME,dispatchBufferPercent,false,0,true);
		
		}
		
		protected function onBufferFull():void
		{
			
			removeEventListener(Event.ENTER_FRAME,dispatchBufferPercent);
			
			if(_netStream.bytesTotal == _netStream.bytesLoaded)
			{
				dispatchEvent(new Event(VIDEO_LOADED));
			}
		
		}
		
		private function onMetaDataFunction(data:Object):void
		{
			
			/* for(var i:String in data)
			   {
			
			   trace(i+': '+data[i]);
			
			 } */
			
			if(!_lockSize)
				setVideoSize(data.width,data.height);
			setDuration(data.duration);
			
			_video.visible = true;
			
			dispatchMetaDataInit();
			
			_metaDataReady = true;
			checkReproductionReady();
		
		}
		
		private function onCuePointFunction(data:Object):void
		{
			
			/* for(var i:String in data)
			   {
			
			   trace(i+': '+data[i]);
			
			 } */
			
			_cuePointName = data.name;
			_cuePointTime = data.time;
			
			dispatchCuePointFound();
		
		}
		
		protected function dispatchReproductionReady():void
		{
			
			dispatchEvent(new Event(REPRODUCTION_READY,true));
		
		}
		
		private function dispatchVideoStart():void
		{
			
			dispatchEvent(new Event(VIDEO_START,true));
		
		}
		
		private function dispatchConnectionInit():void
		{
			
			dispatchEvent(new Event(CONNECTION_INIT,true));
		
		}
		
		private function dispatchMetaDataInit():void
		{
			
			dispatchEvent(new Event(METADATA_INIT,true));
		
		}
		
		private function dispatchReproductionChangeSeek():void
		{
			
			dispatchEvent(new Event(REPRODUCTION_CHANGE_SEEK,true));
		
		}
		
		private function dispatchReproductionStop():void
		{
			
			dispatchEvent(new Event(REPRODUCTION_END,true));
		
		}
		
		private function dispatchBufferFull():void
		{
			
			dispatchEvent(new Event(BUFFER_IS_FULL,true));
		
		}
		
		private function dispatchBufferEmpty():void
		{
			_reproductionReadyDispatched = false;
			
			dispatchEvent(new Event(BUFFER_IS_EMPTY,true));
		
		}
		
		private function dispatchCuePointFound():void
		{
			
			dispatchEvent(new Event(CUE_POINT_FOUND,true));
		
		}
		
		protected function dispatchBufferPercent(e:Event):void
		{
			if(_netStream.bytesLoaded == _netStream.bytesTotal)
			{
				removeEventListener(Event.ENTER_FRAME,dispatchBufferPercent);
			}
			else
			{
				dispatchEvent(new Event(BUFFER_PERCENT,true));
			}
			//trace("bufferPercent" + _netStream.bytesLoaded + " " + _netStream.bytesTotal);
		
		}
		
		private function setVideoSize(w:Number,h:Number):void
		{
			
			_video.width = w;
			_video.height = h;
		
		}
		
		public function setSeek(n:Number):void
		{
			
			_netStream.seek(n);
		
		}
		
		public function rewindVideo():void
		{
			
			_netStream.pause();
			setSeek(0);
		
		}
		
		public function playVideo():void
		{
			_netStream.play(_flv);
		}
		
		public function playPauseVideo():void
		{
			
			_netStream.togglePause();
		
		}
		
		public function pauseVideo():void
		{
			if(_netStream)
				_netStream.pause();
		
		}
		
		public function resumeVideo():void
		{
			
			if(_netStream)
			{
				_netStream.resume();
					//_netStream.play();
			}
		}
		
		public function removeAllListener():void
		{
			if(_netConnection)
				_netConnection.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
			
			if(_netStream)
			{
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
				_netStream.close();
			}
			removeEventListener(Event.ENTER_FRAME,dispatchBufferPercent);
		
		}
		
		public function get bufferPercent():int
		{
			
			var perc:int = Math.round((_netStream.bufferLength * 100) / _netStream.bufferTime);
			
			if(perc <= 100)
				return perc;
			else
				return 100;
		
		}
		
		public function get cuePointName():String
		{
			
			if(_cuePointName)
				return _cuePointName;
			else
			{
				
				trace('Cue Point Name inesistente o non ancora trovato.');
				return null;
				
			}
		
		}
		
		public function get cuePointTime():Number
		{
			
			if(_cuePointTime)
				return _cuePointTime;
			else
			{
				
				trace('Cue Point Time inesistente o non ancora trovato.');
				return 0;
				
			}
		
		}
		
		public function get videoWidth():Number
		{
			
			return _video.width;
		
		}
		
		public function get videoHeight():Number
		{
			
			return _video.height;
		
		}
		
		public function get netStream():NetStream
		{
			return _netStream;
		}
		
		public function get duration():Number
		{
			return _duration;
		}
		
		public function setFlvVideoSize(w:Number,h:Number):void
		{
			
			_lockSize = true;
			setVideoSize(w,h);
		
		}
		
		public function set bufferTime(buffer:Number):void
		{
			
			if(_netStream)
				_netStream.bufferTime = buffer;
			else
				trace("Istanza netStream inesistente - associare il buffer solo dopo aver creato l'istanza netStream [CONNECTION_INIT]");
		
		}
		
		public function init(flvSource:String,bufferTime:Number):void
		{
			_reproductionReadyDispatched = false;
			_bufferTimeValue = bufferTime;
			
			firstTime = true;
			_flv = flvSource;
			setDuration(0);
			buildVideo();
			setConnection();
			playVideo();
		
		}
		
		public function get video():Video
		{
			return _video;
		}
		
		public function close():void
		{
			
			try
			{
				if(_netStream)
				{
					_netStream.close();
				}
			}
			catch(e:ArgumentError)
			{
				
				trace('FLV VIEWER ERROR: ' + e)
				
			}
		
		}
	
	}

}