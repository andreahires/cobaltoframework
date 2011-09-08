package com.cobalto.utils
{ 
	import flash.geom.ColorTransform;
	public class ColorUtil
	{  		
		/**
		 * RGBColorTransform Create an instance of the information.
		 * @ Param rgb RGB integer value that indicates (0x000000 - 0xFFFFFF)
		 * @ Param amount of fill adaptive value (0.0 - 1.0)
		 * @ Param alpha transparency (0.0 - 1.0)
		 * @ Return a new instance ColorTransform
		 * */
		public static function colorTransform (rgb: uint = 0, amount: Number = 1.0, alpha: Number = 1.0): ColorTransform
		{
			amount = (amount> 1)? 1: (amount <0)? 0: amount;
			alpha = (alpha> 1)? 1: (alpha <0)? 0: alpha;
			var r: Number = ((rgb>> 16) & 0xff) * amount;
			var g: Number = ((rgb>> 8) & 0xff) * amount;
			var b: Number = (rgb & 0xff) * amount;
			var a: Number = 1-amount;
			return new ColorTransform (a, a, a, alpha, r, g, b, 0);
		}
		
		/**
		 * Subtraction.  
		 * 2 RGB single number that indicates (0x000000 0xFFFFFF up from) is subtracted from the return numbers.
		 * @ Param col1 RGB numbers show (0x000000 0xFFFFFF up from)
		 * @ Param col2 RGB numbers show (0x000000 0xFFFFFF up from)
		 * @ Return value subtracted Blend 
		 **/
		public static function subtract (col1: uint, col2: uint): uint
		{
			var colA: Array = toRGB (col1);
			var colB: Array = toRGB (col2);
			var r: uint = Math.max (Math.max (colB [0] - (256-colA [0]), colA [0] - (256-colB [0])), 0);
			var g: uint = Math.max (Math.max (colB [1] - (256-colA [1]), colA [1] - (256-colB [1])), 0);
			var b: uint = Math.max (Math.max (colB [2] - (256-colA [2]), colA [2] - (256-colB [2])), 0);
			return r <<16 | g <<8 | b;
		}
		
		/**
		 * Additive color. 
		 * 2 RGB single number that indicates (0x000000 0xFFFFFF up from) Returns the value of the additive mixture.
		 * @ Param col1 RGB numbers show (0x000000 0xFFFFFF up from)
		 * @ Param col2 RGB numbers show (0x000000 0xFFFFFF up from)
		 * @ Return the additive color
		 **/
		public static function sum (col1: uint, col2: uint): uint
		{
			var c1: Array = toRGB (col1);
			var c2: Array = toRGB (col2);
			var r: uint = Math.min (c1 [0] + c2 [0], 255);
			var g: uint = Math.min (c1 [1] + c2 [1], 255);
			var b: uint = Math.min (c1 [2] + c2 [2], 255);
			return r <<16 | g <<8 | b;
		}
		
		/**
		 * Subtractive. 
		 * 2 RGB single number that indicates (0x000000 0xFFFFFF up from) Returns the value of the subtractive color.
		 * @ Param col1 RGB numbers show (0x000000 0xFFFFFF up from)
		 * @ Param col2 RGB numbers show (0x000000 0xFFFFFF up from)
		 * @ Return the subtractive
		 **/
		public static function sub (col1: uint, col2: uint): uint
		{
			var c1: Array = toRGB (col1);
			var c2: Array = toRGB (col2);
			var r: uint = Math.max (c1 [0]-c2 [0], 0);
			var g: uint = Math.max (c1 [1]-c2 [1], 0);
			var b: uint = Math.max (c1 [2]-c2 [2], 0);
			return r <<16 | g <<8 | b;
		}
		
		/**
		 * Comparison (dark). 
		 * 2 RGB single number that indicates (0x000000 0xFFFFFF up from) to compare, RGB lower combined returns a numeric value for each number.
		 * @ Param col1 RGB numbers show (0x000000 0xFFFFFF up from)
		 * @ Param col2 RGB numbers show (0x000000 0xFFFFFF up from)
		 * @ Return comparison (dark) values
		 **/
		public static function min (col1: uint, col2: uint): uint
		{
			var c1: Array = toRGB (col1);
			var c2: Array = toRGB (col2);
			var r: uint = Math.min (c1 [0], c2 [0]);
			var g: uint = Math.min (c1 [1], c2 [1]);
			var b: uint = Math.min (c1 [2], c2 [2]);
			return r <<16 | g <<8 | b;
		}
		
		/**
		 * Comparison (light). 
		 * 2 RGB single number that indicates (0x000000 0xFFFFFF up from) to compare, RGB values combined with higher returns to their numbers.
		 * @ Param col1 RGB numbers show (0x000000 0xFFFFFF up from)
		 * @ Param col2 RGB numbers show (0x000000 0xFFFFFF up from)
		 * @ Return comparison (light) value
		 **/
		public static function max (col1: uint, col2: uint): uint
		{
			var c1: Array = toRGB (col1);
			var c2: Array = toRGB (col2);
			var r: uint = Math.max (c1 [0], c2 [0]);
			var g: uint = Math.max (c1 [1], c2 [1]);
			var b: uint = Math.max (c1 [2], c2 [2]);
			return r <<16 | g <<8 | b;
		}
		
		/**
		 *	Values calculated from each RGB * RGB color value.
		 * @ Param r the red (R) indicating the number (0-255)
		 * @ Param g green (G) indicates the number (0-255)
		 * @ Param b blue (B) shows the number (0-255)
		 * @ Return obtained from the RGB color value for each indicating the number
		 **/
		public static function rgb (r: uint, g: uint, b: uint): uint
		{
			return r <<16 | g <<8 | b;
		}
		
		/**
		 * HSV calculated from the numbers of each RGB color value.
		 * @ Param h hue (Hue) number that indicates (to 360-0)
		 * @ Param s the saturation (Saturation) shows the number (0.0 to 1.0)
		 * @ Param v lightness (Value) indicates the number (0.0 to 1.0)
		 * @ Return obtained from the RGB color value for each indicating the number
		 **/
		
		
		/**
		 * RGB figures show (0x000000 0xFFFFFF up from) the
		 * R, G, B returns an array divided into a number from 0 to 255, respectively.
		 *
		 * @ Param rgb RGB numbers show (0x000000 0xFFFFFF up from)
		 * @ Return array indicates the value of each color [R, G, B]
		 **/
		public static function toRGB (rgb: uint): Array
		{
			var r: uint = rgb>> 16 & 0xFF;
			var g: uint = rgb>> 8 & 0xFF;
			var b: uint = rgb & 0xFF;
			return [r, g, b];
		}
		
		/**
		 * RGB from the respective figures, HSV sequences in terms of returns.
		 * RGB values are as follows.
		 * R - a number from 0 to 255
		 * G - a number from 0 to 255
		 * B - a number from 0 to 255
		 *
		 * HSV values are as follows.
		 * H - a number between 360-0
		 * S - number between 0 and 1.0
		 * V - number between 0 and 1.0
		 *
		 * Can not compute, including alpha.
		 * @ Param r the red (R) indicating the number (0x00 to 0xFF to)
		 * @ Param g green (G) indicates the number (0x00 to 0xFF to)
		 * @ Param b blue (B) shows the number (0x00 to 0xFF to)
		 * @ Return HSV values into an array of [H, S, V]
		 **/
		
		
		
		
		
	}
}