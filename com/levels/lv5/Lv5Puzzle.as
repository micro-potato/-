package com.levels.lv5 {
	
	import com.cp.CP_Lives;
	import com.cp.CP_RollingScroller;
	import com.levels.Lv4ResultValue;
	import com.mathematics.IonMath;
	import com.mc.BasePuzzle;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	
	public class Lv5Puzzle extends BasePuzzle {
		
		private var _answer:Array;
		private var _ionMath:IonMath;
		private var _myAnswer:Array;
		
		private var _operGate1:CP_RollingScroller;
		private var _operGate2:CP_RollingScroller;
		
		//operate values:
		const H:String = "H";
		const X:String = "X";
		const C:String = "C";
		const I:String = "I";
		
		var _allGateArray:Array;
		var _noHArray:Array;
		
		//lives&&steps
		var _fixedSteps:int = 3;
		var _playedSteps:int = 0;
		var _remainLives:int = 3;
		var _cp_lives:CP_Lives;
		var _cp_cover:MovieClip;
		
		public function Lv5Puzzle() {
			// constructor code
		}
		
		override protected function Init():void 
		{
			_hasHint = true;
			_hasPwd = false;
			
			_allGateArray = [I, H, X, C];
			_noHArray = [I, X, C];

			this["btn_start"].buttonMode = true;
			this["btn_start"].addEventListener(MouseEvent.CLICK, OnSubmit);
			this["btn_restart"].buttonMode = true;
			this["btn_restart"].addEventListener(MouseEvent.CLICK, OnResetClick);
			
			//init OperGates
			_operGate1 = new CP_RollingScroller();
			_operGate2 = new CP_RollingScroller();
			this.addChild(_operGate1);
			
			_operGate1.x = this["input1"].x;
			_operGate1.y = this["input1"].y;
			this.addChild(_operGate2);
			_operGate2.x=this["input2"].x;
			_operGate2.y = this["input2"].y;
			_operGate1.addEventListener(_operGate1.CIN, OnOper1CIN);
			_operGate1.addEventListener(_operGate1.COUT, OnOper1COUT);
			_operGate2.addEventListener(_operGate2.CIN, OnOper2CIN);
			_operGate2.addEventListener(_operGate2.COUT, OnOper2COUT);
			
			_operGate1.InitValues(_allGateArray);
			_operGate2.InitValues(_allGateArray);
			
			_ionMath = new IonMath();
			SetAnswer();
			
			_cp_lives = this["lives"];
			setTimeout(LossaLife, 0.5);
			
			_cp_cover = this["cp_cover"];
			_cp_cover.stop();
			
			//balls values from lv4
			var rbValues:SharedObject = SharedObject.getLocal("game","/");
			trace("get rbvalue:" + rbValues.data.Value1 + "-----" + rbValues.data.Value2);
			this["vb_1"].gotoAndStop(rbValues.data.Value1);
			this["vb_2"].gotoAndStop(rbValues.data.Value2);
			
			super.Init();
		}
		
		function SetAnswer():void 
		{
			//_answer = _ionMath.CalcSecurity((_ionMath.KroneckerMatrixOperate(_ionMath._hGate, _ionMath._iGate)),X,C);
			_answer = _ionMath.CalcSecurity(_ionMath._XCOperate,I,H);
			//trace("answer:" + _answer);
		}
		
		function OnSubmit(e:Event):void 
		{	
			_myAnswer = _ionMath.CalcSecurity(_myAnswer, _operGate1.ActiveValue, _operGate2.ActiveValue);
			//trace("_myAnswer:" + _myAnswer);
			
			SetPlayedSteps(_playedSteps+1);
			if (_playedSteps == _fixedSteps)
			{
				ShowCoverEffect();
				var result:Boolean = CheckAnswer();
				//trace("check:" + result);
				if (result == true)
				{
					setTimeout(LoadChallengeSuccess, 2000);
					//LoadChallengeSuccess();
				}
				else//wrong answer
				{
					LossaLife();
					Retry();
				}
			}
		}
		
		function ShowCoverEffect():void 
		{
			_cp_cover.play();
			//_randomBall1.visible=true;
			//_randomBall2.visible=true;
			setTimeout(function(){_cp_cover.gotoAndStop(1); }, 2000);
		}
		
		function Retry():void 
		{
			SetPlayedSteps(0);
			ResetValues();
		}
		
		function OnResetClick(e:Event):void 
		{
			ResetValues();
		}
		
		function ResetValues():void 
		{
			_myAnswer = null;
			_operGate1.ReSetValues(_allGateArray);
			_operGate2.ReSetValues(_allGateArray);
			//_randomBall1.visible=false;
			//_randomBall2.visible=false;
		}
		
		function CheckAnswer():Boolean 
		{
			if (_myAnswer==null||_myAnswer.length != 4 || _answer.length != 4)
			{
				trace("矩阵格式不正确");
				return false;
			}
			
			var result:Boolean = true;
			for (var i:int = 0; i < 4; i++) 
			{
				for (var j:int = 0; j < 4; j++) 
				{
					if (_myAnswer[i][j] != _answer[i][j])
					{
						result = false;
						break;
					}
				}
			}
			return result;
		}
		
		function SetPlayedSteps(step:int):void 
		{
			_playedSteps = step;
			this["t_times"].text = _playedSteps;
		}
		
		function LossaLife():void 
		{
			_cp_lives.LoseLife();
			_remainLives = _cp_lives.LivesRamain;
			if (_remainLives == 0)
			{
				setTimeout(PuzzleFail, 0.5);
			}
		}
		
		function PuzzleFail():void 
		{
			this._result = this.Fail;
			TriggerResult();
		}
		
		function LoadChallengeSuccess():void 
		{
			var successMC:MovieClip = new mc_Sucess();
			successMC.addEventListener(MouseEvent.CLICK, OnSuccessClick);
			this.addChild(successMC);
		}
		
		function OnSuccessClick(e:Event):void 
		{
			var successMC:MovieClip = e.currentTarget as MovieClip;
			successMC.removeEventListener(MouseEvent.CLICK, OnSuccessClick);
			_result = this.Success;
			TriggerResult();
		}
		
		
		/*-----------------------------------cp event--------------------------------*/
		function OnOper1CIN(e:Event):void 
		{
			//trace("c1 in");
			var savedOper2:String = _operGate2.ActiveValue;
			_operGate2.ReSetValues(_noHArray);
			_operGate2.ScrolltoValue(savedOper2);
		}
		
		function OnOper1COUT(e:Event):void 
		{
			var savedOper2:String = _operGate2.ActiveValue;
			_operGate2.ReSetValues(_allGateArray);
			_operGate2.ScrolltoValue(savedOper2);
		}
		
		function OnOper2CIN(e:Event):void 
		{
			//trace("c2 in");
			var savedOper1:String = _operGate1.ActiveValue;
			_operGate1.ReSetValues(_noHArray);
			_operGate1.ScrolltoValue(savedOper1);
		}
		
		function OnOper2COUT(e:Event):void 
		{
			//trace("c2 out");
			var savedOper1:String = _operGate1.ActiveValue;
			_operGate1.ReSetValues(_allGateArray);
			_operGate1.ScrolltoValue(savedOper1);
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			this["btn_start"].removeEventListener(MouseEvent.CLICK, OnSubmit);
			this["btn_restart"].removeEventListener(MouseEvent.CLICK, OnResetClick);
		}
	}
	
}
