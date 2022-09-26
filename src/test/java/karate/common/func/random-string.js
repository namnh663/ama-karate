function random_string(s) {

	var text = "";
	var pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	for (var i = 0; i < s; i++)
		text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
	return text;
}