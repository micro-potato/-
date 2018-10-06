package com.room {
	
	import com.BaseMovie;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class CP_itemBtn extends BaseMovie {
		
		
		public function CP_itemBtn() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			super.Init();
			this.buttonMode=true;
			this.addEventListener(MouseEvent.CLICK, OnItemClick);
		}
		
		function OnItemClick(e:Event):void 
		{
			var itemName:String = this.name.split('_')[1];
			var event:ItemClickEvent = new ItemClickEvent();
			event.itemName = itemName;
			//trace(itemName+" found");
			RoomMain.Instance.dispatchEvent(event);
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			this.addEventListener(MouseEvent.CLICK, OnItemClick);
		}
	}
	
}
