var HTML_nav_acct_dropdown = "\
<li class='dropdown-header'>\
	Accounts\
</li><li>\
	<a id='fblogin' href=\"#\"><img class='dropdown-icon' src='images/icon/facebook.png' />Facebook<span style='float:right;'>#fb_login_stat</span></a>\
</li>";

$(document).ready(function() {
	//Load FB Api
	$.ajaxSetup({ cache: true });
	$.getScript('//connect.facebook.net/en_US/all.js', function(){
		FB.init({
			appId: '181513272053296',
			status: true,
			cookie: true,
			xfbml: true,
			oauth: true,
			channelUrl: 'www.bbamsch.com/transicat/channel.html',
		});     
		FB.getLoginStatus(facebookUpdate);
	});
});

function facebookUpdate() {
	FB.getLoginStatus(function(response) {
		console.log(response.status);
		if(response.status == 'connected') {
			FB.api('/me', function(response) {
				$("#nav_acct_btn").html(response.name);
				var tmp = HTML_nav_acct_dropdown;
				tmp = tmp.replace("#fb_login_stat", "&#10004;");
				$("#nav_acct_dropdown").html(tmp);
				$(".loading").addClass("hidden");
			});
		} else {
			$('.navbar').html($('.navbar').html().replace("#fb_login_url", "fbLogin()"));
			$(".loading").addClass("hidden");
		}
	});
}

function fbLogin() {
	FB.login(function(response) {
		if(response.status === 'connected') {
			var uid = response.authResponse.userID;
			//var accessToken = response.authResponse.accessToken;
			FB.api('/me', function(response) {
				console.log("CREATE ACCOUNT w/ UID = " + uid + " & NAME = " + response.name);
				createAccount(uid, response.name);
			});
			facebookUpdate();
		} else {
			alert("A Problem Occurred During Login");
		}
	});
}

function createAccount(uid, username) {
	var params = {};
	params['type'] = "create_acct";
	params['fbuid'] = uid;
	params['username'] = username;
	$.post("php/acct.php",
		params,
		function(response) {
			console.log("CREATE ACCOUNT: RESPONSE: " + response);
			var result = $.parseJSON(response);
			console.log("CREATE ACCOUNT: RESULT: " + result["success"]);
	});
}
