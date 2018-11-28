package com.levels.lv1 {
	
	import com.mc.BasePuzzle;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class Lv1Puzzle extends BasePuzzle {
		
		private const Pvalue:String = "Positive";
		private const Nvalue:String = "Negative";
		
		private var _coin1Value:String;
		private var _coin2Value:String;
		public function Lv1Puzzle() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			super.Init();
			
			_coin1Value = Nvalue;
			this["b_p"].buttonMode = true;
			this["b_n"].buttonMode = true;
			this["b_p"].addEventListener(MouseEvent.CLICK, OnPclick);
			this["b_n"].addEventListener(MouseEvent.CLICK, OnNclick);

			StartPuzzle();
		}
		
		function StartPuzzle():void 
		{
			var swapCoinAni:MovieClip = new MC_SwapCoinAni();
			this.addChild(swapCoinAni);
			swapCoinAni.addEventListener(Event.ENTER_FRAME, OnSwapCoinAniPlay);
		}
		
		function OnSwapCoinAniPlay(e:Event):void 
		{
			var swapCoinAni:MovieClip = e.currentTarget as MovieClip;
			if (swapCoinAni.currentFrame == swapCoinAni.totalFrames)
			{
				swapCoinAni.removeEventListener(Event.ENTER_FRAME, OnSwapCoinAniPlay);
				this.removeChild(swapCoinAni);
				SetCoinResult();
			}
		}
		
		function SetCoinResult():void 
		{
			var randomValue:int = Math.round(Math.random());
			if (randomValue == 1)
			{
				_coin1Value = Pvalue;
				this["cp_coin"].gotoAndStop("p_p");
			}
			else
			{
				_coin1Value = Nvalue;
				this["cp_coin"].gotoAndStop("p_n");
				//this["cp_coin"].play();
			}
		}
		
		function OnPclick(e:Event):void 
		{
			_coin2Value = Pvalue;
			CheckResult();
		}
		
		function OnNclick(e:Event):void 
		{
			_coin2Value = Nvalue;
			CheckResult();
		}
		
		function CheckResult():void 
		{
			//trace(_coin1Value+"----" + _coin2Value);
			if (_coin1Value != _coin2Value)
			{
				_result = this.Success;
				ShowInfoPage();
				//ShowSuccessMC();
			}
			else
			{
				var mc_retry:MovieClip = new MC_Retry();
				this.addChild(mc_retry);
				mc_retry["btn_retry"].addEventListener(MouseEvent.CLICK, OnRetry);
			}
		}
		
		function ShowInfoPage():void 
		{
			var introPage:MovieClip = new MC_Intro();
			introPage.addEventListener(MouseEvent.CLICK, OnIntroClick);
			this.addChild(introPage);
		}
		
		function OnIntroClick(e:Event):void 
		{
			var introPage:MovieClip = e.currentTarget as MovieClip;
			introPage.removeEventListener(MouseEvent.CLICK, OnIntroClick);
			this.removeChild(introPage);
			ShowSuccessMC();
		}
		
		function ShowSuccessMC():void 
		{
			var successMC:MovieClip = new MC_Pass1();
			successMC.addEventListener(MouseEvent.CLICK, OnSuccessClick);
			this.addChild(successMC);
		}
		
		function OnSuccessClick(e:Event):void 
		{
			var successMC:MovieClip = e.currentTarget as MovieClip;
			successMC.removeEventListener(MouseEvent.CLICK, OnSuccessClick);
			//_result = this.Success;
			TriggerResult();
		}
		
		function OnRetry(e:Event):void 
		{
			var btn_retry:MovieClip = e.currentTarget as MovieClip;
			btn_retry.removeEventListener(MouseEvent.CLICK, OnRetry);
			Reroll();
			this.removeChild(btn_retry.parent);
		}
		
		function Reroll():void 
		{
			StartPuzzle();
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			this["b_p"].removeEventListener(MouseEvent.CLICK, OnPclick);
			this["b_n"].removeEventListener(MouseEvent.CLICK, OnNclick);
		}
	}
	
}
