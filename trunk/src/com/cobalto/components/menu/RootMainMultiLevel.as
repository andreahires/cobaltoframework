package com.cobalto.components.menu
{
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.display.Drawer;
	import com.cobalto.text.TextBuilder;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import style.Styles;
	
	
	public final class RootMainMultiLevel extends AbstractMainMultiLevel
	{
	
		public function RootMainMultiLevel(nome:String,autoSelex:Boolean=false)
		{
			super(nome, autoSelex);
			addEventListener(BasicMenu.BUTTON_ADDED,onRootMenuButtonAdded);
		}
		
		private function onRootMenuButtonAdded(e:Event):void
		{
		
			//trace("on root menu button added");
		 	var button:PrimitiveButton= e.target as PrimitiveButton; 
		 	var rootSkin:Sprite = new Sprite();
		 	var circleSkin:Sprite= new Sprite();
         	Drawer.DrawCircle(circleSkin,10);

         	//var labelText:TextBuilder= new TextBuilder(_arrayData[button.id].toString());
         	var labelText:TextBuilder= new TextBuilder(button.id.toString());
         	labelText.objectFormat = Styles.COPY_WHITE;

         
         	rootSkin.addChild(circleSkin);
         	rootSkin.addChild(labelText);

         	button.skin=rootSkin;
         
        	// arrayChilds[button.id].skin=
         	button.scaleX=0;
         	button.scaleY=0;
		}
		
		override protected function clickHandler(e:Event=null):void
		{
			//trace("root main multi level click");
			super.clickHandler(e);
		}
		
		override public function addedHandler(e:Event):void
		{
		   super.addedHandler(e);
		   e.target.showHitArea(false);
		}
		
		override protected function overHandler(e:Event=null):void
		{
			// to do something
			//trace(e.target);
			TweenLite.to(e.target.parent.skin, 0.5,{delay:0,ease:Expo.easeOut, alpha:0.4});
		}
		
		override protected function outHandler(e:Event=null):void
		{
		   	// to do something
		   	TweenLite.to(e.target.parent.skin, 0.5,{delay:0,ease:Expo.easeOut, alpha:1});
		}
		
		override protected function disabledHandler(e:Event):void
		{
		  	// to do something
		}
		
		override protected function enabledHandler(e:Event):void
		{
		  	// to do something
		}
		
		override public function transitionIn():void
		{
			
			for(var i:uint=0; i<itemArray.length;i++)
			{
			    
				var primitiveRootButton:PrimitiveButton=itemArray[i].pb;
			    
			    if(i==itemArray.length-1)
			    {
			    	TweenLite.to(itemArray[i].btn, 0.5,{delay:0,ease:Expo.easeOut, scaleX:1,scaleY:1,x:i*30,onComplete:transitionInEnd});
			    }else{
			       	TweenLite.to(itemArray[i].btn, 0.5,{delay:0,ease:Expo.easeOut, scaleX:1,scaleY:1,x:i*30});
			    }
			
			}
		
		}
		
	   	override public function transitionOut():void
	   	{
			
			for(var i:uint=0; i<itemArray.length;i++)
			{
		    	var primitiveRootButton:PrimitiveButton=itemArray[i].pb;
		       
		       	if(i==itemArray.length-1){
		       	
		       	 	TweenLite.to(itemArray[i].btn, 0.5,{delay:0,ease:Expo.easeOut, scaleX:0,scaleY:0,x:i*30,onComplete:transitionOutEnd});
		       
		       	}else{
		       
		        	TweenLite.to(itemArray[i].btn, 0.5,{delay:0,ease:Expo.easeOut, scaleX:0,scaleY:0,x:i*30});
		       
		       	}
		  	}
	
		}	
		
		override protected function transitionOutEnd():void
		{
			super.transitionOutEnd();
		}
		
		override protected function transitionInEnd():void
		{
			super.transitionInEnd();
		}
		
		override public function setUpTopMenu():void
		{
			super.setUpTopMenu();
		
		  	// per il menu della root fai la transizione all'added 
		 	// transitionIn();
		}
	
	}
}