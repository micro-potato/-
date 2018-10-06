package com.levels 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Lv4ResultValue 
	{
		public var value1:int;
		public var value2:int;
		
		private static var Instance:Lv4ResultValue;
		public function Lv4ResultValue() 
		{
			
		}
		
		public static function GetInstance():Lv4ResultValue 
		{
			if (Instance == null)
			{
				Instance = new Lv4ResultValue();
			}
			return Instance;
		}
		
	}

}