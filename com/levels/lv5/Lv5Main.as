﻿package com.levels.lv5 {
	
	import com.BaseMovie;
	import com.mc.BasePuzzle;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class Lv5Main extends BaseMovie {
		
		public const LevelEnd:String = "LevelEnd";
		public const Success:String = "Success";
		public const Fail:String = "Fail";
		private var _result:String;
		
		private var _puzzleMC:BasePuzzle;
		private var _puzzleHintMC:MovieClip;
		
		private var _currentLan:String;
		
		public function Lv5Main() {
			// constructor code
		}
		
		public function set Lan(value:String):void 
		{
			_currentLan = value;
		}
		
		public function get Result():String
		{
			return _result;
		}
		
		override protected function Init():void 
		{
			super.Init();
			_puzzleHintMC = new MC_PuzzleHint();
			var choiceMC:MC_Choice = new MC_Choice();
			this.addChild(choiceMC);
			choiceMC.addEventListener(MC_Choice.ChoiceMade, OnChoiceMade);
		}
		
		function OnChoiceMade(e:Event):void 
		{
			var choiceMC:MC_Choice = e.currentTarget as MC_Choice;
			if (choiceMC.IsChallenge)
			{
				//_puzzleMC = new Lv5Puzzle();
				//this.addChild(_puzzleMC);
				//_puzzleMC.addEventListener(_puzzleMC.PuzzleEnd, OnPuzzleEnd);
				LoadIntro();
			}
			else
			{
				this._result = Fail;
				this.dispatchEvent(new Event(this.LevelEnd));
			}
		}
		
		function LoadIntro():void 
		{
			this.addChild(_puzzleHintMC);
			_puzzleHintMC.addEventListener(MouseEvent.CLICK, OnHintClick);
		}
		
		function OnHintClick(e:Event):void 
		{
			_puzzleHintMC.removeEventListener(MouseEvent.CLICK, OnHintClick);
			this.removeChild(_puzzleHintMC);
			LoadPuzzle();
		}
		
		function LoadPuzzle():void 
		{
			_puzzleMC = new Lv5Puzzle();
			this.addChild(_puzzleMC);
			_puzzleMC.addEventListener(_puzzleMC.PuzzleEnd, OnPuzzleEnd);
		}
		
		function OnPuzzleEnd(e:Event):void 
		{
			OnPuzzleEndDeal();
		}
		
		protected function OnPuzzleEndDeal()
		{
			_puzzleMC.removeEventListener(_puzzleMC.PuzzleEnd, OnPuzzleEnd);
			this._result = _puzzleMC.Result;
			this.dispatchEvent(new Event(this.LevelEnd));
			trace("get puzzle result:" + _result);
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			//_puzzleMC.removeEventListener(_puzzleMC.PuzzleEnd, OnPuzzleEnd);
			super.removed_from_stage(e);
		}
	}
	
}
