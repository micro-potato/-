﻿package com.mc {
	
	import com.BaseMovie;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class PuzzleHint extends BaseMovie {
		
		private var _prevBtn:MovieClip;
		private var _nextBtn:MovieClip;
		public function PuzzleHint() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			super.Init();
			this.gotoAndStop(1);
			_prevBtn = this["btn_prev"];
			_nextBtn = this["btn_next"];
			_prevBtn.addEventListener(MouseEvent.CLICK, OnPrevClick);
			_nextBtn.addEventListener(MouseEvent.CLICK, OnNextClick);
			this._prevBtn.visible = false;
		}
		
		function OnPrevClick(e:Event):void 
		{
			e.stopPropagation();
			if (this.currentFrame == 2)
			{
				this.prevFrame();
				this._prevBtn.visible = false;
				this._nextBtn.visible = true;
			}
		}
		
		function OnNextClick(e:Event):void 
		{
			e.stopPropagation();
			if (this.currentFrame == 1)
			{
				this.nextFrame();
				this._prevBtn.visible = true;
				this._nextBtn.visible = false;
			}
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			_prevBtn.removeEventListener(MouseEvent.CLICK, OnPrevClick);
			_nextBtn.removeEventListener(MouseEvent.CLICK, OnNextClick);
		}
	}
	
}
