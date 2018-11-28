package com.levels.lv3 {
	
	import com.mc.BaseLv;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class Lv3Main extends BaseLv {
		
		
		public function Lv3Main() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			_isInRoom = true;
			_isHintatStart = true;
			_itemstoFind = ["Flowerpot", "Screen"];
			_hint = new MC_Hint();
			_puzzle = new MC_Lv3Puzzle();
			_foundMC = new MC_Found();
			_mc_intro=new MC_PuzzleHint();
			super.Init();
		}
		
		override protected function OnPuzzleEndDeal() 
		{
			this._result = _puzzle.Result;
			var mcEnd:MovieClip = new MC_End();
			this.addChild(mcEnd);
			mcEnd.gotoAndStop(1);
			mcEnd.addEventListener(MouseEvent.CLICK, OnEndClick);
			trace("get puzzle result:" + _result);
		}
		
		function OnEndClick(e:Event):void 
		{
			var mcEnd:MovieClip = e.currentTarget as MovieClip;
			if (mcEnd.currentFrame != mcEnd.totalFrames)
			{
				mcEnd.nextFrame();
			}
			else
			{
				mcEnd.removeEventListener(MouseEvent.CLICK, OnEndClick);
				this.dispatchEvent(new Event(this.LevelEnd));
			}
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
		}
	}
	
}
