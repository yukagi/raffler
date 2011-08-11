$(windowLoad);
function windowLoad(){
    $(window).load(raffler);
}

function raffler(){

	var rowCount = $('#winnerTable tr').length;

	$('#winnerButton').click(function() {
		$.get("http://www.random.org/integers/?", {num: "1", min: "1", max: rowCount, col: "1", base: "10", format: "plain", rnd: "new"}, function(randNum) {
			var myNumber = randNum;
			$("#entry-" + randNum).addClass('winner');
//			$("#drawn").html('<p>'+randNum+'</p>');
		});
	});
	
};


