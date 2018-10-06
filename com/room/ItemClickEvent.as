package com.room 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class ItemClickEvent extends Event
	{
		public var itemName:String;
		public static var ItemClicked:String = "ItemClicked";
		public function ItemClickEvent() 
		{
			super(ItemClicked,false,false);
		}
		
	}

}