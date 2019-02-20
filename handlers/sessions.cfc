/**
* I am a new handler
*/
component{
	
	property name="auth" inject="authenticationService@cbauth";
	property name="messageBox" 	inject="messageBox@cbmessagebox";


	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};
		
	/**
	* new
	*/
	function new( event, rc, prc ){
		event.setView( "sessions/new" );
	}

	/**
	* create
	*/
	function create( event, rc, prc ){
		try {
			auth.authenticate( rc.username, rc.password );
			
			messagebox.success( "Welcome back #rc.username#" );
            return relocate( uri = "/" );
        }
        catch ( InvalidCredentials e ) {
            messagebox.warn( e.message );
            return relocate( uri = "/login" );
        }
	}

	/**
	* delete
	*/
	function delete( event, rc, prc ){
		auth.logout();
		messagebox.info( "Bye Bye! See ya soon!" );
        return relocate( uri = "/" );
	}


	
}
