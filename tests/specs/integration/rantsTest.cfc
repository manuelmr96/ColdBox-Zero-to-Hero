component extends="tests.resources.BaseIntegrationSpec"{
	
	property name="query" 		inject="provider:QueryBuilder@qb";
	property name="bcrypt" 		inject="@BCrypt";
	property name="auth" 		inject="authenticationService@cbauth";

	/*********************************** LIFE CYCLE Methods ***********************************/

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
		// do your own stuff here
		super.afterAll();
		query.from( "users" )
			.where( "username", "=", "testuser" )
			.delete();
	}

	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( "rants Suite", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			});

			it( "can display all rants", function(){
				var event = get( route="/rants", params={} );
				// expectations go here.
				expect( event.getPrivateValue( "aRants") ).toBeArray();
				expect( event.getRenderedContent() ).toInclude( "All Rants" );
			});

			it( "can display the rants index when no rants exists", function(){
				prepareMock( getInstance( "RantService" ) )
					.$( "getAll", [] );
				var event = get( route="/rants", params={} );
				
				getWireBox().clearSingletons();

				expect( event.getPrivateValue( "aRants") ).toBeEmpty();
				expect( event.getRenderedContent() ).toInclude( "No rants yet" );
			});

			it( "can display the new rant form", function(){
				var event = get( route="/rants/new" );
				// expectations go here.
				expect( event.getRenderedContent() ).toInclude( "Rant About It" );
			});

			it( "can stop a rant from being created from an invalid user", function(){
				expect( function(){
					var event = post( route="rants.create", params={
						body = "Test Rant"
					} );
				}).toThrow( type="NoUserLoggedIn" );
			});
			
			it( "can create a rant from a valid user", function(){

				// Log in user
				auth.authenticate( "testuser", "password" );

				var event = post( route="rants.create", params={
					body = "Test Rant"
				} );

				expect( event.getValue( "relocate_URI" ) ).toBe( "/rants" );
			});

		
		});

	}

}