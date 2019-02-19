component extends="coldbox.system.EventHandler"{

	property name="userService"		inject="UserService";

	// Default Action
	function index(event,rc,prc){
		prc.aUsers = userService.list();
		prc.welcomeMessage = "Bienvenido a El Salvador!";
		event.setView("main/index");
	}

	// Do something
	function doSomething(event,rc,prc){
		relocate( "main.index" );
	}

	/************************************** IMPLICIT ACTIONS *********************************************/

	function onAppInit(event,rc,prc){

	}

	function onRequestStart(event,rc,prc){

	}

	function onRequestEnd(event,rc,prc){

	}

	function onSessionStart(event,rc,prc){

	}

	function onSessionEnd(event,rc,prc){
		var sessionScope = event.getValue("sessionReference");
		var applicationScope = event.getValue("applicationReference");
	}

	function onException(event,rc,prc){
		event.setHTTPHeader( statusCode = 500 );
		//Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		//Place exception handler below:
	}

}