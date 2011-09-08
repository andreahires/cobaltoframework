package com.cobalto.UI
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class PlaceHolder extends MovieClip 
	{
		private var _Name:String='Not_Yet_Set';
		private var _Id:int;
		private var _Mandatory:String='Not_Yet_Set';
		private var _Restrict:String = 'Not_Yet_Set';
		private var _ComponentType:String = 'Not_Yet_Set';
		private var _TextType:String ='Not_Yet_Set';
		private var _TabIndex:int;
		private var _Group:String = 'Not_Yet_Set';
		private var _GroupNum:int;
		private var _MaxChar:int;
		
		public function PlaceHolder()
		{
			super();
		}
		
		public function set Id(index:int):void{_Id = index;}
		public function get Id():int{return _Id}
		
		public function set Name(value:String):void{_Name = value;}
		public function get Name():String{return _Name;}
		
		public function set Mandatory(value:String):void{'inside set value: ',value; _Mandatory = value;}
		public function get Mandatory():String{return _Mandatory}
		
		public function set Restrict(value:String):void{_Restrict = value;}
		public function get Restrict():String{return _Restrict;}
		
		public function set ComponentType(value:String):void{_ComponentType = value;}
		public function get ComponentType():String{return _ComponentType;}
		
		public function set TextType(value:String):void{_TextType = value;}
		public function get TextType():String{return _TextType;}
				
		public function set TabIndex(index:int):void{_TabIndex = index;}
		public function get TabIndex():int{return _TabIndex;}
		
		public function set Group(value:String):void{_Group = value;}
		public function get Group():String{return _Group;}
		
		public function set GroupNum(index:int):void{_GroupNum = index;}
		public function get GroupNum():int{return _GroupNum;}
		
		public function set MaxChar(index:int):void{_MaxChar = index;}
		public function get MaxChar():int{return _MaxChar;}

	}
	
}