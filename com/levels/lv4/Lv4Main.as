package com.levels.lv4 {
	
	import com.BaseMovie;
	import com.mathematics.IonMath;
	import com.mc.BaseLv;
	import com.mc.BasePuzzle;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class Lv4Main extends BaseMovie {
		
		//var mathHelper:IonMath;
		public const LevelEnd:String = "LevelEnd";
		public const Success:String = "Success";
		public const Fail:String = "Fail";
		private var _result:String;
		
		private var _puzzleMC:MovieClip;
		
		public function Lv4Main() {
			// constructor code
		}
		
		public function get Result():String
		{
			return _result;
		}
		
		override protected function Init():void 
		{
			super.Init();
			var mc_openning:MC_Openning = new MC_Openning();
			this.addChild(mc_openning);
			mc_openning.addEventListener(MC_Openning.ChoiceMade, OnChoiceMade);
		}
		
		function OnChoiceMade(e:Event):void 
		{
			var mc_openning:MC_Openning = e.currentTarget as MC_Openning;
			if (mc_openning.IsSave)
			{
				_puzzleMC = new Lv4Puzzle();
				this.addChild(_puzzleMC);
				_puzzleMC.addEventListener(_puzzleMC.PuzzleEnd, OnPuzzleEnd);
			}
			else
			{
				var notSaveMC:MovieClip = new MC_NotSave();
				this.addChild(notSaveMC);
				notSaveMC.addEventListener(MouseEvent.CLICK, OnNotSaveClick);
			}
		}
		
		function OnNotSaveClick(e:Event):void 
		{
			var notSaveMC:MovieClip = e.currentTarget as MovieClip;
			notSaveMC.removeEventListener(MouseEvent.CLICK, OnNotSaveClick);
			_result = this.Fail;
			this.dispatchEvent(new Event(this.LevelEnd));
		}
		
		function OnPuzzleEnd(e:Event):void 
		{
			OnPuzzleEndDeal();
		}
		
		protected function OnPuzzleEndDeal()
		{
			_puzzleMC.removeEventListener(_puzzleMC.PuzzleEnd, OnPuzzleEnd);
			this._result = _puzzleMC.Result;
			trace("get puzzle result:" + _result);
			this.dispatchEvent(new Event(this.LevelEnd));
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			//_puzzleMC.removeEventListener(_puzzleMC.PuzzleEnd, OnPuzzleEnd);
			super.removed_from_stage(e);
		}
	}
	
}
