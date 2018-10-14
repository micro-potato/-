package com.cp 
{
	import com.BaseMovie;
	import com.mathematics.IonMath;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class CP_OperGroup extends BaseMovie
	{
		//operate values:
		const H:String = "H";
		const X:String = "X";
		const C:String = "C";
		const I:String = "I";
		
		var _allGateArray:Array;
		var _initOperArray:Array;
		var _noHArray:Array;
		var _initValue:Array;
		var _noCArray:Array;

		var _switchGateValue:String = "OFF";
		
		//cp
		var _operGate1:CP_RollingScroller;
		var _operGate2:CP_RollingScroller;
		var _switchGate:CP_SwitchGate;
		var _key:CP_Key;
		
		var _isSwitchOn:Boolean = false;
		
		//calc
		var calculator:IonMath = new IonMath();
		var _savedResult:Array;
		
		//properties
		public function set IsSwitchOn(value:Boolean):void
		{
			//trace("group set");
			_isSwitchOn = value;
		}
		
		function get Oper1():String 
		{
			var value:String = _operGate1.ActiveValue;
			//if (value == "")
			//{
				//value = I;
			//}
			return value;
		}
		
		function get Oper2():String 
		{
			var value:String = _operGate2.ActiveValue;
			//if (value == "")
			//{
				//value = I;
			//}
			return value;
		}
		
		//function get SwitchGate():String 
		//{
			//return null;
		//}
		
		public function set InitValue(value:Array):void
		{
			_initValue = value;
		}
		
		public function CP_OperGroup() 
		{
			
		}
		
		override protected function Init():void 
		{
			super.Init();

			_allGateArray = [I, H, X, C];
			_initOperArray = [I, H, X];
			_noHArray = [I, X, C];
			_noCArray = [I, H, X];
			
			//init OperGates
			_operGate1 = new CP_RollingScroller();
			_operGate2 = new CP_RollingScroller();
			this.addChild(_operGate1);
			
			_operGate1.x = this["loc1"].x;
			_operGate1.y = this["loc1"].y;
			this.addChild(_operGate2);
			
			_operGate2.x=this["loc2"].x;
			_operGate2.y = this["loc2"].y;
			
			_operGate1.addEventListener(_operGate1.CIN, OnOper1CIN);
			_operGate1.addEventListener(_operGate1.COUT, OnOper1COUT);
			_operGate2.addEventListener(_operGate2.CIN, OnOper2CIN);
			_operGate2.addEventListener(_operGate2.COUT, OnOper2COUT);
			
			_switchGate = this["switchGate"];
			_key = this["key"];
			_key._initValue = _initValue;
			_savedResult = new Array();
			for (var i:int = 0; i < 4; i++) 
			{
				_savedResult[i] = _initValue[i];
			}
			_switchGate.addEventListener(_switchGate.ValueChanged, OnSwitchValueChanged);
			_switchGate.IsActive = _isSwitchOn;
			
			if (_isSwitchOn)
			{
				_initOperArray = _allGateArray;
			}
			_operGate1.InitValues(_initOperArray);
			_operGate2.InitValues(_initOperArray);
			
		}
		
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
		
		function OnSwitchValueChanged(e:Event):void 
		{
			_switchGateValue = _switchGate.ActiveValue;
			var savedOper1:String = _operGate1.ActiveValue;
			var savedOper2:String = _operGate2.ActiveValue;
			if (_switchGateValue == "On")
			{
				_operGate1.ReSetValues(_allGateArray);
				_operGate2.ReSetValues(_allGateArray);
				_operGate1.ScrolltoValue(savedOper1);
				_operGate2.ScrolltoValue(savedOper2);
			}
			else//OFF
			{
				//_operGate1.ReSetValues(_initOperArray);
				//_operGate2.ReSetValues(_initOperArray);
				_operGate1.ReSetValues(_noCArray);
				_operGate2.ReSetValues(_noCArray);
				_operGate1.ScrolltoValue(savedOper1);
				_operGate2.ScrolltoValue(savedOper2);
			}
		}
		
		function Calc():Array
		{
			trace("to calc:" + Oper1 + "===" + Oper2);
			var result:Array = calculator.CalcaGroup(_savedResult, Oper1, Oper2);
			UpdateKey(result);
			_savedResult = result;
			//ClearInput();
			return result;
		}
		
		function ClearInput():void 
		{
			_operGate1.ScrolltoValue(I);
			_operGate2.ScrolltoValue(I);
		}
		
		function UpdateKey(result:Array):void 
		{
			//trace("update key:" + _key);
			_key.Update(result);
		}
		
		public function Reset()
		{
			//trace("operGroup reset");
			_switchGate.Reset();
			//trace("key update:" + _initOperArray);
			_key.Update(_initValue);
			_operGate1.ReSetValues(_initOperArray);
			_operGate2.ReSetValues(_initOperArray);
			for (var i:int = 0; i < 4; i++) 
			{
				_savedResult[i] = _initValue[i];
			}
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
		}
		
	}

}