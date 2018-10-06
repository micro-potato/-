package com.levels.lv5 {
	
	import com.BaseMovie;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class MC_Choice extends BaseMovie {
		
		public static const ChoiceMade:String = "ChoiceMade";
		var _isChallenge:Boolean = true;
		
		public function MC_Choice() {
			// constructor code
		}
		
		public function get IsChallenge():Boolean
		{
			return _isChallenge;
		}
		
		override protected function Init():void 
		{
			super.Init();
			this["btn_play"].addEventListener(MouseEvent.CLICK, OnPlay);
			this["btn_notplay"].addEventListener(MouseEvent.CLICK, OnNotPlay);
		}
		
		function OnPlay(e:Event):void 
		{
			_isChallenge = true;
			this.dispatchEvent(new Event(ChoiceMade));
		}
		
		function OnNotPlay(e:Event):void 
		{
			_isChallenge = false;
			this.dispatchEvent(new Event(ChoiceMade));
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			this["btn_play"].addEventListener(MouseEvent.CLICK, OnPlay);
			this["btn_notplay"].addEventListener(MouseEvent.CLICK, OnNotPlay);
			super.removed_from_stage(e);
		}
	}
	
}
