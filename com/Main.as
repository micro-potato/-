package com {
	
	import com.mc.BaseLv;
	import com.mc.MC_Start;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.geom.Rectangle;
	import flash.system.fscommand;
	
	
	public class Main extends BaseMovie {
		
		private var _lvs:Array;
		private var _currentLvName:String;
		private var _record:Object;//result,["lv1",1]
		private var _farEndSuccessLvName:String;
		private var _currentLan:String = "cn";
		
		public static var Instance:Main;
		public function Main() {
			// constructor code
		}
		
		override protected function Init():void 
		{

			stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.addEventListener(MouseEvent.CLICK, OnExitClick);
			
			super.Init();
			Instance = this;
			_lvs = ["Lv1", "Lv2", "Lv3", "Lv4", "Lv5"];
			EventMaster.getInstance().addEventListener(EventMaster.OnHomeClick, OnHomeBtnClick);
			var _startMC:MovieClip = new MC_Start();
			ChangeScene(_startMC);
			
			//test
			//LoadLv(2);
		}
		
		function OnExitClick(e:MouseEvent):void 
		{
			e.stopPropagation();
			trace("try exit");
			var exitRec:Rectangle = new Rectangle(0, 1080 - 120, 120, 120);
			//trace("exitRec=" + exitRec);
			if (exitRec.contains(e.stageX, e.stageY))
			{
				//trace("stage L" + e.stageX+","+e.stageY);
				trace("exit zone");
				fscommand("quit");
			}
		}
		
		public function set Lan(value:String):void 
		{
			_currentLan = value;
			trace(_currentLan);
		}
		
		public function ChangeScene(mc:MovieClip)
		{
			this.removeChildren();
			this.addChild(mc);
			trace("add:"+mc);
		}
		
		public function OnStart()
		{
			LoadOpenning();
		}
		
		function LoadOpenning():void 
		{
			var path:String = _currentLan + "\\Opening.swf";
			trace(path);
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
			//trace("check openning");
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
			var path:String =_currentLan+"\\"+_lvs[indextoLoad] + ".swf";
			//trace("load LV path:" + path);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLvLoaded);
			loader.load(new URLRequest(path));
			_currentLvName = _lvs[indextoLoad];
		}
		
		function OnLvLoaded(e:Event):void 
		{
			//trace("lv loaded");
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, OnLvLoaded);
			var lvMC:MovieClip = loaderInfo.content as MovieClip;
			lvMC.Lan = _currentLan;
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
				LoadNextLv();
			}
			else if (lvMC.Result == lvMC.Fail)
			{
				LoadResultPage();
			}
		}
		
		function LoadResultPage():void 
		{
			var path:String = _currentLan+"\\"+"GameResult.swf";
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
			var startPage:MC_Start = new MC_Start();
			ChangeScene(startPage);
			startPage.SetLanPage(_currentLan);
			_currentLvName = null;
			_farEndSuccessLvName = null;
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			stage.removeEventListener(MouseEvent.CLICK, OnExitClick);
		}
	}
	
}
