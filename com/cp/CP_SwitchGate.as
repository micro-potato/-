package com.cp 
{
	import com.BaseMovie;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class CP_SwitchGate extends BaseMovie
	{
		private var _value1:String = "OFF";
		private var _value2:String = "ON";
		private var _initValue:String = "OFF";
		private var _isActive:Boolean = false;
		
		public const ValueChanged:String = "ValueChanged";

		public function CP_SwitchGate() 
		{
			
		}
		
		public function set IsActive(value:Boolean):void
		{
			//trace("set gate switch available:" + value);
			_isActive = value;
		}
		
		public function get ActiveValue():String
		{
			return this["t_value"].text;
		}
		
		public function Reset()
		{
			this["t_value"].text=_initValue;
		}
		
		override protected function Init():void 
		{
			super.Init();
			this.addEventListener(MouseEvent.CLICK, OnClick);
			if (_isActive == true)
			{
				this.gotoAndStop(2);
				_initValue = _value2;
				this["t_value"].text = _value2;
			}
			else
			{
				_initValue = _value1;
				this.gotoAndStop(1);
				this["t_value"].text = _value1;
			}
		}
		
		function OnClick(e:Event):void 
		{
			if (!this._isActive)
			{
				return;
			}
			if (this["t_value"].text == _value1)
			{
				this["t_value"].text = _value2;
			}
			else
			{
				this["t_value"].text = _value1;
			}
			this.dispatchEvent(new Event(ValueChanged));
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			this.removeEventListener(MouseEvent.CLICK, OnClick);
		}
		
	}

}