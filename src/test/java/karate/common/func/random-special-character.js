function random_character(s) {

	var text = "";
	var pattern = "~`!@#$%^&*()-_+={}[]|/:;'?<,.>";
	for (var i = 0; i < s; i++)
		text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
	return text;
}