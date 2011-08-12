$(windowLoad);
function windowLoad(){
    $(window).load(raffler);
}

function raffler(){

	var rowCount = $('#winnerTable tr').length;
	
	$('#winnerButton').click(function() {

		initialNumber = Math.random() * (rowCount - 1);
		randNumber = Math.round(initialNumber);

		$("#entry-" + randNumber).addClass('winner');
		$("#drawn").html('<p>'+randNumber+'</p>');
		
	});
	
};