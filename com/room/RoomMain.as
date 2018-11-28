package com.room {
	
	import com.BaseMovie;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class RoomMain extends BaseMovie {
		
		public static var Instance:RoomMain;
		private var _mc_room:MC_Room;
		public function RoomMain() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			super.Init();
			Instance = this;
			_mc_room = new MC_Room();
			this.addChild(_mc_room);
		}
		
		public function DisableHit():void 
		{
			_mc_room.DisableHit();
		}
		
		public function ShowDrTip():void 
		{
			_mc_room.ShowDrTip();
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
		}
	}
	
}
