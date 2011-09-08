package com.cobalto.text
{
	import com.cobalto.ApplicationFacade;
	import com.cobalto.utils.StringUtils;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	public class HtmlTextBuilder extends TextBuilder
	{
		protected var _boldFont:String;
		protected var _boldColor:String;
		protected var _italicFont:String;
		protected var _linkColor:String;
		protected var _stripBreaks:Boolean = true;
		protected var _truncateLimit:Number;
		
		private var _maskShape:Shape;
		private var _point0:Point;
		private var _point1:Point;
		
		private var _delay:Number=2;
		
		public function HtmlTextBuilder(textString:String,width:int=0,stripBreaks:Boolean=true,truncateLimit:Number=0)
		{
			_stripBreaks = stripBreaks;
			_truncateLimit = truncateLimit;
			super(textString,width);
		}
		
		public function replaceAll(txt:String,find:String,replace:String):String
		{
			return txt.split(find).join(replace);
		}
		
		protected function replaceMagnoliaTags(str:String):String
		{
			
			str = replaceAll(str,"<strong>","<FONT FACE='" + _boldFont + "' COLOR='" + _boldColor + "'>");
			str = replaceAll(str,"</strong>","</FONT>");
			
			str = replaceAll(str,"<i>","<FONT FACE='" + _italicFont + "'>");
			str = replaceAll(str,"</i>","</FONT>");
			
			str = replaceAll(str,"<a href","<FONT COLOR='" + _linkColor + "'><a href");
			str = replaceAll(str,"</a>","</a></FONT>");
			
			if(_stripBreaks)
			{
				str = replaceAll(str,"<p>","");
				str = replaceAll(str,"</p>","");
				str = replaceAll(str,"<br>","");
				str = replaceAll(str,"<br />","");
			}
			
			return str;
		}
		
		public function set boldFont(font:String):void
		{
			
			_boldFont = font;
		
		}
		
		public function set boldColor(color:String):void
		{
			
			_boldColor = color;
		
		}
		
		public function transitionIn():void
		{
			createHtmlTextMask();
			
			TweenLite.to(_point0,0.7,{x:this.textWidth,delay:_delay,ease:Expo.easeInOut,onUpdate:drawBox});
			TweenLite.to(_point1,0.7,{x:this.textWidth,delay:_delay+0.2,ease:Expo.easeInOut,onUpdate:drawBox});
	
		}
		
		
		public function transitionOut():void
		{
			TweenLite.to(_point0,0.7,{x:0,delay:_delay,ease:Expo.easeInOut,onUpdate:drawBox});
			TweenLite.to(_point1,0.7,{x:0,delay:_delay+0.2,ease:Expo.easeInOut,onUpdate:drawBox});

		}
		
		
		private function createHtmlTextMask():void
		{
			if(_maskShape)
			{
				removeChild(_maskShape);
				_maskShape = null;
				_point0=null;
				_point1=null;
				
			}
				
				
				
				var th:Number = this.textHeight;
				_point0 = new Point(0,0);
				_point1 = new Point(0,th);
				_maskShape = new Shape();
				var k:Graphics= _maskShape.graphics;
				k.beginFill(0xFF0000,1);
				k.moveTo(0,0);
				k.lineTo(_point0.x,_point0.y);
				k.lineTo(_point1.x,_point1.y);
				k.lineTo(0,th);
				k.lineTo(0,0);
				k.endFill();
				
				
				_textFieldItem.mask=_maskShape;
				
				addChild(_maskShape);

			
			
			
		}
		
		
		private function drawBox():void
		{

			var k:Graphics = _maskShape.graphics;
			k.clear();
			k.beginFill(0xFF0000);
			k.moveTo(0,_point0.y);
			k.lineTo(_point0.x,_point0.y);
			k.lineTo(_point1.x,_point1.y);
			k.lineTo(0,this.textHeight);
			k.lineTo(0,0);
			k.endFill();
		}
		
		
		
		
		
		
		
		
		public function set italicFont(font:String):void
		{
			
			_italicFont = font;
		
		}
		
		public function set linkColor(color:String):void
		{
			
			_linkColor = color;
		
		}
		
		override public function setText(textString:String):void
		{
			
			init(textString);
			setTextLength();
			
			_textFieldItem.condenseWhite = true;
			
			//var newText:String = replaceMagnoliaTags(_textFieldString);
			//newText = htmlUnescape(newText);
			
			//trace("before ===============");
			//trace(_textFieldItem.htmlText + " _textFieldItem.htmlText  ========= ");
			var txt:String = _textFieldString;
			
			if(_truncateLimit > 0)
			{
				txt = StringUtils.truncate(txt,_truncateLimit,"...");
			}
			
			if(_formatIndex)
				
				_textFieldItem.htmlText = _formatIndex + txt + _formatEnd;
			else
				_textFieldItem.htmlText = txt;
			
			//trace(" after ===============");
			//trace(_textFieldItem.htmlText + " _textFieldItem.htmlText ===============");
			
			_textWidth = _textFieldItem.width;
			_textHeight = _textFieldItem.height;
			
			
			
		
		}
		
		
		public function set delay(k:Number):void
		{
			
			_delay=k;
			
		}
		
		
		
		
		public function set htmlFormat(styleObj:Object):void
		{
			_boldFont = styleObj.boldFont;
			_boldColor = styleObj.boldColor;
			_italicFont = styleObj.italicFont;
			_linkColor = styleObj.linkColor;
			
			//trace(replaceMagnoliaTags(_textFieldString) + " replaceMagnoliaTags(_textFieldString)");
			//setText(replaceMagnoliaTags(_textFieldString));
			setText(_textFieldString);
			
		}
	
	}
}