component extends="tests.resources.BaseIntegrationSpec" appMapping="/"{
	
	property name="query" 		inject="provider:QueryBuilder@qb";
	property name="bcrypt" 		inject="@BCrypt";
	property name="auth"		inject="authenticationService@cbauth";

	function beforeAll(){
		super.beforeAll();
		query.from( "users" )
			.insert( values = {
				username : "testuser",
				email : "testuser@tests.com",
				password : bcrypt.hashPassword( "password" )
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

		describe( "sessions Suite", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			});

			it( "can present the login screen", function(){
				var event = get( route="sessions/new" );
				// expectations go here.
				expect( event.getRenderedContent() ).toInclude( "Log In" );
				auth.logout();
			});

			it( "can log in a valid user", function(){
				var event = post( route="/login", params={ username="testuser", password="password"} );
				// expectations go here.
				expect( event.getValue( "relocate_URI") ).toBe( "/" );
				expect( auth.isLoggedIn() ).toBeTrue();
			});

			it( "can show an invalid message for an invalid user", function(){
				var event = post( route="/login", params={ username="testuser", password="bad"} );
				// expectations go here.
				expect( event.getValue( "relocate_URI") ).toBe( "/login" );
			});

			it( "can logout a user", function(){
				var event = delete( route="logout" );
				// expectations go here.
				expect( auth.isLoggedIn() ).toBeFalse();
				expect( event.getValue( "relocate_URI") ).toBe( "/" );
			});
		
		});

	}

}