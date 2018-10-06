package com.mc {
	
	import com.BaseMovie;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	public class MC_Result extends BaseMovie {
		
		var _result_type:int;
		public function MC_Result() {
			// constructor code
		}
		
		public function set Result_type(value:int):void 
		{
			_result_type = value;
		}
		
		override protected function Init():void 
		{
			super.Init();
			setTimeout(ResultInit, 0.5);
		}
		
		function ResultInit():void 
		{
			this.gotoAndStop(_result_type);
			this["btn_Home"].addEventListener(MouseEvent.CLICK, OnHomeClick);
		}
		
		function OnHomeClick(e:Event):void 
		{
			this.dispatchEvent(new Event("ReturnHomePage"));
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			this["btn_Home"].removeEventListener(MouseEvent.CLICK, OnHomeClick);
		}
	}
	
}
