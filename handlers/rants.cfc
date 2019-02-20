// handlers/rants.cfc
/**
* I am a new handler
*/
component{
	
	property name="rantService" 	inject;
	property name="messagebox" 		inject="MessageBox@cbmessagebox";
		
	/**
	* index
	*/
	function index( event, rc, prc ){
		prc.aRants = rantService.getAll()
		event.setView( "rants/index" );
	}

	/**
	* new
	*/
	function new( event, rc, prc ){
		event.setView( "rants/new" );
	}

	/**
	* create
	*/
	function create( event, rc, prc ){
		var oRant = populateModel( "Rant" );

		oRant.setUserId( auth().getUserId() );

		rantService.create( oRant );

		messagebox.info( "Rant created!" );
		relocate( URI="/rants" );
	}


	
}