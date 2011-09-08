package com.cobalto.utils
{
	import com.cobalto.api.IDraggable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import gs.*;
	import com.greensock.easing.*;

	
	public  class Draggable extends Sprite implements IDraggable
	{
		
		private var _target:DisplayObject;
		private var _hand:MovieClip;
		private var _objectEquation:Object;
		private var _objectCoord:Object;
		private var _direction:String;
		private var _boundingBox:DisplayObject;
		
		private var _boundingBoxBitmapData:BitmapData;
		private var _boundingBoxBitmap:Bitmap;
		
		private var _mouseDown:Boolean;
		private var _mouseOver:Boolean;
	
		
		
		private var _prevX:Number;
		private var _prevY:Number;
	
		private var _maxCoordinatesX:Number;
		private var _minCoordinatesX:Number;
		private var _maxCoordinatesY:Number;
		private var _minCoordinatesY:Number;
		
		
		public static const ALL_DIRECTION:String = "allDirection";
		public static const VERTICAL:String = "vertical";
		public static const HORIZONTAL:String = "horizontal";
		
		public static const DOWN_TARGET:String="downTarget";
		public static const UP_TARGET:String="upTarget";
		
		
		
		public function Draggable(target:DisplayObject, boundingBox:DisplayObject,hand:MovieClip,objectEquation:Object,direction:String,objectCoord:Object=null)
		{
		 _target=target;
		 _boundingBox=boundingBox;
		 _hand=hand;
		 _hand.mouseEnabled=false;
		 _hand.mouseChildren=false;
		 _hand.visible=false;
		 _objectEquation=objectEquation;
		 _objectCoord=objectCoord;
		 _direction=direction;	
		 
	
		
		}
		
				
		private function createBitmapData():void{
			
			 
			 _boundingBoxBitmapData= new BitmapData(_boundingBox.width,_boundingBox.height,true,0x00000000);
			 _boundingBoxBitmapData.draw(_boundingBox);
		     _boundingBoxBitmap= new Bitmap(_boundingBoxBitmapData);
		     _boundingBoxBitmap.x=_boundingBox.x;
		     _boundingBoxBitmap.y=_boundingBox.y;
		 
		}
		
		
		
		
		public function addClipsAndListeners():void{
			
			
		  addChild(_target);
		 
		  createBitmapData();
		 
		 addChild(_boundingBoxBitmap);
		 addChild(_hand);
		 
		 if(_objectCoord==null){
		 	
		 	_minCoordinatesY=_boundingBoxBitmap.y;
		 	_maxCoordinatesY=_boundingBoxBitmap.y+_boundingBoxBitmap.height;
		 	
		 	_minCoordinatesX=_boundingBoxBitmap.x;
		 	_maxCoordinatesX=_boundingBoxBitmap.x+_boundingBoxBitmap.width;
		
		 }else{
		 	
		 	_minCoordinatesY=_objectCoord.coordY
		 	_maxCoordinatesY=_objectCoord.coordY+_objectCoord.altezza;
		 	
		 	_maxCoordinatesX=_objectCoord.coordX
		 	_maxCoordinatesX=_objectCoord.coordX+_objectCoord.lunghezza;
	
		 
		 }
			
			_hand.visible=true;
			
			_target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			_target.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			_target.addEventListener(MouseEvent.MOUSE_OVER, mouseOverListener);
			_target.addEventListener(MouseEvent.MOUSE_OUT, mouseOutListener);

		}
		
		
		////////////////// LISTENERS
		
		private function mouseDownListener(e:MouseEvent):void{
			
			_mouseDown=true;
			
			
			var pt:Point =  _boundingBoxBitmap.globalToLocal( new Point(e.stageX, e.stageY));
			
		
			
			if(_boundingBoxBitmapData.hitTest(new Point(), 1, pt)){
				
				_hand.gotoAndStop(2);
				
				dispatchEvent(new Event(Draggable.DOWN_TARGET,true));
				
			}
		
		     
		     _prevX=_target.mouseX;
		     _prevY=_target.mouseY;
		     
		}
		
		private function mouseUpListener(e:MouseEvent):void{

			_mouseDown=false;
			
			_hand.gotoAndStop(1);
			
			// to animate the hand accoringly
			dispatchEvent(new Event(Draggable.UP_TARGET,true));

		
		}
		
		private function mouseOverListener(e:MouseEvent):void{
			
			trace("mouse over listener");
			
			_mouseOver=true;
			 
			 mouseHide(true);
			 _target.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveListener);

		
		}
		
		private function mouseOutListener(e:MouseEvent):void{
			
			
			_mouseOver=false;
			
		    mouseHide(false);
		    _target.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveListener);	 

		
		}
		
		
		protected function mouseMoveListener(e:MouseEvent):void{
			
			
			
			_hand.x= e.stageX;
			_hand.y= e.stageY;
			
			
			var pt:Point =  _boundingBoxBitmap.globalToLocal( new Point(e.stageX, e.stageY));

			if(_boundingBoxBitmapData.hitTest(new Point(), 1, pt)){
			
			   mouseHide(true);
			   
			   if(_mouseDown==true){
			   	
			   	 _hand.gotoAndStop(2);
			   	 
			   	 
			   	 var toMoveX:Number =  _target.x+(_target.mouseX-_prevX);
			   	 
			   	  var toMoveY:Number =  _target.y+(_target.mouseY-_prevY);
			  
			   	 
			   	 switch(_direction){
			   	 	
			   	 
	   	              case ALL_DIRECTION:  moveAllDirection(toMoveX,toMoveY);
	   	   
	   	              break;
  
	   	              case VERTICAL:      moveVertical(toMoveY);
	   	              
	   	              
	   	              break
	   	   
	   	              default :          moveHorizontal(toMoveX);
	   
	   	        }
			
			   
			   }else{
			   
			    _hand.gotoAndStop(1);
			   
			   }
			
			} else{
			
			  mouseHide(false); 
			
			}


          e.updateAfterEvent();
		
		}
		
		
		
		private function moveAllDirection(x:Number,y:Number):void{
			
			
			
			
			if(x>_minCoordinatesX || x+_target.width<_maxCoordinatesX || y>_minCoordinatesY || y+_target.height<_maxCoordinatesY){
				
				
				if(x>_minCoordinatesX){
				
				    if(y>_minCoordinatesY){
				    	
				    	
				    	TweenMax.to(_target,_objectEquation.time,{y:_minCoordinatesY,roundProps:["y"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
				    
				    
				    }else if(y+_target.height<_maxCoordinatesY){
				    	
				    	
				       TweenMax.to(_target,_objectEquation.time,{y:_maxCoordinatesY-_target.height,roundProps:["y"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});	
				   
				    }
				
				    
			      TweenMax.to(_target,_objectEquation.time,{x:_minCoordinatesX,roundProps:["x"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});	
			
				}
				
				
				///
				
				
				
				if(x+_target.width<_maxCoordinatesX){
				
				    if(y>_minCoordinatesY){
				    	
				    	
				    	TweenMax.to(_target,_objectEquation.time,{y:_minCoordinatesY,roundProps:["y"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
				    
				    
				    }else if(y+_target.height<_maxCoordinatesY){
				    	
				    	
				       TweenMax.to(_target,_objectEquation.time,{y:_maxCoordinatesY-_target.height,roundProps:["y"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});	
				   
				    }
				
				    
			      TweenMax.to(_target,_objectEquation.time,{x:_maxCoordinatesX-_target.width,roundProps:["x"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
			
				}
				
				
				////
				
				if(y>_minCoordinatesY){
					
					
					 if(x>_minCoordinatesX ){
		    	
		    	
		             	TweenMax.to(_target,_objectEquation.time,{x:_minCoordinatesX,roundProps:["x"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
		    
		    
		    
		                  }else if(x+_target.width<_maxCoordinatesX){
		    
		    
		    
		                  TweenMax.to(_target,_objectEquation.time,{x:_maxCoordinatesX-_target.width,roundProps:["x"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
		    
		    
	               	}
					
				
				
				TweenMax.to(_target,_objectEquation.time,{y:_minCoordinatesY,roundProps:["y"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
		
			    }
			    
			    
			    
				
				if(y+_target.height<_maxCoordinatesY){
					
					
					if(x>_minCoordinatesX ){
		    	
		    	
		             	TweenMax.to(_target,_objectEquation.time,{x:_minCoordinatesX,roundProps:["x"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
		    
		    
		    
		                  }else if(x+_target.width<_maxCoordinatesX){
		    
		    
		    
		                  TweenMax.to(_target,_objectEquation.time,{x:_maxCoordinatesX-_target.width,roundProps:["x"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
		    
		    
	               	}
			
			   TweenMax.to(_target,_objectEquation.time,{y:_maxCoordinatesY-_target.height,roundProps:["y"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
			
			
			}
		
			
			}else{

			   TweenMax.to(_target,_objectEquation.time,{x:x,y:y,roundProps:["x","y"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay}); 

			}
	
		}
		
		private function moveVertical(y:Number):void{
			
			if(y>_minCoordinatesY){
				
				
				TweenMax.to(_target,_objectEquation.time,{y:_minCoordinatesY,roundProps:["y"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
		
			}else if(y+_target.height<_maxCoordinatesY){
			
			
			   TweenMax.to(_target,_objectEquation.time,{y:_maxCoordinatesY-_target.height,roundProps:["y"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
			
			
			}else{
				
				
				TweenMax.to(_target,_objectEquation.time,{y:y,roundProps:["y"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
			
			}
	
		
		}
		
		private function moveHorizontal(x:Number):void{
		
		    
		    
		    if(x>_minCoordinatesX ){
		    	
		    	
		    	TweenMax.to(_target,_objectEquation.time,{x:_minCoordinatesX,roundProps:["x"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
		    
		    
		    
		    }else if(x+_target.width<_maxCoordinatesX){
		    
		    
		    
		        TweenMax.to(_target,_objectEquation.time,{x:_maxCoordinatesX-_target.width,roundProps:["x"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});
		    
		    
	     	}else{
	     	
	     	 
	     	   TweenMax.to(_target,_objectEquation.time,{x:x,roundProps:["x"],ease:_objectEquation.equation,overwrite:true,delay:_objectEquation.delay});

	     	}
	  
		}

		
	
		//////////////////////////////////////////////////
		
		
		
		public function removeListeners():void{
			
			_target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			_target.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			_target.addEventListener(MouseEvent.MOUSE_OVER, mouseOverListener);
			_target.addEventListener(MouseEvent.MOUSE_OUT, mouseOutListener);
			
			_target=null;
		    _hand=null;
		    _objectEquation=null;
		    _objectCoord=null;
		    _direction=null;
		    _boundingBox=null;
		    
		   _boundingBoxBitmapData=null;
		   _boundingBoxBitmap=null;
		
		}
		
	
		
		private function mouseHide(k:Boolean):void
		{
		  
		  if(k){
		  
		     Mouse.hide();
		     _hand.visible=true;
		     
		  }else{
		  
		   Mouse.show();
		   _hand.visible=false;
		  
		  }
	
		}
		
		
		public function setBoundingBoxVisibility(k:Boolean):void{
		
		  	_boundingBoxBitmap.visible=k;
	
		}
		
	
	
	
	}
}