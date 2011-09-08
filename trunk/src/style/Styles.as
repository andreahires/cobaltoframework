package style
{
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	
	public class Styles
	{
		
		/* Setting Real FontName */
		
		public static var FAGO_FONT_BOLD:String = "Fago Pro Medi";
		public static var FAGO_FONT_MEDIUM:String = "Fago Pro Medi";
		public static var FAGO_FONT_ITALIC:String = "Fago Pro Medi";
		public static var COPY_FONT:String = "copy 08_55";
		public static var GILLSANS_FONT:String = "Gill Sans Light";
		
		public static const DESCRIPTION_WHITE_BACKGROUND:Object = {boldFont:FAGO_FONT_BOLD,boldColor:'#' + Styles.COLOR_BLACK,italicFont:FAGO_FONT_ITALIC,linkColor:'#' + Styles.COLOR_BLACK};
		public static const DESCRIPTION_BLACK_BACKGROUND:Object = {boldFont:FAGO_FONT_BOLD,boldColor:'#' + Styles.COLOR_WHITE,italicFont:FAGO_FONT_ITALIC,linkColor:'#' + Styles.COLOR_YELLOW};
		
		public static const GILLSANS_40_WHITE:Object = {EmbedFont:GILLSANS_FONT,Size:'40',Color:'#' + COLOR_WHITE,Leading:"0",LetterSpacing:-2,Align:'left'};
		public static const GILLSANS_40_BLACK:Object = {EmbedFont:GILLSANS_FONT,Size:'40',Color:'#' + COLOR_BLACK,Leading:"0",LetterSpacing:-2,Align:'left'};
		
		public static const GILLSANS_24_WHITE:Object = {EmbedFont:GILLSANS_FONT,Size:'24',Color:'#' + COLOR_WHITE,Leading:"0",LetterSpacing:-1,Align:'left'};
		public static const GILLSANS_24_GREY:Object = {EmbedFont:GILLSANS_FONT,Size:'24',Color:'#' + COLOR_GREY,Leading:"0",LetterSpacing:-1,Align:'left'};
		public static const GILLSANS_24_BLACK:Object = {EmbedFont:GILLSANS_FONT,Size:'24',Color:'#' + COLOR_BLACK,Leading:"0",LetterSpacing:-1,Align:'left'};
		public static const GILLSANS_24_YELLOW:Object = {EmbedFont:GILLSANS_FONT,Size:'24',Color:'#' + COLOR_YELLOW,Leading:"0",LetterSpacing:-1,Align:'left'};
		
		public static const GILLSANS_15_BLACK:Object = {EmbedFont:GILLSANS_FONT,Size:'15',Color:'#' + COLOR_BLACK,Leading:"0",LetterSpacing:0,Align:'left'};
		public static const GILLSANS_15_WHITE:Object = {EmbedFont:GILLSANS_FONT,Size:'15',Color:'#' + COLOR_WHITE,Leading:"0",LetterSpacing:0,Align:'left'};
		public static const GILLSANS_15_YELLOW:Object = {EmbedFont:GILLSANS_FONT,Size:'15',Color:'#' + COLOR_YELLOW,Leading:"0",LetterSpacing:0,Align:'left'};
		
		public static var FAGO_9_GREY:Object = {EmbedFont:FAGO_FONT_MEDIUM,Size:'9',Color:'#' + COLOR_GREY,Leading:"0",LetterSpacing:1,Align:'left'};
		public static var FAGO_9_GREY_LIGHT:Object = {EmbedFont:FAGO_FONT_MEDIUM,Size:'9',Color:'#' + COLOR_GREY_LIGHT,Leading:"0",LetterSpacing:1,Align:'left'};
		
		public static var FAGO_11_YELLOW:Object = {EmbedFont:FAGO_FONT_MEDIUM,Size:'11',Color:'#' + COLOR_YELLOW,Leading:"0",LetterSpacing:-0.5,Align:'left'};
		public static var FAGO_11_WHITE:Object = {EmbedFont:FAGO_FONT_MEDIUM,Size:'11',Color:'#' + COLOR_WHITE,Leading:"0",LetterSpacing:-0.5,Align:'left'};
		public static var FAGO_11_BLACK:Object = {EmbedFont:FAGO_FONT_MEDIUM,Size:'11',Color:'#' + COLOR_BLACK,Leading:"0",LetterSpacing:-0.5,Align:'left'};
		public static var FAGO_11_GREY:Object = {EmbedFont:FAGO_FONT_MEDIUM,Size:'11',Color:'#' + COLOR_GREY,Leading:"4",LetterSpacing:-0.5,Align:'left'};
		public static var FAGO_11_GREY_LIGHT:Object = {EmbedFont:FAGO_FONT_MEDIUM,Size:'11',Color:'#' + COLOR_GREY_LIGHT,Leading:"4",LetterSpacing:-0.5,Align:'left'};
		public static var FAGO_11_RED:Object = {EmbedFont:FAGO_FONT_MEDIUM,Size:'11',Color:'#' + COLOR_RED,Leading:"4",LetterSpacing:-0.5,Align:'left'};
		
		public static var FAGO_BOLD_11_YELLOW:Object = {EmbedFont:FAGO_FONT_BOLD,Size:'11',Color:'#' + COLOR_YELLOW,Leading:"0",LetterSpacing:-0.5,Align:'left'};
		public static var FAGO_BOLD_11_BLACK:Object = {EmbedFont:FAGO_FONT_BOLD,Size:'11',Color:'#' + COLOR_BLACK,Leading:"0",LetterSpacing:-0.5,Align:'left'};
		
		public static var FAGO_14_YELLOW:Object = {EmbedFont:FAGO_FONT_BOLD,Size:'13',Color:'#' + COLOR_YELLOW,Leading:"0",LetterSpacing:-0.5,Align:'left'};
		public static var FAGO_14_WHITE:Object = {EmbedFont:FAGO_FONT_BOLD,Size:'13',Color:'#' + COLOR_WHITE,Leading:"0",LetterSpacing:-0.5,Align:'left'};
		public static var FAGO_14_BLACK:Object = {EmbedFont:FAGO_FONT_BOLD,Size:'13',Color:'#' + COLOR_BLACK,Leading:"0",LetterSpacing:-0.5,Align:'left'};
		public static var FAGO_14_GRAY:Object = {EmbedFont:FAGO_FONT_BOLD,Size:'13',Color:'#' + COLOR_GREY,Leading:"0",LetterSpacing:-0.5,Align:'left'};
		public static var FAGO_14_GRAY_LIGHT:Object = {EmbedFont:FAGO_FONT_BOLD,Size:'13',Color:'#' + COLOR_GREY_LIGHT,Leading:"0",LetterSpacing:-0.5,Align:'left'};
		
		public static const FAGO_18_WHITE:Object = {EmbedFont:FAGO_FONT_MEDIUM,Size:'18',Color:'#' + COLOR_WHITE,Leading:13,Align:'left'};
		
		public static var COPY_YELLOW:Object = {EmbedFont:COPY_FONT,Size:'8',Color:'#' + COLOR_YELLOW,Leading:"7",Align:'left'};
		public static var COPY_WHITE:Object = {EmbedFont:COPY_FONT,Size:'8',Color:'#' + COLOR_WHITE,Leading:"7",Align:'left'};
		public static var COPY_GREY:Object = {EmbedFont:COPY_FONT,Size:'8',Color:'#' + COLOR_GREY,Leading:"7",Align:'left'};
		
		// *** object field
		public static const TEXT_ADVANCED:Object = {antiAliasType:AntiAliasType.ADVANCED,selectable:true};
		
		//*** effect
		public static var TITLE_SHADOW:DropShadowFilter = new DropShadowFilter(2,45,0x000000,.3,0,0,1,2);
		
		//Style Object for MagnoliaBar
		public static var MAGNOLIABAR_TEXT_STYLE:Object = {Size:'13',Color:'#FFFFFF',Leading:"0",LetterSpacing:0,textAlign:'CENTER'};
		
		public static var COLOR_GREY:String = "444444";
		public static var COLOR_GREY_VERY_LIGHT:String = "ececec";
		public static var COLOR_BORDER_GREY:String = "dfdfdf";
		public static var COLOR_GREY_LIGHT:String = "DDDDDD";
		public static var COLOR_GREY_DARK:String = "222222";
		public static var COLOR_YELLOW:String = "ffde00";
		public static var COLOR_BLACK:String = "000000";
		public static var COLOR_WHITE:String = "FFFFFF";
		public static var COLOR_RED:String = "aa1a18";
	
	}

}