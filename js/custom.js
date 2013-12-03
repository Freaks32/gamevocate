$(document).ready(function() {
	/* Test Code, Load from Database */
	var params = {};
	params['type'] = "query_games";
	$.post("php/query.php",
		params,
		function(response) {
			var html = "";
			var result = $.parseJSON(response);
			console.log(result);
			for(var i = 0; i < result["games"].length; i++) {
				var ratingmaskwidth = 100 - (result["games"][i]["avgrating"] * 20.0);
				var gamelinkstart = "<a href=\"#\" onclick=\"viewGame(" + result["games"][i]["gamekey"] + ")\">";
				var gamelinkend = "</a>";
				html += "<div class=\"game-container\">";
				html += "<div class=\"game-header-container\">";
				html += gamelinkstart;
				html += "<img class=\"game-pic\" src=\"" + result["games"][i]["image"] + "\"></img>";
				html += "<div class=\"game-title-container\">";
				html += result["games"][i]["title"];
				html += "</div>";
				html += gamelinkend;
				html += "<div class=\"game-rating-container\">";
				html += "<div class=\"game-rating\" style=\"padding-right:" + ratingmaskwidth + "%\"></div>";
				html += "</div>";
				html += "</div>";
				html += gamelinkstart;
				html += "<div class=\"game-body-container\">";
				html += result["games"][i]["description"];
				html += "</div>";
				html += gamelinkend;
				html += "</div>";
			}
			$(".game-list-container").html(html);
			//$(".loading").addClass("hidden");
		});
});

function viewGame(id) {
	$(".loading").removeClass("hidden");
	var params = {};
	params['type'] = "query_gameinfo";
	params['gamekey'] = id;
	$.post("php/query.php",
		params,
		function(response) {
			var html = "";
			var result = $.parseJSON(response);
			console.log(result);
			html += "<div class=\"game-view-header\">";
			html += "<div class=\"game-view-icon\"></div>";
			html += "<div class=\"game-view-closebutton\" onclick=\"closeGame()\"></div>";
			html += "<div class=\"game-view-title\">";
			html += result["gameinfo"]["title"];
			html += "</div>";
			html += "</div>";
			html += "<div class=\"game-view-body\">";
			html += "<div class=\"game-view-gameinfo\">";
			html += "<img class=\"game-view-image\" src=\"" + result["gameinfo"]["image"] + "\"></img>";
			html += "<div class=\"game-view-gameinfo-body\">";
			html += "Game Info Placeholder";
			html += "</div>";
			html += "</div>";
			html += "<div class=\"game-view-gamebody\">";
			html += "Game Body Placeholder";
			html += "</div>";
			html += "</div>";
			$(".game-view-container").html(html);
			$(".game-view-viewport").show('slide', {direction:'down'});
			$(".loading").addClass("hidden");
		});
}

function closeGame() {
	$(".game-view-viewport").hide('slide', {direction:'down'});
}
