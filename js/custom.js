$(document).ready(function() {
	refreshGameList();
});

/* Games List Functions */
function refreshGameList() {
	/* Test Code, Load from Database */
	var params = {};
	params['type'] = "query_games";
	$.post("php/query.php",
		params,
		function(response) {
			var html = "";
			var result = $.parseJSON(response);
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
			$("#game-list-container").html(html);
			//$(".loading").addClass("hidden");
		});
}

/* Genre List Functions */
function refreshGenreList() {
	var params = {};
	params['type'] = "query_genres";
	$.post("php/query.php",
		params,
		function(response) {
			var result = $.parseJSON(response);
			var html = "";
			for(var i = 0; i < result["genres"].length; i++) {
				var genre = result["genres"][i];
				html += "<div id=\"genre-" + genre["genrekey"] + "\" class=\"genre-container\">";
				html += genre["name"];
				if(genre["liked"]) {
					html += "<div id=\"genre-" + genre["genrekey"] + "-likebtn\" class=\"genre-like-btn genre-like-btn-sel\" onclick=\"unlikeGenre(" + genre["genrekey"] + ")\"></div>";
				} else {
					html += "<div id=\"genre-" + genre["genrekey"] + "-likebtn\" class=\"genre-like-btn\" onclick=\"likeGenre(" + genre["genrekey"] + ")\"></div>";
				}
				html += "</div>";
			}
			$("#genre-list-container").html(html);
		});
}

function likeGenre(genrekey) {
	var params = {};
	params['type'] = "push_genre_like";
	params['genrekey'] = genrekey;
	$.post("php/push.php",
		params,
		function(response) {
			var result = $.parseJSON(response);
			if(result["success"]) {
				$("#genre-" + genrekey + "-likebtn").addClass("genre-like-btn-sel");
				$("#genre-" + genrekey + "-likebtn").attr("onclick", "unlikeGenre(" + genrekey + ")");
			} else {
				notify(result["message"]);
			}
		});
}

function unlikeGenre(genrekey) {
var params = {};
	params['type'] = "push_genre_unlike";
	params['genrekey'] = genrekey;
	$.post("php/push.php",
		params,
		function(response) {
			var result = $.parseJSON(response);
			if(result["success"]) {
				$("#genre-" + genrekey + "-likebtn").removeClass("genre-like-btn-sel");
				$("#genre-" + genrekey + "-likebtn").attr("onclick", "likeGenre(" + genrekey + ")");
			} else {
				notify(result["message"]);
			}
		});
}

/* Navigation Functions */

function listGames(tab) {
	if($(tab).parent().hasClass("active")) {
		// Do Nothing
	} else {
		// Currently Active Tab
		var activetab = $(tab).parent().parent().children(".active");

		refreshGameList();
		$("#game-list-viewport").show('slide', {direction:'right'});

		// Switch Active Tab
		$(tab).parent().addClass("active");
		activetab.removeClass("active");
		// Force Active Viewport to Close
		eval(activetab.children("a").attr("close"));
	}
}
function hideListGames(tab) {
	$("#game-list-viewport").hide('slide', {direction:'left'});
}

function listGenres(tab) {
	if($(tab).parent().hasClass("active")) {
		// Do Nothing
	} else {
		// Currently Active Tab
		var activetab = $(tab).parent().parent().children(".active");

		refreshGenreList();
		$("#genre-list-viewport").show('slide', {direction:'right'});

		// Switch Active Tab
		$(tab).parent().addClass("active");
		activetab.removeClass("active");
		// Force Active Viewport to Close
		eval(activetab.children("a").attr("close"));
	}
}
function hideListGenres(tab) {
	$("#genre-list-viewport").hide('slide', {direction:'left'});
}

/* Game View Functions */

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
			html += gameReviews(result);
			html += "</div>";
			html += "</div>";
			$(".game-view-container").html(html);
			$(".game-view-viewport").show('slide', {direction:'down'});
			$(".loading").addClass("hidden");
		});
}

function gameReviews(result) {
	var html = "";
	html += "<div class=\"game-view-reviews-container\">";
	var review = result["gameinfo"]["userreview"];
	var reviewid = "review-" + result["gameinfo"]["gamekey"] + "-" + review["userkey"];
	if(review["username"] != null) {
		html += "<div class=\"game-view-reviews-label\"><b>Your Review:</b></div>";
		html += "<div id=\"" + reviewid + "\" class=\"game-view-review-container\">";
		html += "<div class=\"game-view-review-head\">";
		html += review["username"];
		if(review["timestamp"]) { //Timestamp only exists if Review Exists (If So, hide delete button)
			html += "<div id=\"" + reviewid + "-deletebtn\" class=\"game-view-review-delete\" onclick=\"deleteReview(" + result["gameinfo"]["gamekey"] + ", " + review["userkey"] + ")\"></div>";
			html += "<div id=\"" + reviewid + "-editbtn\" class=\"game-view-review-edit\" onclick=\"showEditReview(" + result["gameinfo"]["gamekey"] + ", " + review["userkey"] + ")\"></div>";
		} else {
			html += "<div id=\"" + reviewid + "-deletebtn\" class=\"game-view-review-delete\" style=\"display:none\" onclick=\"deleteReview(" + result["gameinfo"]["gamekey"] + ", " + review["userkey"] + ")\"></div>";
			html += "<div id=\"" + reviewid + "-editbtn\" class=\"game-view-review-edit\" onclick=\"newReview(" + result["gameinfo"]["gamekey"] + ", " + review["userkey"] + ")\"></div>";
		}
		html += "</div>";
		html += "<div id=\"" + reviewid + "-body\" class=\"game-view-review-body\">";
		if(review["rating"]) {
			html += review["rating"] + " / 5 <br />";
		}
		if(review["title"]) {
			html += "<h4>" + unescape(review["title"]) + "</h4>";
		}
		if(review["body"]) {
			html += unescape(review["body"]);
		}
		if(!review["timestamp"]) {
			html += "Doesn't Exist! <div style=\"float:right\"> Write One! ^^^^ </div>";
		}
		html += "<div id=\"" + reviewid + "-json\" style=\"display:none\">" + JSON.stringify(review) + "</div>";
		html += "</div>";
		html += "</div>";
	}

	html += "<div class=\"game-view-reviews-label\"><b>Reviews:</b></div>";
	for(var i = 0; i < result["gameinfo"]["reviews"].length; i++) {
		var review = result["gameinfo"]["reviews"][i];
		var reviewid = "review-" + result["gameinfo"]["gamekey"] + "-" + review["userkey"];
		html += "<div id=\"" + reviewid + "\" class=\"game-view-review-container\">";
		html += "<div class=\"game-view-review-head\">";
		html += review["username"];
		if(review["edit"]) {
			html += "<div id=\"" + reviewid + "-deletebtn\" class=\"game-view-review-delete\" onclick=\"deleteReview(" + result["gameinfo"]["gamekey"] + ", " + review["userkey"] + ")\"></div>";
			html += "<div id=\"" + reviewid + "-editbtn\" class=\"game-view-review-edit\" onclick=\"showEditReview(" + result["gameinfo"]["gamekey"] + ", " + review["userkey"] + ")\"></div>";
		}
		html += "</div>";
		html += "<div id=\"" + reviewid + "-body\" class=\"game-view-review-body\">";
		if(review["rating"]) {
			html += review["rating"] + " / 5 <br />";
		}
		if(review["title"]) {
			html += "<h4>" + unescape(review["title"]) + "</h4>";
		}
		if(review["body"]) {
			html += unescape(review["body"]);
		}
		html += "<div id=\"" + reviewid + "-json\" style=\"display:none\">" + JSON.stringify(review) + "</div>";
		html += "</div>";
		html += "</div>";
	}
	html += "</div>";
	return html;
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
	html += "<div class=\"game-view-gameinfo-label\"><b>Studio(s):</b></div>";
	for(var i = 0; i < result["gameinfo"]["studios"].length; i++) {
		html += result["gameinfo"]["studios"];
		if(i < result["gameinfo"]["studios"].length - 1) {
			html += ", ";
		}
	}
	html += "<div class=\"game-view-gameinfo-label\"><b>Description:</b></div>";
	html += result["gameinfo"]["description"];
	return html;
}

function closeGame() {
	$(".game-view-viewport").hide('slide', {direction:'down'});
}

/* Review Functions */

function reviewAreaResize(o) {
	o.style.height = "0px";
	o.style.height = (25+o.scrollHeight) + "px";
}

function newReview(gamekey, userkey) {
	var reviewid = "review-" + gamekey + "-" + userkey;
	showEditReview(gamekey, userkey);
	$("#" + reviewid + "-editbtn").attr("onclick", "showEditReview(" + gamekey + ", " + userkey + ")");
}

function showEditReview(gamekey, userkey) {
	var reviewid = "review-" + gamekey + "-" + userkey;
	var review = $.parseJSON($("#" + reviewid + "-json").html());
	var html = "<form name=\"" + reviewid + "-form\" accept-charset=\"utf-8\">";
	html += "<label class=\"form-control\">Rating</label>";
	html += "<select class=\"form-control\" name=\"rating\" style=\"width:100%\">";
	html += "<option value=\"1\"" + ((review["rating"] == 1) ? "selected=\"selected\"" : "") + ">1 / 5</option>";
	html += "<option value=\"2\"" + ((review["rating"] == 2) ? "selected=\"selected\"" : "") + ">2 / 5</option>";
	html += "<option value=\"3\"" + ((review["rating"] == 3) ? "selected=\"selected\"" : "") + ">3 / 5</option>";
	html += "<option value=\"4\"" + ((review["rating"] == 4) ? "selected=\"selected\"" : "") + ">4 / 5</option>";
	html += "<option value=\"5\"" + ((review["rating"] == 5) ? "selected=\"selected\"" : "") + ">5 / 5</option>";
	html += "</select><br />";
	html += "<label class=\"form-control\">Title</label>";
	html += "<input class=\"form-control\" type=\"text\" name=\"title\" style=\"width:100%\" maxlength=\"127\" value=\"" + ((review["title"] != null) ? unescape(review["title"]) : "") + "\" /><br />";
	html += "<label class=\"form-control\">Body</label>";
	html += "<textarea class=\"form-control\" name=\"body\" onkeyup=\"reviewAreaResize(this)\" style=\"width:100%\" maxlength=\"2047\" >" + ((review["body"] != null) ? unescape(review["body"]) : "") + "</textarea>";
	html += "<div style=\"height:15px\">";
	html += "<input class=\"form-control\" id=\"review-form-subbtn\" type=\"submit\" style=\"float:right;width:150px\" value=\"Submit\" />";
	html += "</div>";
	html += "</form>";
	$("#" + reviewid + "-body").html(html);
	$("#" + reviewid + "-editbtn").hide();
	$("form[name='" + reviewid + "-form']").submit(function(e) {
		$(".loading").show();
		var review = {};
		review["rating"] = $("form select[name='rating']").val();
		var title = $("<div>" + $("form input[name='title']").val() + "</div>");
		title.find('script').remove();
		title.find('link').remove();
		title.find('style').remove();
		title.find('a').remove();
		title.find('iframe').remove();
		review["title"] = escape(title.html());
		var body = $("<div>" + $("form textarea[name='body']").val() + "</div>");
		body.find('script').remove();
		body.find('link').remove();
		body.find('style').remove();
		body.find('a').remove();
		body.find('iframe').remove();
		review["body"] = escape(body.html());
		editReview(gamekey, userkey, review);
		return false;
	});
}

function deleteReview(gamekey, userkey) {
	var result = confirm("Are you sure you want to delete this Review?");

	if(result) {
		$(".loading").show();

		// Initialize Push Params
		var params = {};

		// Set Push Type
		params['type'] = "push_delete_review";
		params['gamekey'] = gamekey;
		params['userkey'] = userkey;

		// POST to push.php
		$.post("php/push.php",
			params,
			function(response) {
				var result = $.parseJSON(response);
				if(result["success"]) {
					var reviewid = "review-" + gamekey + "-" + userkey;
					$("#" + reviewid).fadeOut(function() {
						if(userkey != result["userkey"]) {
							$("#" + reviewid).remove();
						} else {
							var html = "Doesn't Exist! <div style=\"float:right\"> Write One! ^^^^ </div>";
							html += "<div id=\"" + reviewid + "-json\" style=\"display:none\">" + JSON.stringify({}) + "</div>";
							$("#" + reviewid + "-editbtn").attr("onclick", "newReview(" + gamekey + ", " + userkey + ")");
							$("#" + reviewid + "-deletebtn").hide();
							$("#" + reviewid + "-body").html(html);
							$("#" + reviewid).fadeIn();
						}
					});
				} else {
					notify(result["message"]);
				}
				$(".loading").hide();
			});
	} else {
		// Do Nothing
	}
}

function editReview(gamekey, userkey, reviewIn) {
	var reviewid = "review-" + gamekey + "-" + userkey;
	var html = "";
	if(reviewIn["rating"]) {
		html += reviewIn["rating"] + " / 5 <br />";
	}
	if(reviewIn["title"]) {
		html += "<h4>" + unescape(reviewIn["title"]) + "</h4>";
	}
	if(reviewIn["body"]) {
		html += unescape(reviewIn["body"]);
	}
	html += "<div id=\"" + reviewid + "-json\" style=\"display:none\">" + JSON.stringify(reviewIn) + "</div>";

	var params = {};

	// Set Push Type
	params['type'] = "push_review";

	// Create Review Container & Fill
	var review = {};
	review['type'] = "full";
	review['gamekey'] = gamekey;
	review['userkey'] = userkey;
	review['rating'] = reviewIn["rating"];
	review['title'] = reviewIn["title"];
	review['body'] = reviewIn["body"];

	// Attach Review Container to Params
	params['review'] = review;

	// POST to push.php
	$.post("php/push.php",
		params,
		function(response) {
			var result = $.parseJSON(response);
			if(result['success']) {
				$("#" + reviewid + "-body").html(html);
				$("#" + reviewid + "-editbtn").show();
				$("#" + reviewid + "-deletebtn").show();
			} else {
				notify(result['message']);
			}
			$(".loading").hide();
		});
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
			var result = $.parseJSON(response);
			if(!result['success']) {
				notify(result['message']);
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
			var result = $.parseJSON(response);
			if(!result['success']) {
				notify(result['message']);
			}
			$(".loading").addClass("hidden");
		});
}

/*
  Push Full Review, Include userkey to allow modification of 
  any user's reviews by Admins
*/
function pushFullReview(gamekey, userkey, rating, title, body) {
	$(".loading").removeClass("hidden");
	var params = {};

	// Set Push Type
	params['type'] = "push_review";

	// Create Review Container & Fill
	var review = {};
	review['type'] = "full";
	review['userkey'] = userkey;
	review['gamekey'] = gamekey;
	review['rating'] = rating;
	review['title'] = title;
	review['body'] = body;

	// Attach Review Container to Params
	params['review'] = review;

	// POST to push.php
	$.post("php/push.php",
		params,
		function(response) {
			var result = $.parseJSON(response);
			if(!result['success']) {
				notify(result['message']);
			}
			$(".loading").addClass("hidden");
		});
}

/* Notification Function */

function notify(message) {
	var n = $(".notification-container");
	n.hide();
	n.stop();
	n.html("<b>" + message + "</b>");
	n.show('fade');
	n.delay(1500).hide('fade');
}

/* Footer Function */

function showFooterBtn() {
	$(".footer-show-btn").show('fade');
}
function hideFooterBtn() {
	$(".footer-show-btn").hide('fade');
}

function showFooter() {
	$(".footer-container").show('fade');
}
function hideFooter() {
	$(".footer-container").hide('fade');
}
