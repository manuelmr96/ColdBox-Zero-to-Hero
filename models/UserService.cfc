/**
* I am a new Model Object
*/
component singleton accessors="true"{
	
	// Properties
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
	numeric function create( required string email, required string username,  required string password ){
		queryExecute( 
			"
				INSERT INTO `users` ( `email`, `username`, `password` )
				VALUES ( ?, ?, ? )
			",
			[ 
				arguments.email, 
				arguments.username, 
				bcrypt.hashPassword( arguments.password )
			],
			{
				result : 'local.result'
			}
		);

		return local.result.generatedKey;
	}

	
	/**
	* validCreateUser
	*/
	numeric function validCreateUser( required string email, required string username ){
		return ArrayLen(queryExecute( "select * from users where username = :username or email = :email ",[  username = arguments.username, email = arguments.email ], { returntype = "array" } ));
	}
	

}