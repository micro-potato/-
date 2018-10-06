package com.levels.lv4 {
	
	import com.BaseMovie;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class MC_Openning extends BaseMovie {
		
		private var _isSave:Boolean = true;
		public static const ChoiceMade:String = "ChoiceMade";
		
		public function MC_Openning() {
			// constructor code
		}
		
		public function get IsSave():Boolean
		{
			return _isSave;
		}
		
		override protected function Init():void 
		{
			super.Init();
			this["b_save"].addEventListener(MouseEvent.CLICK, OnSaveClick);
			this["b_notSave"].addEventListener(MouseEvent.CLICK, OnNotSaveClick);
			this.addEventListener(MouseEvent.CLICK, OnDialogClick);
			this.gotoAndStop(2);
		}
		
		function OnDialogClick(e:Event):void 
		{
			if (this.currentFrame != this.totalFrames)
			{
				this.nextFrame();
			}
		}
		
		function OnSaveClick(e:Event):void 
		{
			if (this.currentFrame != this.totalFrames)
			{
				return;
			}
			e.stopPropagation();
			_isSave = true;
			this.dispatchEvent(new Event(ChoiceMade));
		}
		
		function OnNotSaveClick(e:Event):void 
		{
			if (this.currentFrame != this.totalFrames)
			{
				return;
			}
			e.stopPropagation();
			_isSave = false;
			this.dispatchEvent(new Event(ChoiceMade));
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			this["b_save"].removeEventListener(MouseEvent.CLICK, OnSaveClick);
			this["b_notSave"].removeEventListener(MouseEvent.CLICK, OnNotSaveClick);
			this.removeEventListener(MouseEvent.CLICK, OnDialogClick);
		}
	}
	
}
