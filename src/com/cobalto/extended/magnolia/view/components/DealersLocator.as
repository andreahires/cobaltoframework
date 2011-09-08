package com.cobalto.extended.magnolia.view.components
{
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.MapOptions;
	import com.google.maps.StyledMapType;
	import com.google.maps.StyledMapTypeOptions;
	import com.google.maps.View;
	import com.google.maps.controls.*;
	import com.google.maps.overlays.*;
	import com.google.maps.services.ClientGeocoder;
	import com.google.maps.services.GeocodingEvent;
	import com.google.maps.styles.FillStyle;
	import com.google.maps.styles.MapTypeStyle;
	import com.google.maps.styles.MapTypeStyleFeatureType;
	import com.google.maps.styles.MapTypeStyleRule;
	import com.cobalto.api.IViewComponent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import gs.*;
	import com.greensock.easing.*;
	
	/*
	This class is used to interact with Google Maps.
	It allow geocoding, routing, and printing.
	It is also possible to customize colors of the map.
	
	***IMPORTANT***
	Remember to add src/gmaps/lib/map_1_18.swc into your
	project libraries building path.
	*/
	public class DealersLocator extends Sprite implements IViewComponent
	{
		
		protected static var _gMapsKey:String;	
		private var _map:Map = new Map();
		private var _mapLayer:Sprite = new Sprite;
		private var _width:uint;
		private var _height:uint;
		private var _currentLocation:LatLng;
		private var mapReady:Boolean = false;
		private var _geocoder:ClientGeocoder;
		private var _addressesList:Array;
		private var _name:String;
		private var _address:String;
		private var _phone1:String;
		private var _phone2:String;
		private var _latLng:LatLng;
		private var _maxDistance:Number = 20; //maximum distance in km 
		private var pageId:int;
		
		//Style vars
		private var markerStrokeStyle:uint = 0x000000;
		private var markerFill:uint = 0x949493 ;
		private var markerHasShadow:Boolean = false;
		private var infoStrokeStyle:uint =  0x000000;
		private var infoFill:uint = 0x000000 ;
		private var infoHasShadow:Boolean = false;
		private var _showInfoBox:Boolean = true;
		
		private var _currentTweener:TweenMax;
		public static const MAP_READY:String = "mapReady";
		public static const CURRENT_ADDRESS_SET:String = "currentAddressSet";
		
		
		protected var styledMapType:StyledMapType 
		
		//** The constructor is used to iniziate the map and set it's size 
		// @param - lat: initial latitude value - lon: initial longitude value 
		public function DealersLocator()
		{
			super();
		}
		
		
		
		
		//MAP SETUP ----------------------------------------------------------------------
		
		
		//**This function is used to init the map
		public function build():void
		{
			_map = new Map();
			_map.sensor="false";
			_map.addEventListener(MapEvent.MAP_PREINITIALIZE, onMapPreinitialize);
			_map.addEventListener(MapEvent.MAP_READY, onMapReady);
			
			//ExternalInterface.call( "console.log" , "DealerLocator apiKey =="+_gMapsKey);
			if (_gMapsKey != null)
			{
				//ExternalInterface.call( "console.log" , "build DealerLocator apiKey true");
				_map.key = _gMapsKey;
				_mapLayer.addChild(_map);
				this.addChild(_mapLayer);
			} 
			else
			{
				throw new Error("API-KEY is Missing! - must set apiKey before building the map");	
				//ExternalInterface.call( "console.log" , "DealerLocator API-KEY is Missing! - must set apiKey before building the map");
			}
		}
		
		//** This function is used to setUp map starting condition
		private function onMapPreinitialize(e:Event):void
		{
			//ExternalInterface.call( "console.log" , "Locator onMapPreinitialize");
			_map.removeEventListener(MapEvent.MAP_PREINITIALIZE, onMapPreinitialize);
			var mapOptions:MapOptions = new MapOptions();
			if ( _currentLocation != null)
			{
				mapOptions.center = _currentLocation;
			} else {
				mapOptions.center = new LatLng(41.54,12.29);
			}
			mapOptions.zoom = 5;
			mapOptions.viewMode = View.VIEWMODE_PERSPECTIVE;
			_map.setInitOptions(mapOptions);
			
			
			
		}
		
		//** This function is used to setUp default map behaviour and dispatch a MAP_READY event
		private function onMapReady(e:Event):void
		{
			
			
			var housesStyles:Array = [new MapTypeStyle(MapTypeStyleFeatureType.ALL,MapTypeStyleFeatureType.ALL,[MapTypeStyleRule.hue(0xfaf9f7),MapTypeStyleRule.saturation(-60),MapTypeStyleRule.invert_lightness(false)])];
			
			var styledMapOptions:StyledMapTypeOptions = new StyledMapTypeOptions({name:'Houses',alt:'Houses'});
			
			styledMapType = new StyledMapType(housesStyles,styledMapOptions);
			
			
			
			
			_map.addMapType(styledMapType);
			
			var milano:LatLng = new LatLng(45.4636889,9.1881408);
			
			_map.setCenter(milano,12,styledMapType);
			
			
			//ExternalInterface.call( "console.log" , "Locator onMapReady");
			_map.removeEventListener(MapEvent.MAP_READY, onMapReady);
			_map.enableContinuousZoom();
			_map.scrollWheelZoomEnabled();
			//_map.addControl(new PositionControl());
			var topRight:ControlPosition = new ControlPosition(ControlPosition.ANCHOR_TOP_RIGHT, 20, 50);
			var zoomControll:ZoomControl = new ZoomControl();
			zoomControll.setControlPosition(topRight);
			_map.addControl(zoomControll);
			mapReady = true;
			dispatchEvent(new Event(DealersLocator.MAP_READY));
		}
		
		
		
		//PUBLIC FUNCTIONS ------------------------------------------------------------------
		
		
		//**This function is used to change the API key, must be called before building the map
		public function set apiKey(key:String):void
		{
			_gMapsKey = key;
		}
		public function get apiKey():String
		{
			return _gMapsKey;
		}
		
		public function set id(pageId:int):void
		{
			this.pageId = pageId;
		}
		
		public function get id():int
		{
			return pageId;
		}
		
		public function organizeItems():void
		{
			
		}
		
		public function get map():Map
		{
			return _map;
		}
		
		
		
		//** This function is used to return a series of markers from an XML of address
		public function findList(addressesList:XML):void
		{
			_addressesList = new Array();
			
			//*parse the XML and push the result into  _addressesList:Array
			for each (var dealer:XML in addressesList.dealer) 
			{
				_name = dealer.companyname;
				_phone1 = dealer.phone1;
				_phone2 = dealer.phone2;
				_address = dealer.address +" "+  dealer.city +" "+ dealer.cap;
				
				//geocode address
				_geocoder = new ClientGeocoder();
				_geocoder.addEventListener(GeocodingEvent.GEOCODING_SUCCESS,onFind);
				_addressesList.push({name:_name, address:_address, phone1:_phone1, phone2:_phone2, latLon:"none", distance:0});
				_geocoder.geocode(_address)
			}
			
		}  
		
		//** This function is used to return a marker from an XML
		public function find(address:XML):void
		{
			//ExternalInterface.call( "console.log" , "Locator findAddress");
			_addressesList = new Array();
			
			_name = address.companyname;
			_phone1 = address.phone1;
			_phone2 = address.phone2;
			_address = address.address +", "+ address.city +", "+ address.cap;
			
			//geocode address
			_geocoder = new ClientGeocoder();
			_geocoder.addEventListener(GeocodingEvent.GEOCODING_SUCCESS,onFindAndGo);
			_addressesList.push({name:_name, address:_address, phone1:_phone1, phone2:_phone2, latLon:"none", distance:0});
			_geocoder.geocode(_address)
			
		}  			
		
		//** This function is used to return latLong values from an array of address
		public function currentAddress(currentAddress:String):void
		{
			if (mapReady == false){return;}
			_geocoder = new ClientGeocoder();            
			_geocoder.addEventListener(GeocodingEvent.GEOCODING_SUCCESS,onCurrentAddress);
			_geocoder.geocode(currentAddress);
		}
		
		//**This function is used to move the map to a given location
		public function goTo(address:String):void
		{
			//ExternalInterface.call( "console.log" , "Locator GoTo");
			if (mapReady == false){return;}
			_geocoder= new ClientGeocoder();            
			_geocoder.addEventListener(GeocodingEvent.GEOCODING_SUCCESS,onGoTo);
			_geocoder.geocode(address);
		}
		
		//**This function is used to evaluate the root between two addreses
		public function routTo(origin:String,destination:String):void
		{
			//TODO routTo	
		}
		
		
		//** This function change map colors to grayscale
		public function grayScale():void
		{
			var R:Number = 0.20;  var G:Number = 0.1; var B:Number = 0.6; var S:Number = 20;  
			var grayscale:Array = [  
				R, G, B, 0, S,  
				R, G, B, 0, S,
				R, G, B, 0, S,  
				0, 0, 0, 1, 0];  
			var invert:Array = [  
				-1, 0, 0, 0, 255,  
				0, -1, 0, 0, 255,
				0, 0, -1, 0, 255,  
				0, 0, 0, 1, 0]; 
			
			var CMF:ColorMatrixFilter = new ColorMatrixFilter(grayscale);
			var CMF2:ColorMatrixFilter = new ColorMatrixFilter(invert);
			_mapLayer.filters = [CMF];
			this.filters = [CMF2];
		}
		
		//** This function is used for the transition IN
		public function transitionIn():void
		{
		}
		
		//** This function is used for the transition OUT
		public function transitionOut():void
		{
		}
		
		//** This function is used to change markers style
		//@param - stroke: stroke color - fill: fill color - radius: marker radius -shadow:boolean
		public function markerStyle(stroke:uint, fill:uint, shadow:Boolean ):void
		{
			markerStrokeStyle =  stroke;
			markerFill = fill ;
			markerHasShadow = shadow;
		}
		
		//** This function is used to setup infowindows style
		//@param - stroke: stroke color - fill: fill color - radius: marker radius -shadow:boolean
		public function infoStyle(stroke:uint, fill:uint, shadow:Boolean ):void
		{
			infoStrokeStyle =  stroke;
			infoFill = fill ;
			infoHasShadow = shadow;
		}
		
		//** This function can be used to override the maximum distance search tollerance
		public function set maxDistance(maxDistance:Number):void
		{
			_maxDistance = maxDistance
		}
		
		//** used to change the size of the map
		// @param - obj.width:Number -obj.height:Number
		public function mapSize(width:Number,  height:Number):void
		{
			_map.setSize(new Point(width,height));
		}
		
		
		
		
		//PRIVATE FUNCTIONS ------------------------------------------------------------------
		
		//**This function is used to evaluate distance of the given location and add a mraker to the screen
		// @param object - (name:String, address:String, telephone:String, latLon:LatLon, distance:Number)
		private function evaluateDistance(obj:Object):void
		{			
			//evaluate distance
			var distance:Number = _currentLocation.distanceFrom(obj.latLon);
			
			//copy distance into _addressesList array
			var num:uint = _addressesList.length;
			for (var i:uint = 0; i < num; i++)
			{
				if ( _addressesList[i].address == obj.address)
				{
					_addressesList[i].distance = distance/1000;
					addMarker(_addressesList[i]);
				}
			}			
			
		} 
		
		//**This function is used to add a marker for a given object
		// @param object - (name:String, address:String, telephone:String, latLon:LatLon, distance:Number)
		private function addMarker(obj:Object):void
		{
			//ExternalInterface.call( "console.log" , "Locator add Marker");
			if (obj.distance <= _maxDistance)
			{
				var options:MarkerOptions = new MarkerOptions({
					tooltip: obj.name,
					clickable: true,
					strokeStyle: {color: markerStrokeStyle},
					fillStyle: new FillStyle({color: markerFill, alpha: 1}),
					hasShadow: markerHasShadow
				});
				var marker:Marker = new Marker(obj.latLon,options);
				
				var name:String = "";
				var telephone:String = "";
				var address:String =  "<b>address: </b>" + obj.address + ".";
				if (obj.name != undefined){name = "<b>"+obj.name+"</b>"};
				if (obj.phone1 != undefined){telephone =  "phone: " + obj.phone1};
				if (obj.phone2 != undefined){telephone =  "<b>phone: </b>" + obj.phone1 + " - "+ obj.phone2};
				var content:String =  "<p>" +address+ "</p>" +"<br>" +"<p>" + telephone + "</p>";
				
				//create infowindow
				if ( _showInfoBox )
				{
					var titleFormat:TextFormat = new TextFormat("Arial", 20,null, true);
					var contentFormat:TextFormat = new TextFormat("Arial", 10);
					var infoWindow:InfoWindowOptions = new 
						InfoWindowOptions({
							titleFormat: titleFormat,
							titleHTML: name, contentHTML: content, width:300,
							strokeStyle: {color: infoStrokeStyle},
							fillStyle: new FillStyle({color: infoFill, alpha: 1}),
							hasShadow: infoHasShadow
						})
				}
				
				//* On Maker click display an infowindow and flyTo location
				marker.addEventListener(MapMouseEvent.CLICK, function():void 
				{
					if ( _showInfoBox )
						marker.openInfoWindow(infoWindow);
					_map.panTo(obj.latLon);
					_map.setZoom(14,true);
				});
				
				_map.clearOverlays();
				_map.addOverlay(marker);
				
				//Open last marker infowindow
				if (_showInfoBox)
					marker.openInfoWindow(infoWindow);
			}		
		}
		
		
		
		//LISTENERS -----------------------------------------------------------------------
		
		//**this function is used to push locations into the array
		private function onFind(e:GeocodingEvent):void
		{
			var placemarks:Array = e.response.placemarks;
			//_latLng = placemarks[0].point;
			var num:uint = _addressesList.length;
			for (var i:uint = 0; i < num; i++)
			{
				if ( _addressesList[i].address == e.name)
				{
					_addressesList[i].address = placemarks[0].address;
					_addressesList[i].latLon = placemarks[0].point;
					//trace(_addressesList[i].name, _addressesList[i].address, _addressesList[i].telephone, _addressesList[i].latLon, _addressesList[i].distance);
					if (_currentLocation != null)
					{
						//						trace("evaluating distance");
						evaluateDistance(_addressesList[i]);
						return;
					} else {
						//						trace("directly add");
						addMarker(_addressesList[i]);
					}
					
				}
			}
		}
		
		//**Similar to onFind but also go to the added marker
		private function onFindAndGo(e:GeocodingEvent):void
		{
			var placemarks:Array = e.response.placemarks;
			
			var num:uint = _addressesList.length;
			for (var i:uint = 0; i < num; i++)
			{
				if ( _addressesList[i].address == e.name)
				{
					_addressesList[i].address = placemarks[0].address;
					_addressesList[i].latLon = placemarks[0].point;
					
					//Add marker
					addMarker(_addressesList[i]);
					
					//GoTo
					
					//_map.setCenter(_addressesList[i].latLon,12,styledMapType);
					_map.setZoom(14,true);
					
				}
			}
		}
		
		//** This function is used to place a maker and center the map on the current location
		private function onCurrentAddress(e:GeocodingEvent):void
		{
			var placemarks:Array = e.response.placemarks;
			_currentLocation = placemarks[0].point;
			//addMarker({address:placemarks[0].address, latLon:placemarks[0].point, distance:0});
			dispatchEvent(new Event(DealersLocator.CURRENT_ADDRESS_SET));
		}
		
		//** This function is used to place location markers on the map and got to it
		private function onGoTo(e:GeocodingEvent):void
		{
			var placemarks:Array = e.response.placemarks;
			_map.panTo(placemarks[0].point);
			_map.setZoom(14,true);
			_geocoder.removeEventListener(GeocodingEvent.GEOCODING_SUCCESS,onGoTo);
			addMarker({address:placemarks[0].address, latLon:placemarks[0].point, distance:0});
		}
		
		public function set showInfoBox(value:Boolean):void
		{
			_showInfoBox = value; 
		}
		
		
	}
}