package com.cp {
	
	import com.BaseMovie;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class CP_Lives extends BaseMovie {
		
		private var _livesRamain:int = 3;
		public function CP_Lives() {
			// constructor code
		}
		
		public function get LivesRamain():int 
		{
			return _livesRamain;
		}
		
		override protected function Init():void 
		{
			super.Init();
			for (var i:int = 1; i <=3 ; i++) 
			{
				this["h_"+i].stop();
			}
			
		}
		
		public function LoseLife():void 
		{
			if (_livesRamain > 0)
			{
				LoseLifeAnimate();
				_livesRamain--;
			}
		}
		
		function LoseLifeAnimate():void 
		{
			var loseLifeIndex:int = 4 - _livesRamain;
			this["h_" + loseLifeIndex.toString()].play();
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
		}
	}
	
}
