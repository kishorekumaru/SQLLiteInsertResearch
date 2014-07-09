package com.ibm.gss.events{
	
	import flash.events.Event;
	
	public class SQLConnectionError extends Event{
	
		public static const RESULT_FAILURE:String = "resultFailure";
		
		public var errorMessage:String = "";
		public var errorDetails:String = "";
		
		public function SQLConnectionError(type:String,
										   errorMessage:String=null,
										   errorDetails:String=null,
										   bubbles:Boolean=false, 
										   cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			
			this.errorDetails = errorDetails;
			this.errorMessage = errorMessage;
		
		}
	}
}