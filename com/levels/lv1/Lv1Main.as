package com.levels.lv1 {
	
	import com.BaseMovie;
	import com.mc.BaseLv;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.LoaderInfo;
	
	
	public class Lv1Main extends BaseLv {
		
		
		public function Lv1Main() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			_isInRoom = true;
			_isShowDrHint = true;
			_isHintatStart = false;
			_isCallHintAble = true;
			_isShowIntroBeforePuzzle = false;
			_itemstoFind = ["Cat"];
			_hint = new MC_Hint();
			_puzzle = new Lv1Puzzle();
			_foundMC = new MC_Found();
			_mc_intro = new MC_Intro();
			super.Init();
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
		}
	}
	
}
