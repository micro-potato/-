package com.mc 
{
	import com.BaseMovie;
	import com.room.ItemClickEvent;
	import com.room.RoomMain;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ...
	 */
	public class BaseLv extends BaseMovie
	{
		public const LevelEnd:String = "LevelEnd";
		public const Success:String = "Success";
		public const Fail:String = "Fail";
		
		//protected const TimeLimit:String = "TimeLimit";
		protected const StepLimit:String = "StepLimit";
		
		protected var _itemstoFind:Array;
		protected var _itemsFound:Array;
		protected var _limitType:String;
		protected var _hint:MovieClip;
		protected var _foundMC:MovieClip;
		protected var _mc_intro:MovieClip;
		protected var _result:String;
		
		protected var _room:MovieClip;
		protected var _puzzle:MovieClip;
		
		protected var _isInRoom:Boolean;
		protected var _isShowDrHint = false;
		protected var _isHintatStart:Boolean;
		protected var _isCallHintAble:Boolean = true;
		protected var _isShowIntroBeforePuzzle = true;
		
		private var _currentLan:String;
		
		public function BaseLv() 
		{
			
		}
		
		public function set Lan(value:String):void 
		{
			_currentLan = value;
		}
		
		public function get Result():String
		{
			return _result;
		}
		
		override protected function Init():void 
		{
			super.Init();
			_itemsFound = [];
			
			if (_isInRoom)
			{
				LoadRoomScence();
			}
		}
		
		function OnHintClick(e:Event):void 
		{
			_hint.removeEventListener(MouseEvent.CLICK, OnHintClick);
			this.removeChild(_hint);
		}
		
		function OnHintCalled(e:Event):void 
		{
			trace("call hint");
			LoadHint();
		}
		
		private function LoadHint():void 
		{
			this.addChild(_hint);
			_hint.addEventListener(MouseEvent.CLICK, OnHintClick);
		}
		
		private function LoadRoomScence():void 
		{
			trace("LV lan:" + _currentLan);
			var path:String = _currentLan+"\\Room.swf";
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnRoomScenceLoad);
			loader.load(new URLRequest(path));
		}
		
		function OnRoomScenceLoad(e:Event):void 
		{
			var loadInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loadInfo.removeEventListener(Event.COMPLETE, OnRoomScenceLoad);
			_room = loadInfo.content as MovieClip;
			this.addChild(_room);
			_room.addEventListener(ItemClickEvent.ItemClicked, OnItemClick);
			_room.addEventListener("HintCalled", OnHintCalled);
			trace("Is show hint:" + _isHintatStart);
			if (_isHintatStart)
			{
				LoadHint();
			}
			if (!_isCallHintAble)
			{
				_room.DisableHit();
			}
			if (_isShowDrHint)
			{
				_room.ShowDrTip();
			}
		}
		
		function OnItemClick(e:ItemClickEvent):void 
		{
			var itemFound:String = e.itemName;
			var itemIndex:int = _itemstoFind.indexOf(itemFound);
			
			if (itemIndex >= 0)//is a item to find
			{
				this.addChild(_foundMC);
				_foundMC.gotoAndStop(itemIndex + 1);
				_foundMC.addEventListener(MouseEvent.CLICK, OnFoundItemMCclick);
			}
		}
		
		function OnFoundItemMCclick(e:Event):void 
		{
			var clickedMC:MovieClip = e.currentTarget as MovieClip;
			var frameIndex:int = clickedMC.currentFrame;
			var itemName:String = _itemstoFind[frameIndex - 1];
			clickedMC.removeEventListener(MouseEvent.CLICK, OnFoundItemMCclick);
			this.removeChild(clickedMC);
			CheckItemFound(itemName);
		}
		
		function CheckItemFound(itemName:String):void 
		{
			trace("item:" + itemName);
			if (_itemstoFind.indexOf(itemName) >= 0 && _itemsFound.indexOf(itemName) < 0)//find a new item in this lv
			{
				_itemsFound.push(itemName);
				trace(itemName+" found");
				if (_itemsFound.length == _itemstoFind.length)//find all items in this level
				{
					if (_isShowIntroBeforePuzzle)
					{
						LoadIntro();
					}
					else
					{
						LoadPuzzle();
					}
				}
			}
		}
		
		function LoadIntro():void 
		{
			this.addChild(_mc_intro);
			_mc_intro.addEventListener(MouseEvent.CLICK, OnIntroClick);
		}
		
		function OnIntroClick(e:Event):void 
		{
			_mc_intro.removeEventListener(MouseEvent.CLICK, OnIntroClick);
			this.removeChild(_mc_intro);
			LoadPuzzle();
		}
		
		function LoadPuzzle():void 
		{
			this.addChild(_puzzle);
			_puzzle.addEventListener(_puzzle.PuzzleEnd, OnPuzzleEnd);
		}
		
		function OnPuzzleEnd(e:Event):void 
		{
			OnPuzzleEndDeal();
		}
		
		protected function OnPuzzleEndDeal()
		{
			this._result = _puzzle.Result;
			this.dispatchEvent(new Event(this.LevelEnd));
			trace("get puzzle result:" + _result);
		}
		
		override protected function removed_from_stage(e:Event):void 
		{
			super.removed_from_stage(e);
			_room.removeEventListener("HintCalled", OnHintCalled);
		}
		
	}

}