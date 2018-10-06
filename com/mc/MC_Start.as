package com.mc {
	
	import com.BaseMovie;
	import com.Main;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class MC_Start extends BaseMovie {
		
		
		public function MC_Start() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			super.Init();
			this["btn_Start"].addEventListener(MouseEvent.CLICK, OnStartClick);
		}
		
		function OnStartClick(e:MouseEvent):void 
		{
			Main.Instance.OnStart();
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			this["btn_Start"].removeEventListener(MouseEvent.CLICK, OnStartClick);
		}
	}
	
}
