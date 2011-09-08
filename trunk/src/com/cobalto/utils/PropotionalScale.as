package com.cobalto.utils
{
	import flash.display.DisplayObject;
	
	public class PropotionalScale extends DisplayObject
	{
		
		private var _alignementRight:Boolean;
		
		
		
		public function PropotionalScale()
		{
		
		}
		
		public static function scaleObject(_obj:DisplayObject,W:Number,H:Number):void
		{
			
			var _SW:Number = W;
			var _SH:Number = H;
			///
			var picHeight:Number;
			picHeight = _obj.height / _obj.width;
			//
			var picWidth:Number;
			picWidth = _obj.width / _obj.height;
			
			//conditional statement to account for various initial browswer sizes and proportions
			if((_SH / _SW) < picHeight)
			{
				_obj.width = Math.round(_SW);
				_obj.height = Math.round(picHeight * _obj.width);
			}
			else
			{
				_obj.height = Math.round(_SH);
				_obj.width = Math.round(picWidth * _obj.height);
			};
		
		}
		
		public static function scaleObjectToStage(_obj:DisplayObject,alignementRight:Boolean=false):void
		{
			
			if(_obj.stage)
			{
				var _SW:Number = _obj.stage.stageWidth;
				var _SH:Number = _obj.stage.stageHeight;
				///
				var picHeight:Number;
				picHeight = _obj.height / _obj.width;
				//
				var picWidth:Number;
				picWidth = _obj.width / _obj.height;
				
				//conditional statement to account for various initial browswer sizes and proportions
				if((_SH / _SW) < picHeight)
				{
					_obj.width = Math.round(_SW);
					_obj.height = Math.round(picHeight * _obj.width);
				}
				else
				{
					_obj.height = Math.round(_SH);
					_obj.width = Math.round(picWidth * _obj.height);
				};
			}
			
			_obj.y = _obj.stage.stageHeight / 2 - _obj.height / 2;
			
			if(alignementRight==true)
			{
				_obj.x= _obj.stage.stageWidth-_obj.width;
			}

		
		}
	
	}
}

