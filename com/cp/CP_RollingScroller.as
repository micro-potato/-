package com.cp {
	
	import com.BaseMovie;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class CP_RollingScroller extends BaseMovie {
		
		private var _values:Array = new Array();
		private var _activeValue:String = "";
		private var _inputValues:Array = new Array();
		private var _inputHeight:int = 0;
		private var _centerIndex:int = 0;
		
		var _inputSprite:Sprite = new Sprite();
		var _maskSprite:Sprite = new Sprite();
		var _dragSprite:Sprite = new Sprite();
		
		public const CIN:String = "CIN";
		public const COUT:String = "COUT";
		
		public function CP_RollingScroller() {
			// constructor code
		}
		
		public function get ActiveValue():String
		{
			return _activeValue;
		}
		
		public function InitValues(value:Array):void 
		{
			_values = value;
			trace(value);
			InitRollingScroller();
		}
		
		function InputValues():Array 
		{
			var values:Array = new Array();
			var valueCount:int = _values.length;
			for (var i:int = 1; i < valueCount; i++) 
			{
				values.push(_values[i]);
			}
			values.push(_values[0]);
			for (var j:int = 1; j < valueCount; j++) 
			{
				values.push(_values[j]);
			}
			return values;
		}
		
		override protected function Init():void 
		{
			super.Init();
		}
		
		function InitRollingScroller():void //set inputs count,location,value,dragRec
		{
			//trace("InitRollingScroller");
			this.addChild(_inputSprite);
			this.addChild(_maskSprite);
			_inputValues = InputValues();
			_centerIndex = _values.length - 1;
			var centerInput:CP_RollingInput = new CP_RollingInput();
			_inputSprite.addChild(centerInput);
			centerInput.InputValue = _inputValues[_centerIndex];
			_inputHeight = centerInput.height;
			
			var inputCount:int = _inputValues.length;
			for (var i:int = 0; i <inputCount ; i++) 
			{
				if (i == _centerIndex)//centerInput already added
				{
					continue;
				}
				else
				{
					var dIndex:int = i - _centerIndex;
					var ly:int = dIndex * _inputHeight;
					var input:CP_RollingInput = new CP_RollingInput();
					_inputSprite.addChild(input);
					//this.addChild(input);
					input.y = ly;
					input.InputValue = _inputValues[i];
				}
			}
			
			var maskmc = new Rolling_Mask();
			_maskSprite.addChild(maskmc);
			_inputSprite.mask = _maskSprite;
			
			_dragSprite = new Rolling_Mask();
			this.addChild(_dragSprite);
			_dragSprite.alpha = 0;
			_dragSprite.x = _inputSprite.x;
			_dragSprite.y = _inputSprite.y;
			_dragSprite.width = _inputSprite.width;
			//_dragSprite.height = _inputSprite.height;
			_dragSprite.height = _inputHeight * 1.5;
			
			_dragSprite.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			//trace("_dragSprite size:" + _dragSprite.width + "," + _dragSprite.height);
			_activeValue = _values[0];
		}
		
		/*-------------------------movement-------------------------*/
		var _prevY:int = 0; 
		var _curY:int = 0; 
		var _speed:Number = 0.5;
		
		
		function OnMouseDown(e:MouseEvent):void 
		{
			//_prevY = e.localY;
			//_dragSprite.removeEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			//_dragSprite.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
			//_dragSprite.addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut);
			//_dragSprite.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			
			_prevY = e.stageY;
			_dragSprite.removeEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
		}
		
		function OnMouseUp(e:Event):void 
		{
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
			_dragSprite.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			CorrectionScrollResult();
		}
		
		function OnMouseMove(e:MouseEvent):void 
		{
			
			var curY:int = e.stageY;
			var dy:int = curY - _prevY;
			var ty:int = _inputSprite.y + _speed * dy;
			UpdateScroll(ty);
			_prevY = curY;
		}
		
		//update rollingscroller location by drag result
		function UpdateScroll(targetY:int):void 
		{
			var dIndex:int = Math.round(targetY / _inputHeight);
			if (Math.abs(dIndex) != (_values.length - 1))
			{
				_inputSprite.y = targetY;
			}
			else
			{
				if (dIndex > 0)
				{
					_inputSprite.y -= _values.length * _inputHeight;
				}
				else
				{
					_inputSprite.y += _values.length * _inputHeight;
				}
			}
		}
		
		function CorrectionScrollResult():void 
		{
			var dIndex:int = Math.round(_inputSprite.y / _inputHeight);
			_inputSprite.y = dIndex * _inputHeight;
			var valueIndex:int = _centerIndex - dIndex;
			var targetValue:String = _inputValues[valueIndex];
			if (targetValue != _activeValue)
			{
				if (targetValue == "C")
				{
					this.dispatchEvent(new Event(CIN));
				}
				else if (_activeValue == "C")
				{
					this.dispatchEvent(new Event(COUT));
				}
			}
			_activeValue = targetValue;
			//trace("valueIndex:"+valueIndex+",get value:" + _activeValue);
		}
		
		public function ScrolltoValue(value:String)
		{
			//trace("scroll to value");
			var valueIndex:int = _inputValues.indexOf(value);
			//trace(_inputValues);
			//trace("valueIndex:" + valueIndex);
			
			if (valueIndex<0||_activeValue==value)
			{
				return;
			}
			else
			{
				var offset:int = _centerIndex-valueIndex;
				//trace("offset:" + offset);
				_inputSprite.y = offset * _inputHeight;
			}
			_activeValue = value;
		}
		
		
		/*--------------------------------------------Reset Values--------------------------------------------*/
		public function ReSetValues(values:Array):void
		{
			//trace("reset opers to :"+values);
			//Remove old values
			_values = values;
			_inputSprite.y = 0;
			_inputSprite.removeChildren();
			_maskSprite.removeChildren();
			_dragSprite.removeEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			this.removeChild(_dragSprite);
			InitRollingScroller();
		}
	}
}
