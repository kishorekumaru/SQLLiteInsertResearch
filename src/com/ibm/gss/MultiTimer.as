package com.ibm.gss
{
	import flash.utils.Timer;
	
	public class MultiTimer extends Timer
	{
		private var _id:int;
		public function MultiTimer(delay:Number, repeatCount:int=0)
		{
			super(delay, repeatCount);
		}
		
		
		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

	}
}