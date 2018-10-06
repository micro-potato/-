package com.room {
	
	import com.BaseMovie;
	import com.EventMaster;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class MC_Room extends BaseMovie {
		
		private var _prevBtn:MovieClip;
		private var _nextBtn:MovieClip;
		private var _hintBtn:MovieClip;
		private var _homeBtn:MovieClip;
		
		//cat
		//var _catAvailableArray:Array;
		var _activeCatIndex:int = 0;
		
		public function MC_Room() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			super.Init();
			this.gotoAndStop(1);
			_prevBtn = this["btn_prev"];
			_nextBtn = this["btn_next"];
			_hintBtn = this["btn_hint"];
			_homeBtn = this["btn_Home"];
			_prevBtn.addEventListener(MouseEvent.CLICK, OnPrevClick);
			_nextBtn.addEventListener(MouseEvent.CLICK, OnNextClick);
			_hintBtn.addEventListener(MouseEvent.CLICK, OnHintClick);
			_homeBtn.addEventListener(MouseEvent.CLICK, OnHomeClick);
			this._prevBtn.visible = false;
			
			//_catAvailableArray = new Array();
			for (var i:int = 0; i <6 ; i++) 
			{
				var catName:String = CatNamebyIndex(i);
				this[catName].visible = false;
			}
			SetActiveCat();
			UpdateCatVisible();
		}
		
		function CatNamebyIndex(index:int):String 
		{
			return "b" + index.toString() + "_Cat";
		}
		
		function SetActiveCat():void 
		{
			_activeCatIndex = Math.round(Math.random() * 5);
			trace(_activeCatIndex);
		}
		
		function UpdateCatVisible():void 
		{
			if (_activeCatIndex <= 2)//cat at page1
			{
				if (this.currentFrame == 1)
				{
					this[CatNamebyIndex(_activeCatIndex)].visible = true;
				}
				else
				{
					this[CatNamebyIndex(_activeCatIndex)].visible = false;
				}
			}
			else//cat at page2
			{
				if (this.currentFrame == 1)
				{
					this[CatNamebyIndex(_activeCatIndex)].visible = false;
				}
				else
				{
					this[CatNamebyIndex(_activeCatIndex)].visible = true;
				}
			}
		}
		
		function OnPrevClick(e:Event):void 
		{
			if (this.currentFrame == 2)
			{
				this.prevFrame();
				this._prevBtn.visible = false;
				this._nextBtn.visible = true;
				UpdateCatVisible();
			}
		}
		
		function OnNextClick(e:Event):void 
		{
			if (this.currentFrame == 1)
			{
				this.nextFrame();
				this._prevBtn.visible = true;
				this._nextBtn.visible = false;
				UpdateCatVisible();
			}
		}
		
		function OnHintClick(e:Event):void 
		{
			RoomMain.Instance.dispatchEvent(new Event("HintCalled"));
		}
		
		public function DisableHit():void 
		{
			this["btn_hint"].visible = false;
		}
		
		function OnHomeClick(e:Event):void 
		{
			EventMaster.getInstance().dispatchEvent(new Event(EventMaster.OnHomeClick));
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			_prevBtn.removeEventListener(MouseEvent.CLICK, OnPrevClick);
			_nextBtn.removeEventListener(MouseEvent.CLICK, OnNextClick);
			_hintBtn.removeEventListener(MouseEvent.CLICK, OnHintClick);
			_homeBtn.removeEventListener(MouseEvent.CLICK, OnHomeClick);
		}
	}
	
}
