package com.cp 
{
	import com.BaseMovie;
	/**
	 * ...
	 * @author ...
	 */
	public class CP_Iontrap extends BaseMovie
	{
		private var _passward:Array;
		private var _myAnswer:Array;
		private var _initValues:Array;
		private var _groupArray:Array;
		private var _isSwitchOn:Boolean = false;
		
		public function CP_Iontrap() 
		{
			
		}
		
		public function set SwitchOn(value:Boolean):void 
		{
			_isSwitchOn = value;
		}
		
		public function set Password(value:Array)
		{
			_passward = value;
		}
		
		public function set InitValues(value:Array)
		{
			_initValues = value;
		}
		
		override protected function Init():void 
		{
			super.Init();
			_myAnswer = new Array();
			_groupArray = [this["g1"], this["g2"], this["g3"], this["g4"]];
			for (var i:int = 1; i <= 4; i++) //4 group
			{
				this["g" + i].InitValue = _initValues[i - 1];
				this["g" + i].IsSwitchOn = _isSwitchOn;
			}
		}
		
		public function Reset():void 
		{
			//trace("reset Iontrap");
			for each (var operGroup:CP_OperGroup in _groupArray)
			{
				operGroup.Reset();
			}
		}
		
		public function ClearInput()
		{
			for each (var operGroup:CP_OperGroup in _groupArray)
			{
				operGroup.ClearInput();
			}
		}
		
		private function Calc():void 
		{
			_myAnswer = new Array();
			for (var i:int = 0; i < 4; i++) 
			{
				_myAnswer.push((_groupArray[i] as CP_OperGroup).Calc())
				//trace("group" + i + " calced");
			}
			//return _myAnswer;
		}
		
		function GetInputAnswer():Array 
		{
			return null;
		}
		
		//check if input can get password 
		public function CheckAnswer():Boolean 
		{
			Calc();
			//trace("Answer to be check:" + _myAnswer);
			var result:Boolean = true;
			for (var i:int = 0; i < 4; i++) 
			{
				for (var j:int = 0; j <4 ; j++) 
				{
					if (Math.ceil(_myAnswer[i][j]) != _passward[i][j])
					{
						result = false;
						break;
					}
				}
			}
			return result;
		}
	}

}