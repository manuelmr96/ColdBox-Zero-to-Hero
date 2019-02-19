/**
* I am a new Model Object
*/
component singleton accessors="true"{
	
	// Properties
	// To populate objects from data
    property name="populator" inject="wirebox:populator";
    // To create new User instances
    property name="wirebox" inject="wirebox";
    // For encryption
    property name="bcrypt" inject="@BCrypt";
	

	/**
	 * Constructor
	 */
	UserService function init(){
		
		return this;
	}

	array function list(){
		return queryExecute( "select * from users", {}, { returntype = "array" } );
	}

	/**
	 * Create a new user
	 *
	 * @email 
	 * @username 
	 * @password 
	 * 
	 * @return The created id of the user
	 */
	function create( required user ){
		queryExecute(
			"
				INSERT INTO `users` (`email`, `username`, `password`)
				VALUES (?, ?, ?)
			",
			[
				user.getEmail(),
				user.getUsername(),
				bcrypt.hashPassword( user.getPassword() )
			],
			{ result = "local.result" }
		);
		user.setId( result.generatedKey );
		return user;
	}

	
	/**
	* validCreateUser
	*/
	numeric function validCreateUser( required string email, required string username ){
		return ArrayLen(queryExecute( "select * from users where username = :username or email = :email ",[  username = arguments.username, email = arguments.email ], { returntype = "array" } ));
	}
	
	 User function new() provider="User"{}

	User function retrieveUserById( id ) {
        return populator.populateFromQuery(
            new(),
            queryExecute( "SELECT * FROM `users` WHERE `id` = ?", [ id ] ),
            1
        );
    }

    User function retrieveUserByUsername( username ) {
        return populator.populateFromQuery(
            new(),
            queryExecute( "SELECT * FROM `users` WHERE `username` = ?", [ username ] ),
            1
        );
    }

    boolean function isValidCredentials( username, password ) {
		var oUser = retrieveUserByUsername( username );
        if( !oUser.isLoaded() ){
            return false;
		}
		
        return bcrypt.checkPassword( password, oUser.getPassword() );
    }

}