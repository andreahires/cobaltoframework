package site.pages
{
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapOptions;
	import com.google.maps.MapType;
	import com.google.maps.StyledMapType;
	import com.google.maps.StyledMapTypeOptions;
	import com.google.maps.View;
	import com.google.maps.controls.ControlPosition;
	import com.google.maps.controls.MapTypeControl;
	import com.google.maps.controls.ZoomControl;
	import com.google.maps.interfaces.IDirections;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	import com.google.maps.services.ClientGeocoder;
	import com.google.maps.services.Directions;
	import com.google.maps.services.DirectionsEvent;
	import com.google.maps.services.GeocodingEvent;
	import com.google.maps.styles.MapTypeStyle;
	import com.google.maps.styles.MapTypeStyleElementType;
	import com.google.maps.styles.MapTypeStyleFeatureType;
	import com.google.maps.styles.MapTypeStyleRule;
	import com.cobalto.api.IViewComponent;
	import com.cobalto.components.ListBox.ListBox;
	import com.cobalto.components.buttons.PrimitiveButton;
	import com.cobalto.components.scrollbar.SmallScroller;
	import com.cobalto.extended.magnolia.view.components.DealersLocator;
	import com.cobalto.loading.BulkLoader;
	import com.cobalto.loading.BulkProgressEvent;
	import com.cobalto.utils.AssetManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import site.components.DisappearingLine;
	import site.components.StoreResultsItem;
	import site.components.TitleEffect;
	import site.components.listBox.LuisaSpagnoliListBox;
	import site.components.listBox.LuisaSpagnoliMenuList;
	import site.style.Styles;
	import site.text.SiteTextBuilder;
	
	
	
	
	public class StoreFinder extends SitePage implements IViewComponent
	{
		
		private var _arrayCountries:Array;
		private var _titleString:String;
		private var _subTitleString:String;
		private var _webServiceUrl:String;
		
		private var _arrayRegions:Array;
		private var _arrayRegionsArray:Array;
		
		private var _arrayProvincesAll:Array;
		
		private var _selectCountryString:String;
		private var _selectProvinceString:String;
		private var _selectRegionString:String;
		private var _selectSearchAgainString:String;
		private var _seeMapString:String;
		private var _searchAgainString:String;
		
		protected var bulkLoader:BulkLoader;
		
		protected var _resultText:TitleEffect;
		
		private var _variableToSend:String;
		
		
		private var _arrayObjectResults:Array;
		
		
		
		private var _dummyXml:XML=
			
			
			<stores>
			
				<!-- 
					the stores address informations are also useful to integrate the Google API for the map localization 
				-->	<store>
					<address><![CDATA[via Paolo Costa 1]]></address>
					<cap><![CDATA[48018]]></cap>
					<city><![CDATA[Faenza]]></city>
			
				</store>	<store>
					<address><![CDATA[Via Ripamonti 1]]></address>
					<cap><![CDATA[20100]]></cap>
					<city><![CDATA[Milano]]></city>
			
				</store>	<store>
					<address><![CDATA[]]></address>
					<cap><![CDATA[iiq]]></cap>
					<city><![CDATA[iiii]]></city>
			
				</store></stores>;
		
		
		
		
		
		
		
		private var _productPath:String  = "http://192.168.7.22/wps/wcm/connect/IT/sito/Store%20Locator/Store%20Locator?presentationtemplate=base/storesresult&location=base/IT";
		
		private var _wsString:String= "http://192.168.7.22/wps/wcm/connect/IT/sito/Store%20Locator/Store%20Locator?presentationtemplate=base/storesresult&location=base/Lombardia";
		
		
		private var  _countriesListBox:LuisaSpagnoliListBox;
		private var  _regionsListBox:LuisaSpagnoliListBox;
		private var  _provinceListBox:LuisaSpagnoliListBox;
		
		private var _storeResultsItem:StoreResultsItem;
		
		
		protected var topLeftLine:DisappearingLine;
		protected var lowLeftLine:DisappearingLine;
		
		protected var titleEffect:TitleEffect;
		protected var subTitleEffect:TitleEffect;
		
		private var _containerResults:Sprite;
		
		private var _resultsScroller:SmallScroller;
		
		
		protected var map:DealersLocator;
		
		
		protected var _pathResult:String;
		
		protected var _resultsString:String;
		
		protected var _searchAgainButton:PrimitiveButton;
		
		
		// google maps shit
		
		
		//protected var _apiKey:String= "ABQIAAAAV1uVMg57pFRqOvu7_Z1DXRRdzJuu_sxJeCXVsxtpkjoZ5Nf5FBQKBHXElbd30P1uL_R0PVIU6JmV7w";
		
		protected var _apiKey:String = "ABQIAAAAV1uVMg57pFRqOvu7_Z1DXRQcjJcCZn36ENJ1A5lEN5VF4EImURRyXgvGRMVjtknKTZxs6JZ2YQYu9w";
		
		
		public function StoreFinder()
		{
			super();
			
		}
		
		
		
		
		
		override public function build(pageData:Object=null):void
		{
			super.build(pageData);
			extractData();
			addEventListener(Event.ADDED_TO_STAGE,_addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_webServiceUrl=pageXml..ws.@url;
			_titleString= pageXml..title;
			_subTitleString= pageXml..subtitle;
			
			_selectCountryString= pageXml..selectCountry;
			_selectProvinceString=pageXml..selectProvince;
			_selectRegionString=pageXml..selectRegion;
			_seeMapString=pageXml..seeMap;
			_searchAgainString=pageXml..searchAgain;
			_resultsString=pageXml..results;
			
			_arrayCountries= new Array();
			_arrayRegions= new Array();
			_arrayRegionsArray= new Array();
			_arrayProvincesAll= new Array();
			
			for each (var region:XML in pageXml..regions.region)
			{
				var subArray:Array= new Array();
				
				var objectRegion:Object= new Object();
				objectRegion.value=region.@val;
				objectRegion.label=region.@label;
				
				for each (var province:XML in region.province)
				{
					var objectProvince:Object= new Object();
					objectProvince.value=province.@val;
					objectProvince.label=province;
					subArray.push(objectProvince);
					subArray.sort(sortOnCustom);
					
					_arrayProvincesAll.push(objectProvince);
					_arrayProvincesAll.sort(sortOnCustom);
				}
				
				_arrayRegionsArray.push(subArray);
				_arrayRegions.push(objectRegion);
				//_arrayRegions.sort(sortOnCustom);				
			}
			
			
			for each(var country:XML in pageXml..countries.country)
			{
				var object:Object= new Object();
				object.value=country.@val;
				object.label=country;
				_arrayCountries.push(object);
				_arrayCountries.sort(sortOnCustom);
				
			}
			
			_createLines();
			_createTitle();
			_createSubTitle();			
			_createSelectCountryListBox();
			_testMaps();
			
		}
		
		
		private function _testMaps():void
		{
			
			map = new DealersLocator();
			
			if(map.apiKey == null)
				map.apiKey = _apiKey;
			
			map.markerStyle(0Xfffdf4,0X6fabc7,false);
			map.infoStyle(0Xfffdf4,0Xfffdf4,false);
			map.showInfoBox = false;
			//map.addEventListener(DealersLocator.MAP_READY,onMapReady);
			map.build();
			
			map.mapSize(stage.stageWidth-540,stage.stageHeight-100);
			map.x=520;
			map.y=20
			map.alpha=0;	
			this.addChild(map);
			//setTimeout(dispatchLoadedEvent,100);
			
		}
		
		
		private function onMapReady(e:Event):void
		{
			
			var map2:Map=map.map; 
			var housesStyles:Array = [new MapTypeStyle(MapTypeStyleFeatureType.ALL,MapTypeStyleFeatureType.ALL,[MapTypeStyleRule.hue(0x2dbbab),MapTypeStyleRule.saturation(-80),MapTypeStyleRule.invert_lightness(true)])];
			var styledMapOptions:StyledMapTypeOptions = new StyledMapTypeOptions({name:'Houses',alt:'Houses'});
			var styledMapType:StyledMapType = new StyledMapType(housesStyles,styledMapOptions);
			map2.addMapType(styledMapType);
			
		}
		
		
		override public function organizeItems():void
		{
			
			if(topLeftLine)
			{
				topLeftLine.x=50;
				topLeftLine.y=100;
				
			}
			
			if(lowLeftLine)
			{
				lowLeftLine.x=50;
				lowLeftLine.y=stage.stageHeight/2-100;
				
			}
			
			if(titleEffect)
			{
				titleEffect.y = stage.stageHeight*0.25;
			}
			
			if(_countriesListBox)
			{
				
				_countriesListBox.y=stage.stageHeight*.5;
				
			}
			
			if(_regionsListBox)
			{
				_regionsListBox.y=stage.stageHeight*.5+45;
			}
			
			if(_provinceListBox)
			{
				
				_provinceListBox.y=stage.stageHeight*.5+90;
				
			}
			
			if(map)
			{
				map.mapSize(stage.stageWidth-540,stage.stageHeight-100);
				map.x=520;
				map.y=20;
				
			}
			
			if(_searchAgainButton)
			{
				if(_resultsScroller)
				{
					_searchAgainButton.y=_resultsScroller.y+220;
				}
			}
			
		}
		
		
		private function _goToAdress($address:String):void
		{
			
			
		}
		
		
		
		private function onDirectionsLoaded(e:Event):void
		{
			
		}
		
		
		private function _createLines():void
		{
			
			topLeftLine= new DisappearingLine(420);
			lowLeftLine= new DisappearingLine(420);
			
			topLeftLine.x=50;
			topLeftLine.y=stage.stageHeight*.5;			
			lowLeftLine.x=50;
			lowLeftLine.y=stage.stageHeight*.5;
			
			TweenLite.to(topLeftLine,Styles.LONG_TRANSITION_TIME,{ease:Expo.easeOut,y:100});
			TweenLite.to(lowLeftLine,Styles.LONG_TRANSITION_TIME,{ease:Expo.easeOut,y:stage.stageHeight/2-100});
			
			addChild(topLeftLine);
			addChild(lowLeftLine);
			
			var firstDisappearingLine:DisappearingLine=new DisappearingLine(50);
			firstDisappearingLine.x=0;
			firstDisappearingLine.y=stage.stageHeight*.5;
			firstDisappearingLine.transitionOutFromCenter();
			
			addChild(firstDisappearingLine);
			
			var secondDisappearingLine:DisappearingLine=new DisappearingLine(stage.stageWidth-470);
			secondDisappearingLine.x=470;
			secondDisappearingLine.y=stage.stageHeight*.5;	
			secondDisappearingLine.transitionOutFromCenter();			
			addChild(secondDisappearingLine);
			
			
		}
		
		private function _createTitle():void
		{
			if(pageXml.title)
			{
				titleEffect = new TitleEffect(String(pageXml.title).toUpperCase());
				titleEffect.y = stage.stageHeight*0.25;
				titleEffect.build();
				titleEffect.x = 470-titleEffect.textWidth;
				//titleEffect.transitionInCompleteSignal.add(_onTransitionInTitleEffect);
				//titleEffect.transitionOutCompleteSignal.add(_onTransitionOutTitleEffect);
				this.addChild(titleEffect);
				//titleEffect.transitionIn();
			}
			
		}
		
		
		private function _createSubTitle():void
		{
			if(pageXml.subtitle)
			{
				subTitleEffect = new TitleEffect(String(pageXml.subtitle));
				subTitleEffect.style = Styles.ARCHER_BOOK_11_GREY_LIGHT_ABSTRACT;
				subTitleEffect.y = stage.stageHeight*0.25+20;
				subTitleEffect.build();
				subTitleEffect.x = 470-titleEffect.textWidth;
				//titleEffect.transitionInCompleteSignal.add(_onTransitionInTitleEffect);
				//titleEffect.transitionOutCompleteSignal.add(_onTransitionOutTitleEffect);
				this.addChild(subTitleEffect);
				subTitleEffect.transitionIn();
			}
			
			
			
		}
		
		
		private function _createResults(xml:XML):void
		{
			
			// dummy object for testing porpuses
			
			if(_resultsScroller)
			{
				_resultsScroller.removeChild(_containerResults);
				_containerResults=null;
				this.removeChild(_resultsScroller);
				_resultsScroller=null;
			}else
			{
				if(_containerResults)
				{
					this.removeChild(_containerResults);
					_containerResults=null;		
				}				
			}
			
			if(_countriesListBox.visible==true)
			{
				_countriesListBox.visible=false;
			}
			
			if(_provinceListBox)
			{
				this.removeChild(_provinceListBox);
				_provinceListBox=null;
			}
			
			if(_regionsListBox)
			{
				this.removeChild(_regionsListBox);
				_regionsListBox=null;
			}
			
			
			
			_createTextResult(_pathResult);
			_containerResults= new Sprite();			
			var numItems:Number=10;			
			var i:Number=0;
			
			
			
			
			for each (var store:XML in xml..store)
			{
				var dataObject:Object= new Object();
				dataObject.address= store.address;
				dataObject.cap=store.cap;
				dataObject.city=store.city;
				
				_storeResultsItem= new StoreResultsItem(_seeMapString,dataObject);
				_storeResultsItem.id=i;
				_storeResultsItem.build();
				_storeResultsItem.x=0;
				_storeResultsItem.y=i*StoreResultsItem.HEIGHT_ITEM;
				_storeResultsItem.transitionIn();
				_storeResultsItem.clickSignal.add(_clickSignalHandler);
				
				_containerResults.addChild(_storeResultsItem);
				
				i++;
				
			}
			
			if(numItems>StoreResultsItem.NUM_ITEMS)
			{
				
				_resultsScroller= new SmallScroller(_containerResults,443,199);
				_resultsScroller.x=50;
				_resultsScroller.y=stage.stageHeight*.5;
				addChild(_resultsScroller);
				
			}else
			{
				_containerResults.x=50;
				_containerResults.y=stage.stageHeight*.5;
				addChild(_containerResults);
			}
			
			_createSearchAgainBox()
			
		}
		
		
		
		private function _clickSignalHandler($index:Number):void
		{
			var address:String=(_containerResults.getChildAt($index) as StoreResultsItem).messageString;
			
			trace("geololazie map on adress"+address);
			
			map.goTo(address);
			
		}
		
		
		
		private function _createSearchAgainBox():void
		{
			
			var searchIcon:MovieClip=AssetManager.getItem('SearchSprite') as MovieClip;
			var searchSkin:Sprite= new Sprite();
			
			searchSkin.addChild(searchIcon);
			
			var searchText:SiteTextBuilder= new SiteTextBuilder(_searchAgainString.toUpperCase());
			searchText.objectFormat = Styles.ARCHER_BOOK_11_GREY_MEDIUM;
			searchText.objectField = Styles.TEXT_ADVANCED;
			
			searchText.x=10;
			searchText.y=10;
			
			searchSkin.addChild(searchText);
			
			
			_searchAgainButton= new PrimitiveButton();
			_searchAgainButton.addEventListener(PrimitiveButton.BUTTON_CLICKED,_searchedClickedHandler);
			_searchAgainButton.skin=searchSkin;
			
			_searchAgainButton.x=50;
			
			
			if(_resultsScroller)
			{
				_searchAgainButton.y=_resultsScroller.y+220;
				
			}else
			{
				
			}
			
			addChild(_searchAgainButton);
			
			
		}
		
		
		private function _searchedClickedHandler(e:Event):void
		{
			_closePanel();
		}	
		
		private function _closePanel():void
		{
			trace("_closePanel");
			
			
			TweenLite.to(_searchAgainButton,Styles.LONG_TRANSITION_TIME,{ease:Expo.easeOut,alpha:0});
			
			if(_resultsScroller)
			{
				
				TweenLite.to(_resultsScroller,Styles.LONG_TRANSITION_TIME,{ease:Expo.easeOut,alpha:0});
				
			}else
			{
				
				TweenLite.to(_containerResults,Styles.LONG_TRANSITION_TIME,{ease:Expo.easeOut,alpha:0});
				
			}
			
			setTimeout(_createSelectCountryListBox,1000);
			
			if(_resultText)
			{
				_resultText.transitionOut();
			}
			
		}
		
		
		
		private function _createTextResult($string:String):void
		{
			_resultText= new TitleEffect($string);
			_resultText.build();
			_resultText.x=50;
			_resultText.y=stage.stageHeight*.5-50;
			addChild(_resultText);
			_resultText.transitionIn();
			
		}
		
		
		
		private function _testWebService():void
		{
			
			
			var data:URLVariables = new URLVariables();
			data["location"]=_variableToSend;
			data["presentationtemplate"]="base/storesresult";
			
			
			var myRequest:URLRequest = new URLRequest();
			
			myRequest.url = "http://192.168.7.22/wps/wcm/connect/IT/sito/Store%20Locator/Store%20Locator";
			myRequest.method = URLRequestMethod.POST;
			myRequest.data = data;
			var loader:URLLoader = new URLLoader();
			
			loader.dataFormat=URLLoaderDataFormat.TEXT;
			addLoaderListeners(loader);
			
			try
			{
				loader.load(myRequest);
				
			}
			catch(error:Error)
			{
				trace('ERROr Sending mail ',error);
			}
			
		}
		
		private function addLoaderListeners(ldr:IEventDispatcher):void
		{
			
			ldr.addEventListener(Event.COMPLETE,onComplete);
			
		}
		
		
		
		
		private function onComplete(e:Event):void
		{
			
			_arrayObjectResults= new Array();
			var xmlResponse:XML= new XML(e.target.data);
			_createResults(xmlResponse);			
		}
		
		
		
		
		private function sortOnCustom(a:Object, b:Object):Number {
			var a0:Number = a.label;
			var b0:Number = b.label;
			
			if(a0 > b0) {
				return 1;
			} else if(a0 < b0) {
				return -1;
			} else  {
				//aPrice == bPrice
				return 0;
			}
		}
		
		
		
		override protected function extractData():void
		{
			
		}
		
		
		
		private function _createSelectProvinceListBox():void
		{
			
			_provinceListBox = new LuisaSpagnoliListBox(1,'Versions','Click',440,36);
			_provinceListBox.label = "Seleziona la provincia";
			_provinceListBox.addEventListener(ListBox.ON_LIST_CHANGED,onProvincesChangedHandler);
			_provinceListBox.dataProvider = _arrayProvincesAll;
			_provinceListBox.addEventListener(ListBox.EXPAND_LIST,onProvincesExpandList);
			_provinceListBox.listMenuPosition(ListBox.LIST_POSITION_CENTER_MIDDLE);
			_provinceListBox.build();
			_provinceListBox.x = 50;
			_provinceListBox.y=stage.stageHeight*.5+90;
			addChild(_provinceListBox);
			_provinceListBox.transitionIn();
			
		}
		
		
		private function _createSelectCountryListBox():void
		{
			
			_countriesListBox = new LuisaSpagnoliListBox(1,'Country','Click',440,36);
			_countriesListBox.label = "Seleziona il paese";
			_countriesListBox.addEventListener(ListBox.ON_LIST_CHANGED,onCountriesChangedHandler);
			_countriesListBox.dataProvider = _arrayCountries;
			_countriesListBox.addEventListener(ListBox.EXPAND_LIST,onCountriesExpandList);
			_countriesListBox.listMenuPosition(ListBox.LIST_POSITION_CENTER_MIDDLE);
			_countriesListBox.build();
			_countriesListBox.x = 50;
			_countriesListBox.y = stage.stageHeight*.5;
			addChild(_countriesListBox);
			_countriesListBox.transitionIn();
			
		}
		
		
		
		override protected function transitionInTween():void
		{
			super.transitionInTween();
			_countriesListBox.transitionIn();
			
			
			if(titleEffect)
			{
				titleEffect.transitionIn()
			}
			if(map)
			{
				TweenLite.to(map,Styles.LONG_TRANSITION_TIME,{ease:Expo.easeOut,alpha:1});
			}
			
		}
		
		override protected function transitionOutTween():void
		{
			super.transitionOutTween();
			
			if(topLeftLine)
			{
				topLeftLine.transitionOutFromCenter();
			}
			
			if(lowLeftLine)
			{
				lowLeftLine.transitionOutFromCenter();
			}
			
			
			if(titleEffect)
			{
				titleEffect.transitionOut()
			}
			
			if(subTitleEffect)
			{
				subTitleEffect.transitionOut();			
			}
			
			if(_countriesListBox)
			{
				_countriesListBox.transitionOut()
			}
			if(_regionsListBox)
			{
				_regionsListBox.transitionOut();
			}
			if(_provinceListBox)
			{
				_provinceListBox.transitionOut();
			}
			
			if(map)
			{
				TweenLite.to(map,Styles.LONG_TRANSITION_TIME,{ease:Expo.easeOut,alpha:0});
			}
			
			if(_resultText)
			{
				_resultText.transitionOut();
			}
			
			if(_searchAgainButton)
			{
				TweenLite.to(_searchAgainButton,Styles.LONG_TRANSITION_TIME,{ease:Expo.easeOut,alpha:0});
			}
			
			if(_resultsScroller)
			{
				
				TweenLite.to(_resultsScroller,Styles.LONG_TRANSITION_TIME,{ease:Expo.easeOut,alpha:0});
				
			}else
			{
				
			}
			
			setTimeout(onTransitionOutEnd,2000);
			
			
		}
		
		private function onCountriesChangedHandler(e:Event):void
		{
			
			var numListBox:Number = Number(_countriesListBox.selectedIndex);
			trace("on countries changed handler"+_arrayCountries[numListBox].value);
			
			var label:String=_arrayCountries[numListBox].value;
			
			
			_pathResult=_resultsString;
			_pathResult+=" ";
			_pathResult+=_arrayCountries[numListBox].label;
			
			
			_variableToSend=label;
			
			_createResults(_dummyXml);
			
			/*if(label==="base/IT")
			{
			trace("create second list box");
			_createSelectRegionListBox();
			_createSelectProvinceListBox();
			
			}else
			{				
			_testWebService();
			
			}*/
			
		}
		
		
		
		private function _createSelectRegionListBox():void
		{
			
			_regionsListBox= new LuisaSpagnoliListBox(2,'Regions','Click',440,36);
			_regionsListBox.label = "Seleziona la regione";
			_regionsListBox.addEventListener(ListBox.ON_LIST_CHANGED,onRegionChangedHandler);
			_regionsListBox.dataProvider = _arrayRegions;
			_regionsListBox.addEventListener(ListBox.EXPAND_LIST,onRegionExpandList);
			_regionsListBox.listMenuPosition(ListBox.LIST_POSITION_CENTER_MIDDLE);
			_regionsListBox.build();
			_regionsListBox.x = 50;
			_regionsListBox.y = stage.stageHeight*.5+45;
			addChild(_regionsListBox);
			_regionsListBox.transitionIn();
			
		}
		
		
		private function onRegionChangedHandler(e:Event):void
		{
			_pathResult +="/" 
			var numListBox:Number = Number(_regionsListBox.selectedIndex);
			_pathResult +=_arrayRegions[numListBox].label;
			trace("on region changed handler"+_arrayRegions[numListBox].value);
			_variableToSend=_arrayRegions[numListBox].value;
			_testWebService();
			
		}
		
		
		private function onProvincesChangedHandler(e:Event):void
		{
			trace("on provinces changed handler");
			
			var numListBox:Number = Number(_provinceListBox.selectedIndex); 
			
			trace("on province changed handler"+_arrayProvincesAll[numListBox].value);
			
			
			_pathResult +="/" 
			_pathResult +=_arrayProvincesAll[numListBox].label;
			
			
			_variableToSend=_arrayProvincesAll[numListBox].value;
			
			_testWebService();
			
		}
		
		
		private function onCountriesExpandList(e:Event):void
		{
			
			this.setChildIndex(_countriesListBox,this.numChildren - 1);
			
		}
		
		private function onProvincesExpandList(e:Event):void
		{
			
			this.setChildIndex(_provinceListBox,this.numChildren - 1);
			
		}
		
		private function onRegionExpandList(e:Event):void
		{
			
			this.setChildIndex(_regionsListBox,this.numChildren - 1);
			
		}
		
		
		private function _addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,_addedToStage);
			
		}
		
		
		override protected function destroy(e:Event=null):void
		{
			
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);			
			
		}
		
		
	}
}
