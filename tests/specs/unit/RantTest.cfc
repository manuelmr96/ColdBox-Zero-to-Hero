component extends="tests.resources.BaseIntegrationSpec"{
	
	property name="query" 		inject="provider:QueryBuilder@qb";
	property name="bcrypt" 		inject="@BCrypt";

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		model = getInstance( "Rant" );
		
		cleanUserFixture();
		testUserId = query.from( "users" )
			.insert( values = {
				username : "testuser",
				email : "testuser@tests.com",
				password : bcrypt.hashPassword( "password" )
			} ).result.generatedKey;

		model.setUserId( testUserId );
	}

	function afterAll(){
		cleanUserFixture();
		super.afterAll();
	}

	function cleanUserFixture(){
		query.from( "users" )
			.where( "username", "=", "testuser" )
			.delete();
	}

	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( "Rant Suite", function(){
			
			it( "can create the Rant", function(){
				
				expect(	model ).toBeComponent();
				
			});

			it( "should getUser", function(){
				var oUser = model.getUser();

				expect( oUser.getId() ).toBe( testUserId );
			});


		});

	}

}