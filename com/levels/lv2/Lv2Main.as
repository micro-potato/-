package com.levels.lv2 {
	
	import com.mc.BaseLv;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Lv2Main extends BaseLv {
		
		
		public function Lv2Main() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			_isInRoom = true;
			_isHintatStart = true;
			_itemstoFind = ["Keyboard", "Magnifier"];
			_hint = new MC_Hint();
			_puzzle = new MC_Lv2Puzzle();
			_foundMC = new MC_Found();
			
			
			super.Init();
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
		}
	}
	
}
