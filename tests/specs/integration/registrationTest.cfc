/*******************************************************************************
*	Integration Test as BDD (CF10+ or Railo 4.1 Plus)
*
*	Extends the integration class: coldbox.system.testing.BaseTestCase
*
*	so you can test your ColdBox application headlessly. The 'appMapping' points by default to 
*	the '/root' mapping created in the test folder Application.cfc.  Please note that this 
*	Application.cfc must mimic the real one in your root, including ORM settings if needed.
*
*	The 'execute()' method is used to execute a ColdBox event, with the following arguments
*	* event : the name of the event
*	* private : if the event is private or not
*	* prePostExempt : if the event needs to be exempt of pre post interceptors
*	* eventArguments : The struct of args to pass to the event
*	* renderResults : Render back the results of the event
*******************************************************************************/
component extends="tests.resources.BaseIntegrationSpec"{
		
	property name="query" 		inject="provider:QueryBuilder@qb";
	
	/*********************************** BDD SUITES ***********************************/
	function beforeAll(){
		super.beforeAll();
		query.from( "users" )
			.insert( values = {
				username : "testuser",
				email : "testuser@tests.com",
				password : ( "password" )
			} );
	}

	function afterAll(){
		super.afterAll();
		query.from( "users" )
			.where( "username", "=", "testuser" )
			.delete();
	}
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){
	
		describe( "Registration Suite", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			});

			it( "can show the user registration form", function(){
				var event = get( route="registration.new", params={} );
				// expectations go here.
				expect( event.getRenderedContent() ).toInclude( "Register for SoapBox" );
			});

			it( "can register a user", function() {
				expect( 
					queryExecute( 
						"select * from users where username = :username", 
						{ username : "testadmin" }, 
						{ returntype = "array" } 
					) 
				).toBeEmpty();

				var event = post( "/registration", {
					"username" = "testadmin",
					"email" = "testadmin@ortussolutions.com",
					"password" = "mypass1234",
					"passwordConfirmation" = "mypass1234"
				} );

				expect( event.getValue( "relocate_URI", "" ) ).toBe( "/" );

				var users = query.from( "users" )
					.where( "email", "=", "testadmin@ortussolutions.com" )	
					.get();
				expect( users ).toBeArray();
				expect( users[ 1 ].username ).toBe( "testadmin" );
			} );

		
		});

	}

}
