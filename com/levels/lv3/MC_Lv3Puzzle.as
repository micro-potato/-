package com.levels.lv3 {
	
	import com.BaseMovie;
	import com.cp.CP_Iontrap;
	import com.mc.BasePuzzle;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class MC_Lv3Puzzle extends BasePuzzle {
		
		var _ionTrap:CP_Iontrap;
		var _pwd:Array;
		var _initValues:Array;
		
		var _maxStep:int = 6;
		var _playedSteps:int = 0;
		
		public function MC_Lv2Puzzle() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			_hasHint = true;
			_hasPwd = true;
			_mc_pwd = new MC_Pwd();
			
			this["btn_start"].addEventListener(MouseEvent.CLICK, OnStart);
			this["btn_restart"].addEventListener(MouseEvent.CLICK, OnReset);
			
			_ionTrap = this["iontrap"];
			_ionTrap.SwitchOn = true;
			
			//Lv3
			//init pwd
			var pwd1:Array = [0,0,0,1];
			var pwd2:Array = [0,0,0,1];
			var pwd3:Array = [0,1,0,0];
			var pwd4:Array = [1,0,0,1];
			_pwd = [pwd1, pwd2, pwd3, pwd4];
			_ionTrap.Password = _pwd;
			
			//init init result
			var ir1:Array = [0,0,1,0];
			var ir2:Array = [0,1,0,0];
			var ir3:Array = [0,0,1,0];
			var ir4:Array = [1,0,0,0];
			_initValues = [ir1, ir2, ir3, ir4];
			_ionTrap.InitValues = _initValues;
			super.Init();
		}
		
		function OnStart(e:Event):void 
		{
			//test
			//_result = this.Success;
			//TriggerResult();
			//return;
			
			//var isSuccess:Boolean = _ionTrap.CheckAnswer();
			////trace("isSuccess:" + isSuccess);
			//if (!isSuccess)
			//{
				//_ionTrap.ClearInput();
			//}
			//else
			//{
				//_result = this.Success;
				//TriggerResult();
			//}
			
			SetPlayedSteps(_playedSteps + 1);
			var isSuccess:Boolean = _ionTrap.CheckAnswer();
			//trace("isSuccess:" + isSuccess);
			if (!isSuccess)
			{
				_ionTrap.ClearInput();
				if (_playedSteps == _maxStep)//times used up
				{
					var mc_retry:MovieClip = new MC_Retry();
					this.addChild(mc_retry);
					mc_retry["btn_retry"].addEventListener(MouseEvent.CLICK, OnRetry);
				}
			}
			else
			{
				_result = this.Success;
				TriggerResult();
			}
		}
		
		function OnReset(e:Event):void 
		{
			//trace("iontrap reset");
			_ionTrap.Reset();
		}
		
		function SetPlayedSteps(step:int):void 
		{
			_playedSteps = step;
			this["t_times"].text = _playedSteps;
		}
		
		function OnRetry(e:Event):void 
		{
			var btn_retry:MovieClip = e.currentTarget as MovieClip;
			btn_retry.removeEventListener(MouseEvent.CLICK, OnRetry);
			SetPlayedSteps(0);
			_ionTrap.Reset();
			this.removeChild(btn_retry.parent);
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			this["btn_start"].removeEventListener(MouseEvent.CLICK, OnStart);
			this["btn_restart"].removeEventListener(MouseEvent.CLICK, OnReset);
		}
	}
	
}
