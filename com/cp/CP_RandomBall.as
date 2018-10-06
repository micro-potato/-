package com.cp {
	
	import com.BaseMovie;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class CP_RandomBall extends BaseMovie {
		
		
		public function CP_RandomBall() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			super.Init();
			this.stop();
			SetValue();
		}
		
		function SetValue():void 
		{
			this.gotoAndStop((Math.round(Math.random()))*2);
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
		}
	}
	
}
