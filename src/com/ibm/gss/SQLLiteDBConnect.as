/** 
 * Date  March 11 2014 
 * Author : Kishore kumar Unnikrishnan
 * 
 * ------------------------------------------ *
 * DATABASE CONNECTION Class
 * ------------------------------------------ *
 * 
 * Constructor paramter {DB File Name <String>}
 * function (executeQuery) paramter {Query}
 * 
 * RULES - Windows 7
 * 1. Use only ApplicationFile path to store the Database
 * 2. Use of ApplicationStorageDirectory or DesktopDirectory 
 * 	  or DocumentsDirectory leads to Authentication Error
 * 
 **/


package com.ibm.gss{
	
	import com.ibm.gss.events.SQLConnectionError;
	import com.ibm.gss.events.SQLConnectionResult;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import mx.utils.StringUtil;

	[Event(name="resultFailure", type="com.ibm.gss.events.SQLConnectionError")]
	[Event(name="dbSuccess", type="com.ibm.gss.events.SQLConnectionResult")]
	[Event(name="queryResult", type="com.ibm.gss.events.SQLConnectionResult")]
	public class SQLLiteDBConnect extends EventDispatcher{
		
		
		protected var _connectionObject:SQLConnection;
		protected var _queryStatment:SQLStatement;
		protected var _dbFolderLoc:File;
		
		public static const INSERT:String = "insert";
		public static const CREATE:String = "create";
		public static const DELETE:String = "delete";
		public static const UPDATE:String = "update";

		public function SQLLiteDBConnect(dbName:String){	
			try{
				_connectionObject = new SQLConnection();
				
				//Get the DB File Location path
				_dbFolderLoc = File.applicationDirectory.resolvePath(dbName);
				
				//Set the Resultant Propery
				_connectionObject.addEventListener(SQLEvent.OPEN, dbCreated);
				_connectionObject.addEventListener(SQLErrorEvent.ERROR, dbError);
				
				
				
				//Open the DB in AsyncMode
				_connectionObject.openAsync(_dbFolderLoc);		
				_connectionObject.cacheSize = 10000;
				

			}catch(e:Error){
				this.dispatchEvent(new SQLConnectionError(SQLConnectionError.RESULT_FAILURE,
					"Unhandled Exception",
					"DB Connection Error"));
			}
		}
		
		public function callBegin():void{
			_connectionObject.begin();
		}
		public function callCommit():void{
			_connectionObject.commit();
		}
		public function executeQuery(query:String):void{	
			try{
				_queryStatment = new SQLStatement();
				
				_queryStatment.addEventListener(SQLEvent.RESULT, queryResult);
				_queryStatment.addEventListener(SQLErrorEvent.ERROR, queryError);
				_queryStatment.sqlConnection = _connectionObject;

				_queryStatment.text = query;
				
				_queryStatment.execute();
			}catch(e:Error){
				this.dispatchEvent(new SQLConnectionError(SQLConnectionError.RESULT_FAILURE,
					"Unhandled Exception",
					"DB Query execution Connection Error"));
			}
		}
		
		public function closeConnection():void{
			_connectionObject.close();
		}

		
		// Success and Failure function for DB Creation
		private function dbCreated(e:SQLEvent):void{
			this.dispatchEvent(new SQLConnectionResult(SQLConnectionResult.DB_SUCCESS,true));
		}
		
		private function dbError(e:SQLErrorEvent):void{
			this.dispatchEvent(new SQLConnectionError(SQLConnectionError.RESULT_FAILURE,e.error.message, e.error.details));
		}
		

		// Success and Failure function for DB Creation
		private function queryResult(e:SQLEvent):void{
			_queryStatment.removeEventListener(SQLEvent.RESULT, queryResult);
		
			var queryType:String = StringUtil.trim(e.currentTarget.text.split(" ")[0]).toUpperCase();
			
			this.dispatchEvent(new SQLConnectionResult(SQLConnectionResult.QUERY_RESULT,true,queryType));
			
		}
		
		private function queryError(e:SQLErrorEvent):void{
			_queryStatment.removeEventListener(SQLErrorEvent.ERROR, queryError);
			this.dispatchEvent(new SQLConnectionError(SQLConnectionError.RESULT_FAILURE,e.error.message, e.error.details));
		}


	}
}