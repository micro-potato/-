package com.cp 
{
	import com.BaseMovie;
	import flash.accessibility.AccessibilityImplementation;
	/**
	 * ...
	 * @author ...
	 */
	public class CP_Key extends BaseMovie
	{
		var _initValue:Array;
		public function CP_Key() 
		{
			
		}
		
		override protected function Init():void 
		{
			super.Init();
			Update(_initValue);
		}
		
		public function set InitValue(value:Array)
		{
			_initValue = value;
			//trace("key init:" + value);
		}
		
		public function Update(valueArray:Array):void 
		{
			//trace("key update to:" + valueArray);
			if (valueArray.length != 4)
			{
				trace("Key计算结果格式错误");
			}
			else
			{
				for (var i:int = 1; i <=4 ; i++) 
				{
					//UpdateChi(i, Math.round(valueArray[i - 1]));
					var chiValue:Number = valueArray[i - 1];
					if (chiValue != 0)
					{
						chiValue = chiValue / Math.abs(chiValue);
					}
					UpdateChi(i, int(chiValue));
				}
			}
		}
		
		function UpdateChi(chiNo:int,value:int):void 
		{
			if (value == 0)
			{
				this["p" + chiNo].visible = false;
				this["n" + chiNo].visible = false;
			}
			else
			{
				if (value == 1)
				{
					this["p" + chiNo].visible = true;
					this["n" + chiNo].visible = false;
				}
				else
				{
					this["p" + chiNo].visible = false;
					this["n" + chiNo].visible = true;
				}
			}
		}
	}
}