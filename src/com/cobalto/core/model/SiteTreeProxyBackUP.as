package com.cobalto.core.model{	import com.cobalto.ApplicationFacade;	import com.cobalto.loading.CustomXmlLoader;	import com.cobalto.loading.XmlLoader;	import com.cobalto.utils.StringUtils;		import flash.errors.IllegalOperationError;	import flash.events.Event;	import flash.utils.setTimeout;		import org.puremvc.as3.interfaces.IProxy;	import org.puremvc.as3.patterns.proxy.Proxy;		public class SiteTreeProxyBackup extends Proxy implements IProxy	{				// *** Cannonical name of the Proxy		public static const NAME:String = 'SiteTreeProxy';				// ** the array of the root level of the site Tree		protected var siteTreeArray:Array = new Array();				// ** the array of the subLevels level of the site Tree		protected var subTreeArray:Array = new Array();				// ** the array of the subLevels URL 		protected var siteSubURLArray:Array = new Array();				// *** ???		protected var storeArray:Array = new Array();				// *** the array of the xmlLoaders?		protected var loaderArray:Array = new Array();				// ** a counter useful to undestand if all the xml 		// ** is fully loaded before to dispatch the complete notification		protected var xmlLoaderNum:int = 0;				// ** ???		protected var stringFound:Boolean = false;				//** ???		protected var indicesArray:Array = new Array;				//** the total of the loaded xml		protected var loadedXml:int = 0;				public function SiteTreeProxy(dataRef:Object)		{			super(NAME,dataRef);		}				override public function onRegister():void		{			loadSiteTree();		}				//** load the first level xml		protected function loadSiteTree():void		{						var xmlLoader:XmlLoader = new XmlLoader(dataSource);			xmlLoader.addEventListener(XmlLoader.XML_AVAILABLE,onSiteTreeLoaded);					//setTimeout(dispatchTreeLoaded,5000);		}				// ** when the first xml is loaded 		protected function onSiteTreeLoaded(e:Event=null):void		{						var treeData:XMLList = new XML(e.target.textData).section;			// ** store the loaded data into an array			writeXMLListToArray(treeData,siteTreeArray);						// ** start the subLevels xml loaders			loadSubDataTree(siteTreeArray);		}				//** store the loaded XmlData on an array		//** @param treeDataSource - the xmlList of the sections		//** @param treeArray - the array used to store the data		protected function writeXMLListToArray(treeDataSource:XMLList,treeArray:Array):void		{						var treeLength:uint = treeDataSource.length();						// ** it loops through all the nodes of the level			for(var i:int = 0;i < treeLength;i++)			{				//*** create a new array to store the assets				var assetListArray:Array = new Array();								//*** setup a XmlList for the assets				var assetXMLList:XMLList = treeDataSource[i].assets.asset;								//*** if there are any asset to load				if(assetXMLList.length() > 0)				{										//** loop through the assetList					var assetLength:uint = assetXMLList.length();										for(var j:int = 0;j < assetLength;j++)					{						//*** store the asset url composed with the baseURL received through flashvars and the type 						assetListArray.push({url:ApplicationFacade.baseURL + assetXMLList[j].@url.toString(),type:assetXMLList[j].@type.toString()});					}									}				else				{					//*** if there are not assets it erase the assetArray instance					assetListArray = null;				}								var treeURLStr:String = String(treeDataSource[i].@treeUrl);				var showSubMenu:String = String(treeDataSource[i].@showsubmenu);				var hasChildren:String = String(treeDataSource[i].@hasChildren);								//*** check if the treeUrl is really empty				(StringUtils.isEmpty(treeURLStr)) ? treeURLStr = null : treeURLStr = ApplicationFacade.baseURL + treeURLStr;								treeArray.push({label:treeDataSource[i].@title,refClass:treeDataSource[i].@refclass.toString(),address:treeDataSource[i].@url,pageTitle:treeDataSource[i].@pageTitle,flow:treeDataSource[i].@flow.toString(),link:treeDataSource[i].@link,treeURL:treeURLStr,hasChildren:hasChildren,showSubMenu:showSubMenu,assetList:assetListArray,depth:treeDataSource[i].@depth,hide:treeDataSource[i].@hide,subMenu:[]});								if(treeDataSource[i].@refclass.toString() == "ErrorPage")					ApplicationFacade.ERROR_PAGE_ADDRESS = treeDataSource[i].@url;							}				}				//** load the subDataTrees after the first level and iterate through all the nested level		protected function loadSubDataTree(treeArray:Array):void		{						var subTreeLength:uint = treeArray.length;						// *** loop through the nodes of the array			for(var i:int = 0;i < subTreeLength;i++)			{				//*** find if the xml node has childrens				if(hasChildren(treeArray[i]))				{					getArrayFromXML(treeArray[i].treeURL,treeArray[i]);				}			}				}				//** start the loader of the requested url passing the reference of the parent array				protected function getArrayFromXML(str:String,parentMenuNode:Object):void		{						//*** the parent array is useful to push the data array inside the tree array			var xmlLoader:CustomXmlLoader = new CustomXmlLoader(str,parentMenuNode);			loaderArray.push(xmlLoader);			xmlLoader.addEventListener(XmlLoader.XML_AVAILABLE,onxmlAvailable);		}				private function onxmlAvailable(e:Event):void		{						//*** create a temp array to store the loaded value			var arr:Array = [];						if(new XML(e.target.textData))			{				//*** store the loaded value into the new array				writeXMLListToArray(new XML(e.target.textData).section,arr);			}			else			{				throw new IllegalOperationError("error parsing the xml" + e.target);			}			//*** get the parent node data object			var parentArrayNode:Object = e.target.dataObject;						//*** store a copy of the array into the parent array			parentArrayNode.subMenu = arr;						//*** try to load the nested submenus for this node			loadSubDataTree(arr.concat());						//*** remove the first item of the loaders array			loaderArray.shift();						//*** if the loaders array is empty			if(loaderArray.length == 0)			{				//*** loop through the first level menu				var siteTreeArrayLength:uint = siteTreeArray.length;								for(var i:int = 0;i < siteTreeArrayLength;i++)				{					//*** set the subMenus for the first level					setSubMenuArray(siteTreeArray[i],i);				}				//*** inform the sistem that the full tree is loaded								dispatchTreeLoaded();					//trace(subTreeArray[1][0].subMenu[0].pageTitle+" subTreeArray");					//trace(siteTreeArray[1].subMenu[0].subMenu[0].pageTitle+" siteTreeArray");			}		}				protected function dispatchTreeLoaded():void		{			sendNotification(ApplicationFacade.SITE_TREE_AVAILABLE);		}				//** this function is useful to popolate the array od the subLevels (almost a copy of the siteTreeArray)		private function setSubMenuArray(obj:Object,index:int):void		{			var indexInt:int = index;						//*** if the array of the subLevel is empty it create a new array			if(!subTreeArray[indexInt])			{				subTreeArray[indexInt] = new Array();			}						//*** if the object hasChildren			if(hasChildren(obj))			{				subTreeArray[indexInt] = sortSubMenuArray(obj);			}				}				//*** populate the multidimensional array of the tree (subTreeArray) with the data of the siteTreeArray		protected function sortSubMenuArray(obj:Object):Array		{			var menuArray:Array = [];			var subMenuLength:uint = obj.subMenu.length;						for(var i:int = 0;i < subMenuLength;i++)			{				menuArray.push(obj.subMenu[i]);			}			return menuArray;				}				//*** API to get filtered contents		//*** @param index - the firstLevel menu index		//*** @param levelArray - the array that contains the indexes for the nested levels		protected function getSubMenuArray(index:int,levelArray:Array=null):Array		{			// *** create a temp array			var array:Array = [];						//** to store the length of the indexArray			var levelArrayLength:int;						//*** if exist the nested levels it means we're trying to get the data of a subMenu			if(levelArray)			{				levelArrayLength = levelArray.length;								//*** get the subTreeArray node of the root menu at the requested index				array = subTreeArray[index];								//trace(array+" array????at index: "+index,' LEVEL ARRAY : ',levelArray);				//*** loop throught the nested levels (except the root one)				for(var i:int = 0;i < levelArrayLength;i++)				{					// ** trace('IValue : ', i);					// ** get the index for each level					var id:int = levelArray[i];										//** if the second level					if(array[id] != null)					{						if(hasSubMenu(array[id]))						{							array = array[id].subMenu;						}						else						{							array = null;						}					}					else					{						array = null;					}									}								if((array != null) && (array.length > 0))				{					array = getObjectArray(array)				}							}			else			{				if(subTreeArray[index].length > 0)				{					array = getObjectArray(subTreeArray[index])				}				else				{					array = null;				}			}						return array;		}				private function hasChildren(menuObject:Object):Boolean		{			var boolValue:Boolean = false;						if(menuObject.hasChildren == "true")			{				boolValue = true;			}			return boolValue		}				protected function hasSubMenu(menuObject:Object):Boolean		{			var boolValue:Boolean = false;						if(menuObject.showSubMenu == 'true' && menuObject.hasChildren == 'true')			{				boolValue = true;			}						return boolValue;		}				public function hasMenuVisible():Boolean		{			return true;		}				private function getObjectArray(arr:Array):Array		{			var array:Array = [];						for(var j:int = 0;j < arr.length;j++)			{				array.push(arr[j])			}			return array;		}				public function getMenuData():Array		{			var itemArray:Array = new Array();						for(var j:int = 0;j < siteTreeArray.length;j++)			{				if(siteTreeArray[j].hide == "false")				{					itemArray.push(siteTreeArray[j].label);				}				else				{					itemArray.push(ApplicationFacade.MENU_HIDDEN_LABEL);				}			}						return itemArray;		}				public function getSubMenuData(index:int,levelArray:Array=null):Array		{			var array:Array = [];			var sourceArray:Array;						if(levelArray)			{				sourceArray = getSubMenuArray(index,levelArray);			}			else			{				if(hasSubMenu(siteTreeArray[index]))				{					sourceArray = getSubMenuArray(index);				}			}						if(sourceArray)			{				for(var j:int = 0;j < sourceArray.length;j++)				{					if(sourceArray[j].hide == "false")					{						array.push(sourceArray[j].label);					}					else					{						array.push(ApplicationFacade.MENU_HIDDEN_LABEL);					}				}			}						return array;		}				private function getObjectElements(indexArray:Array):Object		{			var elementObject:Object = {};			var topLevelId:int;			var lastIndex:int;						if(indexArray)			{				if(indexArray.length > 1)				{					topLevelId = indexArray.shift();					lastIndex = indexArray.pop();					var subArray:Array = getSubMenuArray(topLevelId,indexArray);										if(subArray)					{						elementObject = subArray[lastIndex];					}				}				else if(indexArray.length == 1)				{					elementObject = siteTreeArray[indexArray[0]];				}			}						return elementObject;		}				public function getAssetList(indexArray:Array):Array		{			return getObjectElements(indexArray).assetList as Array;		}				public function getFlowType(indexArray:Array):String		{						return getObjectElements(indexArray).flow as String;		}				public function getDepth(indexArray:Array):uint		{			return int(getObjectElements(indexArray).depth);		}				public function getRefClass(indexArray:Array):String		{			return getObjectElements(indexArray).refClass as String;		}				public function getRefClassArray(indexArray:Array):Array		{			var subMenu:Array = getObjectElements(indexArray).subMenu;			var arr:Array = new Array();						for(var i:uint = 0;i < subMenu.length;i++)			{				var refClass:String = subMenu[i].refClass;				arr.push(refClass);			}						return arr;		}				public function getAddress(indexArray:Array):String		{			return getObjectElements(indexArray).address.toString() as String;		}				public function getPageTitle(indexArray:Array):String		{			//trace(getObjectElements(indexArray).pageTitle+" indexPageTitle");			return getObjectElements(indexArray).pageTitle.toString() as String;		}				//*** this function scan all the level of the array until he match the requested address		//*** it return the index array for that specific URI		public function getIndexArrayFromAddress(address:String):Array		{			//*** create the temp array to return			var indexArray:Array;						//** if the address is not the root			if(address != "/")			{				// *** create a temp array useful to build the results indices				var resultArray:Array = new Array();								//*** it pass the root array as first to scan				indexArray = scanTreeLevelAddress(siteTreeArray,address,resultArray);								//*** free the memory of the result				resultArray = null;			}			else			{				//** if the requested array is the root it just return the home index ( 0 )				indexArray = [0];			}			return indexArray;		}				///*** the function loop thought the passed tree array until he find the match of the address		//*** if it doesn't find anything return null		protected function scanTreeLevelAddress(treeArray:Array,address:String,indexArrayToCompose:Array):Array		{			//*** store the length of the temp array that store the result indexes			var startResultArrayLength:int = indexArrayToCompose.length;			var treeLength:uint = treeArray.length;						//** loop through the nodes of the tree			for(var i:int = 0;i < treeLength;i++)			{				// *** just push the i as indexes as attempt				//*** if it this loop item doen't find the match it will be removed (pop)				indexArrayToCompose.push(i);								//*** compare the address with the one stored in the subMenu array object				if(String(treeArray[i].address).toUpperCase() == address.toUpperCase())				{					//** if the url match return immediatly the indexArray, found!!!					return indexArrayToCompose;				}				else				{					//** if the address of the node doesn't match it check if the node has a subMenu					if(hasSubMenu(treeArray[i]))					{						//** if the node has the subLevel it scan the subLevel recursively						var result:Array = scanTreeLevelAddress(treeArray[i].subMenu,address,indexArrayToCompose);												//** if the result is not null and the length of the result is mayor of the one						//** register in the beginning of this function						//** it means that there are not matching for this node						if(result && startResultArrayLength < indexArrayToCompose.length)						{							//**  return immediatly the indexArray, found!!!							return indexArrayToCompose;						}						else						{							//*** if the result is null or of the same length of the start one							//*** remove the element pushed at the beginning of the loop							// *** to allow it to restart the loop with the next i							indexArrayToCompose.pop();						}					}					else					{						//*** if the node doesn't have a subMenu						//*** remove the element pushed at the beginning of the loop						// *** to allow it to restart the loop with the next i						indexArrayToCompose.pop();					}				}			}						//** if the length is 0 or egual to the start one just return null			//** in this way we can undestand if the match exist or not for this level			if(indexArrayToCompose.length == 0 || startResultArrayLength == indexArrayToCompose.length)				indexArrayToCompose = null;			return indexArrayToCompose;				}				/* 	public function getIndexArrayFromAddressOld(address:String):Array		   {		   var indexArray:Array;				   if(address != "/")		   {		   stringFound = false;		   //indicesArray = [];		   indexArray = scanTreeLevelAddress(siteTreeArray, address);		   //indicesArray = [];		   }else{		   indexArray = [0];		   }		   return indexArray;		 } */				/* protected function scanTreeLevelAddressold(treeArray:Array, address:String):Array		   {		   var nodeIndices:Array;				   for(var i:int=0; i<treeArray.length; i++)		   {		   nodeIndices = new Array();		   nodeIndices.push(i);				   if(String(treeArray[i].address).toUpperCase() == address.toUpperCase())		   {		   return nodeIndices;		   break;		   }		   else		   {		   var obj:Object = getIndicesFromObject(treeArray[i],address);				   if(obj.match==true)		   {		   stringFound=false;		   return nodeIndices.concat(obj.indices);		   }				   }		   }				   //nodeIndices=[];		   nodeIndices = null;		   return nodeIndices;		   }				   protected function getIndicesFromObject(dataObject:Object, address:String):Object		   {		   var obj:Object={};		   if(dataObject.subMenu!=null)		   {		   obj = getIndicesFromArray(dataObject.subMenu,address);		   }				   return obj;		   }				   protected function getIndicesFromArray(subMenuArray:Array,address:String):Object		   {		   var counter:int = 0;		   var length:int = subMenuArray.length;		   for(var i:int=0; i<length; i++)		   {		   if(String(subMenuArray[i].address).toUpperCase() == String(address).toUpperCase())		   {		   indicesArray.push(i);				   stringFound = true;		   return {indices:indicesArray,match:stringFound};		   break;		   }		   else if(subMenuArray[i].subMenu && stringFound == false)		   {		   indicesArray.push(i);		   getIndicesFromArray(subMenuArray[i].subMenu,address);		   }		   else if (stringFound == false && i>2)		   {		   indicesArray.pop();		   }		   }		   return {indices:indicesArray,match:stringFound};		   }		 */				public function getTree():Array		{			return siteTreeArray;		}				protected function get dataSource():String		{			return data as String;		}				public function getSubMenuURL(index:int):String		{			return String(siteSubURLArray[index].treeURL);		}		}}