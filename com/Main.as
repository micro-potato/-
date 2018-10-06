package com {
	
	import com.mc.BaseLv;
	import com.mc.MC_Start;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	
	public class Main extends BaseMovie {
		
		private var _lvs:Array;
		private var _currentLvName:String;
		private var _record:Object;//result,["lv1",1]
		private var _farEndSuccessLvName:String;
		
		public static var Instance:Main;
		public function Main() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			super.Init();
			Instance = this;
			_lvs = ["lv1", "lv2", "lv3", "lv4", "lv5"];
			EventMaster.getInstance().addEventListener(EventMaster.OnHomeClick, OnHomeBtnClick);
			ChangeScene(new MC_Start());
			
			//test
			//LoadLv(3);
		}
		
		public function ChangeScene(mc:MovieClip)
		{
			this.removeChildren();
			this.addChild(mc);
		}
		
		public function OnStart()
		{
			LoadOpenning();
		}
		
		function LoadOpenning():void 
		{
			var path:String = "Opening.swf";
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnOpeningLoaded);
			loader.load(new URLRequest(path));
		}
		
		function OnOpeningLoaded(e:Event):void 
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, OnOpeningLoaded);
			var openning:MovieClip = loaderInfo.content as MovieClip;
			ChangeScene(openning);
			openning.addEventListener(Event.COMPLETE, OnOpeningFinish);
		}
		
		function OnOpeningFinish(e:Event):void 
		{
			trace("check openning");
			e.currentTarget.removeEventListener(Event.COMPLETE, OnOpeningFinish);
			LoadNextLv();
		}
		
		function LoadNextLv():void 
		{
			var indextoLoad:int;
			if (_currentLvName == null)//no lv loaded yet
			{
				indextoLoad = 0;
				LoadLv(indextoLoad);
			}
			else
			{
				var currentLvIndex = _lvs.indexOf(_currentLvName);
				if (currentLvIndex == _lvs.length - 1)//all lvs loaded
				{
					LoadResultPage();
				}
				else
				{
					indextoLoad = currentLvIndex + 1;
					//trace("to load lv:" + indextoLoad);
					LoadLv(indextoLoad);
				}
			}
		}
		
		function LoadLv(indextoLoad:int):void 
		{
			var path:String = _lvs[indextoLoad] + ".swf";
			trace("load path:" + path);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLvLoaded);
			loader.load(new URLRequest(path));
			_currentLvName = _lvs[indextoLoad];
		}
		
		function OnLvLoaded(e:Event):void 
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, OnLvLoaded);
			//var lvMC:BaseLv = loaderInfo.content as BaseLv;
			var lvMC:MovieClip = loaderInfo.content as MovieClip;
			ChangeScene(lvMC);
			lvMC.addEventListener(lvMC.LevelEnd, LevelEnd);
		}
		
		function LevelEnd(e:Event):void 
		{
			var lvMC:MovieClip = e.currentTarget as MovieClip;
			lvMC.removeEventListener("LevelEnd", LevelEnd);
			if (lvMC.Result == lvMC.Success)
			{
				_farEndSuccessLvName = _currentLvName;
				/*if (_farEndSuccessLvName == "lv1" || _farEndSuccessLvName == "lv2")
				{
					ShowLevelPass();
				}
				else
				{
				    LoadNextLv();
				}*/
				LoadNextLv();
			}
			else if (lvMC.Result == lvMC.Fail)
			{
				LoadResultPage();
			}
		}
		
		/*function ShowLevelPass():void 
		{
			var levelPass:MovieClip;
			if (_farEndSuccessLvName == "lv1")
			{
				levelPass = new MC_Pass1();
			}
			else if (_farEndSuccessLvName == "lv2")
			{
				levelPass = new MC_Pass2();
			}
			ChangeScene(levelPass);
			levelPass.addEventListener(MouseEvent.CLICK, OnLevelPassClick);
		}*/
		
		/*function OnLevelPassClick(e:Event):void 
		{
			var levelPass:MovieClip = e.currentTarget as MovieClip;
			levelPass.removeEventListener(MouseEvent.CLICK, OnLevelPassClick);
			this.removeChild(levelPass);
			LoadNextLv();
		}*/
		
		function LoadResultPage():void 
		{
			var path:String = "GameResult.swf";
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnResultLoaded);
			loader.load(new URLRequest(path));
		}
		
		function OnResultLoaded(e:Event):void 
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, OnResultLoaded);
			var result:MovieClip = loaderInfo.content as MovieClip;
			
			result.Result_type = ResultType();
			
			ChangeScene(result);
			result.addEventListener("ReturnHomePage", OnReturnHomePageFromResult);
		}
		
		function ResultType():int 
		{
			trace("Success at:" + _farEndSuccessLvName);
			if (_farEndSuccessLvName == "lv5")
			{
				return 1;
			}
			else if (_farEndSuccessLvName == "lv4")
			{
				return 2;
			}
			else
			{
				return 3;
			}
		}
		
		function OnReturnHomePageFromResult(e:Event):void 
		{
			var resultMC:MovieClip = e.currentTarget as MovieClip;
			resultMC.removeEventListener("ReturnHomePage", OnReturnHomePageFromResult);
			ResettoHome();
		}
		
		function OnHomeBtnClick(e:Event):void 
		{
			ResettoHome();
		}
		
		function ResettoHome():void 
		{
			ChangeScene(new MC_Start());
			_currentLvName = null;
			_farEndSuccessLvName = null;
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			//this["btn_Start"].addEventListener(MouseEvent.CLICK, OnStartClick);
		}
	}
	
}
