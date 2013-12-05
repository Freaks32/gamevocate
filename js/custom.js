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
				var gamekey = result["games"][i]["gamekey"];
				var ratingmaskwidth = 100 - (result["games"][i]["avgrating"] * 20.0);
				var gamelinkstart = "<a href=\"#\" onclick=\"viewGame(" + gamekey + ")\">";
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
				html += "<div id=\"game-rate-" + gamekey + "\" class=\"game-rating\" style=\"padding-right:" + ratingmaskwidth + "%\"></div>";
				html += "<div id=\"game-urate-" + gamekey + "\" class=\"game-user-rating hide-rating\"></div>";
				html += "<ul class=\"game-rating-actions\" onmouseout=\"dispRating(" + gamekey + ",0)\">";
				html += "<li class=\"game-rating-value game-rating-5\" onmouseover=\"dispRating(" + gamekey + ",5)\" onclick=\"pushRating(" + gamekey + ",5)\"></li>";
				html += "<li class=\"game-rating-value game-rating-4\" onmouseover=\"dispRating(" + gamekey + ",4)\" onclick=\"pushRating(" + gamekey + ",4)\"></li>";
				html += "<li class=\"game-rating-value game-rating-3\" onmouseover=\"dispRating(" + gamekey + ",3)\" onclick=\"pushRating(" + gamekey + ",3)\"></li>";
				html += "<li class=\"game-rating-value game-rating-2\" onmouseover=\"dispRating(" + gamekey + ",2)\" onclick=\"pushRating(" + gamekey + ",2)\"></li>";
				html += "<li class=\"game-rating-value game-rating-1\" onmouseover=\"dispRating(" + gamekey + ",1)\" onclick=\"pushRating(" + gamekey + ",1)\"></li>";
				html += "</ul>";
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
			html += gameInfo(result);
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

function gameInfo(result) {
	var html = "";
	html += "<div class=\"game-view-gameinfo-label\"><b>Genre(s):</b></div>";
	for(var i = 0; i < result["gameinfo"]["genres"].length; i++) {
		html += result["gameinfo"]["genres"][i];
		if(i < result["gameinfo"]["genres"].length - 1) {
			html += ", ";
		}
	}
	html += "<br />";
	html += "<div class=\"game-view-gameinfo-label\"><b>Description:</b></div>";
	html += result["gameinfo"]["description"];
	return html;
}

function closeGame() {
	$(".game-view-viewport").hide('slide', {direction:'down'});
}

/* Ratings */

function dispRating(gamekey, rating) {
	if(rating == 0) {
		$("#game-rate-" + gamekey).removeClass("hide-rating");
	} else {
		$("#game-rate-" + gamekey).addClass("hide-rating");
	}
	var padd = (5 - rating) * 20;
	$("#game-urate-" + gamekey).css("padding-right", padd + "%");
	$("#game-urate-" + gamekey).removeClass("hide-rating");
}

function loadRating(gamekey) {
	var params = {};

	// Set Query Type
	params['type'] = "query_gamerating";
	params['gamekey'] = gamekey;

	// POST to query.php
	$.post("php/query.php",
		params,
		function(response) {
			var result = $.parseJSON(response);
			console.log(result);
			var padd = (5 - result['rating']) / 5 * 100;
			$("#game-rate-" + gamekey).css("padding-right", padd + "%"); 
		});
}

function pushRating(gamekey, rating) {
	$(".loading").removeClass("hidden");
	var params = {};

	// Set Push Type
	params['type'] = "push_review";
	
	// Create Review Container & Fill
	var review = {};
	review['type'] = "rating";
	review['gamekey'] = gamekey;
	review['rating'] = rating;

	// Attach Review Container to Params
	params['review'] = review;

	// POST to push.php
	$.post("php/push.php",
		params,
		function(response) {
			console.log(response);
			var result = $.parseJSON(response);
			console.log(result);
			if(!result['success']) {
				alert("Error while pushing Rating");
			} else {
				loadRating(gamekey);
			}
			$(".loading").addClass("hidden");
		});
}

function pushReview(gamekey, title, body) {
	$(".loading").removeClass("hidden");
	var params = {};

	// Set Push Type
	params['type'] = "push_review";

	// Create Review Container & Fill
	var review = {};
	review['type'] = "review";
	review['gamekey'] = gamekey;
	review['title'] = title;
	review['body'] = body;

	// Attach Review Container to Params
	params['review'] = review;

	// POST to push.php
	$.post("php/push.php",
		params,
		function(response) {
			console.log(response);
			var result = $.parseJSON(response);
			console.log(result);
			if(!result['success']) {
				alert("Error while pushing Review");
			}
			$(".loading").addClass("hidden");
		});
}
