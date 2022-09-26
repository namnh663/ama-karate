package karate.common.utils;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.json.JSONObject;

public class CMSToken {

	public static String Get() throws Exception {
		Var var = new Var();
		String json = readFileAsString(var.requestCmsTokenFile);

		var request = HttpRequest.newBuilder().uri(URI.create(var.oauthUrl))
				.header("Content-Type", "application/json")
				.POST(HttpRequest.BodyPublishers.ofString(json)).build();

		var client = HttpClient.newHttpClient();
		var response = client.send(request, HttpResponse.BodyHandlers.ofString());

		JSONObject jsnobject = new JSONObject(response.body());
		String token = jsnobject.getString("access_token");

		return token;
	}
	
	private static String readFileAsString(String file) throws IOException {
		return new String(Files.readAllBytes(Paths.get(file)));
	}
}
