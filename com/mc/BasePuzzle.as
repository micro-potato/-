package com.mc 
{
	import com.BaseMovie;
	import com.EventMaster;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class BasePuzzle extends BaseMovie
	{
		public const PuzzleEnd:String = "PuzzleEnd";
		
		protected const Success:String = "Success";
		protected const Fail:String = "Fail";
		protected var _result:String;
		
		protected var _hasHint:Boolean = false;
		protected var _hasPwd:Boolean = false;
		
		protected var _mc_pwd:MovieClip;
		
		private var _homeBtn:MovieClip;
		public function BasePuzzle() 
		{
			
		}
		
		public function get Result():String
		{
			return _result;
		}
		
		override protected function Init():void 
		{
			super.Init();
			if (_hasPwd)
			{
				this["btn_pwd"].buttonMode = true;
				this["btn_pwd"].addEventListener(MouseEvent.CLICK, OnPwdBtnClick);
			}
			if (_hasHint)
			{
				this["btn_hint"].buttonMode = true;
				this["btn_hint"].addEventListener(MouseEvent.CLICK, OnHintBtnClick);
			}
			
			_homeBtn = this["btn_Home"];
			_homeBtn.addEventListener(MouseEvent.CLICK, OnHomeClick);
		}
		
		function OnPwdBtnClick(e:Event):void 
		{
			this.addChild(_mc_pwd);
			_mc_pwd.addEventListener(MouseEvent.CLICK, OnPwdMCclick);
		}
		
		function OnPwdMCclick(e:Event):void 
		{
			_mc_pwd.removeEventListener(MouseEvent.CLICK, OnPwdMCclick);
			this.removeChild(_mc_pwd);
		}
		
		function OnHintBtnClick(e:Event):void 
		{
			LoadHint();
		}
		
		protected function LoadHint()
		{
			var hintMC:MovieClip = new MC_PuzzleHint();
			this.addChild(hintMC);
			hintMC.addEventListener(MouseEvent.CLICK, OnHintMCclick);
		}
		
		function OnHintMCclick(e:Event):void 
		{
			var hintMC:MovieClip = e.currentTarget as MovieClip;
			hintMC.removeEventListener(MouseEvent.CLICK, OnPwdMCclick);
			this.removeChild(hintMC);
		}
		
		protected function TriggerResult()
		{
			this.dispatchEvent(new Event(this.PuzzleEnd));
		}
		
		function OnHomeClick(e:Event):void 
		{
			EventMaster.getInstance().dispatchEvent(new Event(EventMaster.OnHomeClick));
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			if (_hasPwd)
			{
				this["btn_pwd"].removeEventListener(MouseEvent.CLICK, OnPwdBtnClick);
			}
			if (_hasHint)
			{
				this["btn_hint"].removeEventListener(MouseEvent.CLICK, OnHintBtnClick);
			}
			
			_homeBtn.removeEventListener(MouseEvent.CLICK, OnHomeClick);
		}
		
	}

}