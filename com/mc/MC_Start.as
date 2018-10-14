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
		
		private var _currentLan:String = "cn";
		override protected function Init():void 
		{
			super.Init();
			this["btn_Start"].addEventListener(MouseEvent.CLICK, OnStartClick);
			//this["btn_cn"].addEventListener(MouseEvent.CLICK, OnCNCLick);
			//this["btn_en"].addEventListener(MouseEvent.CLICK, OnENCLick);
			
			this["btn_Lan"].addEventListener(MouseEvent.CLICK, OnLanCLick);
			SetLanPage("cn");
		}
		
		//function OnCNCLick(e:Event):void 
		//{
			//SetLanPage("cn");
		//}
		//
		//function OnENCLick(e:Event):void 
		//{
			//SetLanPage("en");
		//}
		
		function OnLanCLick(e:Event):void 
		{
			if (this._currentLan == "cn")
			{
				SetLanPage("en");
			}
			else
			{
				SetLanPage("cn");
			}
		}
		
		public function SetLanPage(targetLan:String):void 
		{
			if (targetLan == "cn")
			{
				this.gotoAndStop(1);
			}
			else
			{
				this.gotoAndStop(2);
			}
			//set to main
			_currentLan = targetLan;
			Main.Instance.Lan = targetLan;
		}
		
		function OnStartClick(e:MouseEvent):void 
		{
			Main.Instance.OnStart();
		}
		
		
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			this["btn_Start"].removeEventListener(MouseEvent.CLICK, OnStartClick);
			this["btn_Lan"].removeEventListener(MouseEvent.CLICK, OnLanCLick);
			//this["btn_cn"].removeEventListener(MouseEvent.CLICK, OnCNCLick);
			//this["btn_en"].removeEventListener(MouseEvent.CLICK, OnENCLick);
		}
	}
	
}
