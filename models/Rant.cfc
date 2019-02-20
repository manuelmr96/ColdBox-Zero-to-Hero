/**
* I am a new Model Object
*/
component accessors="true"{

	// DI
	property name="userService" inject;
	
	// Properties
	property name="id"           type="string" default = "";
	property name="body"         type="string" default = "";
	property name="createdDate"  type="date";
	property name="modifiedDate" type="date";
	property name="userID"       type="string" default = "";
	

	/**
	 * Constructor
	 */
	Rant function init(){
		variables.createdDate = now();
		return this;
	}
	
	/**
	* getUser
	*/
	function getUser(){
		// Lazy loading the relationship
		return userService.retrieveUserById( getuserId() );
	}

	/**
	* isLoaded
	*/
	boolean function isLoaded(){
		return( !isNull( variables.id ) && len( variables.id ) );
	}


}