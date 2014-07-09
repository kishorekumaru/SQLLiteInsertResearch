package com.ibm.gss.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class SQLConnectionResult extends Event
	{
		public static const DB_SUCCESS:String = "dbSuccess";
		public static const QUERY_RESULT:String = "queryResult";
		
		public var dbCreated:Boolean = false;
		public var resultArray:ArrayCollection = new ArrayCollection();
		public var queryType:String = "";
		public static const CREATE:String = "CREATE";
		public static const INSERT:String = "INSERT";
		public static const DELETE:String = "DELETE";
		public static const UPDATE:String = "UPDATE";
		public static const CALL:String = "CALL";
		
		
		public function SQLConnectionResult(type:String, 
										   dbCreated:Boolean=false,
										   queryType:String="",
										   resultArray:ArrayCollection=null,
										   bubbles:Boolean=false, 
										   cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			
			this.dbCreated = dbCreated;
			this.resultArray = resultArray;
			this.queryType = queryType;
		}
	}
}