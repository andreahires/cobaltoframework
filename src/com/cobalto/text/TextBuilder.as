﻿package com.cobalto.text{
	import com.cobalto.ApplicationFacade;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.xml.XMLDocument;
		public class TextBuilder extends Sprite	{				protected var _formatIndex:String;		protected var _formatEnd:String;				protected var _textLength:int;		protected var _textFieldWidth:int;		protected var _textWidth:int;		protected var _textHeight:int;				protected var _textFieldItem:TextField;		protected var _textFieldString:String;				public function TextBuilder(textString:String,width:int=0)		{			var txt:String = textString;						init(txt);			setTextLength();						_textFieldWidth = width;			drawTextField();				}				protected function init(textString:String):void		{			_textFieldString = textString;		/*if(textString)		   {		   //_textFieldString = stripHtmlTags(textString,"p, br, strong", "a");		   _textFieldString = htmlUnescape(textString);		   }		   else		   {				 }*/		}				protected function drawTextField():void		{						_textFieldItem = new TextField();			_textFieldItem.autoSize = TextFieldAutoSize.LEFT;			_textFieldItem.multiline = false;			_textFieldItem.selectable = false;			_textFieldItem.htmlText = _textFieldString;						if(_textFieldWidth != 0)			{								_textFieldItem.width = _textFieldWidth;				_textFieldItem.wordWrap = true;				_textFieldItem.multiline = true;							}						objectFormat = {};						addChild(_textFieldItem);				}				protected function setTextLength():void		{			if(_textFieldString) _textLength = _textFieldString.length;		}				public function set objectField(objArguments:Object):void		{			for(var i:String in objArguments)			{				_textFieldItem[i] = objArguments[i];			}		}				public function set objectFormat(objArguments:Object):void		{						var Leading:int;			var Align:String;			var Font:String;			var EmbedFont:String;			var Size:int;			var Color:String;			var LetterSpacing:int;						for(var i:String in objArguments)			{								switch(i)				{										case 'Leading':						Leading = objArguments[i];						break;					case 'Align':						Align = objArguments[i];						break;					case 'Font':						Font = objArguments[i];						break;					case 'EmbedFont':						EmbedFont = objArguments[i];						break;					case 'Size':						Size = objArguments[i];						break;					case 'Color':						Color = objArguments[i];						break;					case 'LetterSpacing':						LetterSpacing = objArguments[i];						break;								}							}						if(!Leading)				Leading = 0;						if(!Align)				Align = 'LEFT';						if(!Size)				Size = 8;						if(!Color)				Color = '#FF0000';						if(!LetterSpacing)				LetterSpacing = 0;						if(!Font && !EmbedFont)			{								Font = 'Verdana';				_textFieldItem.embedFonts = false;							}						if (ApplicationFacade != null)			{				if (ApplicationFacade.nonLatinLanguage)				{					if(EmbedFont == "SERIF")						Font = 'Times New Roman';					else 						Font = 'Trebuchet MS';										_textFieldItem.embedFonts = false;				}							}								if(Font)			{				_textFieldItem.embedFonts = false;			}			else if(EmbedFont)			{				Font = EmbedFont;				_textFieldItem.embedFonts = true;			}						_formatIndex = "<TEXTFORMAT LEADING=\"" + Leading + "\"><P ALIGN=\"" + Align + "\"><FONT FACE=\"" + Font + "\" SIZE=\"" + Size + "\" COLOR=\"" + Color + "\" LETTERSPACING=\"" + LetterSpacing + "\">";			_formatEnd = "</FONT></P></TEXTFORMAT>";			setText(_textFieldString);				}				public function setText(textString:String):void		{			init(textString);			setTextLength();						if(_formatIndex)				_textFieldItem.htmlText = _formatIndex + _textFieldString + _formatEnd;			else				_textFieldItem.htmlText = _textFieldString;						_textWidth = _textFieldItem.width;			_textHeight = _textFieldItem.height;				}				public function stripHtmlTags(html:String,tags:String=""):String		{			var tagsToBeKept:Array = new Array();						if(tags.length > 0)				tagsToBeKept = tags.split(new RegExp("\\s*,\\s*"));						var tagsToKeep:Array = new Array();						for(var i:int = 0;i < tagsToBeKept.length;i++)			{				if(tagsToBeKept[i] != null && tagsToBeKept[i] != "")					tagsToKeep.push(tagsToBeKept[i]);			}						var toBeRemoved:Array = new Array();			var tagRegExp:RegExp = new RegExp("<([^>\\s]+)(\\s[^>]+)*>","g");						var foundedStrings:Array = html.match(tagRegExp);						for(i = 0;i < foundedStrings.length;i++)			{				var tagFlag:Boolean = false;								if(tagsToKeep != null)				{					for(var j:int = 0;j < tagsToKeep.length;j++)					{						var tmpRegExp:RegExp = new RegExp("<\/?" + tagsToKeep[j] + "( [^<>]*)*>","i");						var tmpStr:String = foundedStrings[i] as String;												if(tmpStr.search(tmpRegExp) != -1)							tagFlag = true;					}				}								if(!tagFlag)					toBeRemoved.push(foundedStrings[i]);			}						for(i = 0;i < toBeRemoved.length;i++)			{				var tmpRE:RegExp = new RegExp("([\+\*\$\/])","g");				var tmpRemRE:RegExp = new RegExp((toBeRemoved[i] as String).replace(tmpRE,"\\$1"),"g");				html = html.replace(tmpRemRE,"");			}			return html;		}				public function htmlUnescape(str:String):String		{						if(str != null)			{				var htmlEntities:Array = ["&nbsp;","&iexcl;","&cent;","&pound;","&curren;","&yen;","&brvbar;","&sect;","&uml;","&copy;","&ordf;","&laquo;","&not;","&shy;","&reg;","&macr;","&deg;","&plusmn;","&sup2;","&sup3;","&acute;","&micro;","&para;","&middot;","&cedil;","&sup1;","&ordm;","&raquo;","&frac14;","&frac12;","&frac34;","&iquest;","&Agrave;","&Aacute;","&Acirc;","&Atilde;","&Auml;","&Aring;","&AElig;","&Ccedil;","&Egrave;","&Eacute;","&Ecirc;","&Euml;","&Igrave;","&Iacute;","&Icirc;","&Iuml;","&ETH;","&Ntilde;","&Ograve;","&Oacute;","&Ocirc;","&Otilde;","&Ouml;","&times;","&Oslash;","&Ugrave;","&Uacute;","&Ucirc;","&Uuml;","&Yacute;","&THORN;","&szlig;","&agrave;","&aacute;","&acirc;","&atilde;","&auml;","&aring;","&aelig;","&ccedil;","&egrave;","&eacute;","&ecirc;","&euml;","&igrave;","&iacute;","&icirc;","&iuml;","&eth;","&ntilde;","&ograve;","&oacute;","&ocirc;","&otilde;","&ouml;","&divide;","&oslash;","&ugrave;","&uacute;","&ucirc;","&uuml;","&yacute;","&thorn;","&yuml;","&fnof;","&Alpha;","&Beta;","&Gamma;","&Delta;","&Epsilon;","&Zeta;","&Eta;","&Theta;","&Iota;","&Kappa;","&Lambda;","&Mu;","&Nu;","&Xi;","&Omicron;","&Pi;","&Rho;","&Sigma;","&Tau;","&Upsilon;","&Phi;","&Chi;","&Psi;","&Omega;","&alpha;","&beta;","&gamma;","&delta;","&epsilon;","&zeta;","&eta;","&theta;","&iota;","&kappa;","&lambda;","&mu;","&nu;","&xi;","&omicron;","&pi;","&rho;","&sigmaf;","&sigma;","&tau;","&upsilon;","&phi;","&chi;","&psi;","&omega;","&thetasym;","&upsih;","&piv;","&bull;","&hellip;","&prime;","&Prime;","&oline;","&frasl;","&weierp;","&image;","&real;","&trade;","&alefsym;","&larr;","&uarr;","&rarr;","&darr;","&harr;","&crarr;","&lArr;","&uArr;","&rArr;","&dArr;","&hArr;","&forall;","&part;","&exist;","&empty;","&nabla;","&isin;","&notin;","&ni;","&prod;","&sum;","&minus;","&lowast;","&radic;","&prop;","&infin;","&ang;","&and;","&or;","&cap;","&cup;","&int;","&there4;","&sim;","&cong;","&asymp;","&ne;","&equiv;","&le;","&ge;","&sub;","&sup;","&nsub;","&sube;","&supe;","&oplus;","&otimes;","&perp;","&sdot;","&lceil;","&rceil;","&lfloor;","&rfloor;","&lang;","&rang;","&loz;","&spades;","&clubs;","&hearts;","&diams;","","&","<",">","&OElig;","&oelig;","&Scaron;","&scaron;","&Yuml;","&circ;","&tilde;","&ensp;","&emsp;","&thinsp;","&zwnj;","&zwj;","&lrm;","&rlm;","&ndash;","&mdash;","&lsquo;","&rsquo;","&sbquo;","&ldquo;","&rdquo;","&bdquo;","&dagger;","&Dagger;","&permil;","&lsaquo;","&rsaquo;","&euro;"];								var numberEntities:Array = [" ","¡","¢","£","¤","¥","¦","§","¨","©","ª","«","¬","­","®","¯","°","±","²","³","´","µ","¶","·","¸","¹","º","»","¼","½","¾","¿","À ","Á ","Â","Ã","Ä","Å","Æ","Ç","È ","É ","Ê ","Ë ","Ì ","Í ","Î","Ï","Ð","Ñ","Ò ","Ó ","Ô","Õ","Ö","×","Ø","Ù ","Ú ","Û","Ü","Ý","Þ","ß","à ","á ","â","ã","ä","å ","æ","ç","è ","é ","ê ","ë","ì ","í ","î","ï","ð","ñ","ò ","ó ","ô","õ","ö","÷","ø","ù ","ú ","û","ü","ý","þ","ÿ","ƒ","Α","Β","Γ","Δ","Ε","Ζ","Η","Θ","Ι","Κ","Λ","Μ","Ν","Ξ","Ο","Π","Ρ","Σ","Τ","Υ","Φ","Χ","Ψ","Ω","α","β","γ","δ","ε","ζ","η","θ","ι","κ","λ","μ","ν","ξ","ο","π","ρ","ς","σ","τ","υ","φ","χ","ψ","ω","ϑ","ϒ","ϖ","•","…","′","″","‾","⁄","℘","ℑ","ℜ","™","ℵ","←","↑","→","↓","↔","↵","⇐","⇑","⇒","⇓","⇔","∀","∂","∃","∅","∇","∈","∉","∋","∏","∑","−","∗","√","∝","∞","∠","∧","∨","∩","∪","∫","∴","∼","≅","≈","≠","≡","≤","≥","⊂","⊃","⊄","⊆","⊇","⊕","⊗","⊥","⋅","⌈","⌉","⌊","⌋","〈","〉","◊","♠","♣","♥","♦",'',"&","<",">","Œ","œ","Š","š","Ÿ","ˆ","˜"," "," "," ","‌","‍","‎","‏","–","—","‘","’","‚",'“','”','„','†',"‡","‰","‹","›","€"];								var length:uint = htmlEntities.length;								for(var i:uint = 0;i < length;i++)				{					str = str.replace(htmlEntities[i],numberEntities[i]);									}			}			else			{				str = "";			}			//return new XMLDocument(str).firstChild.nodeValue;r			return str;		}				public function setTextWidth(value:int):void		{			_textFieldItem.width = value;		}				public function get textField():TextField		{			return _textFieldItem;				}				public function get textWidth():int		{						return _textWidth;				}				public function get textHeight():int		{						return _textHeight;				}				public function get textString():String		{						return _textFieldString;				}				public function get textLength():int		{						return _textLength;				}		}}