package karate.common.utils;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.json.JSONObject;

public class BCSToken {
	
	public static String GetTokenInQc() throws Exception {
		Var var = new Var();
		String json = readFileAsString(var.requestBcsQcTokenFile);

		var request = HttpRequest.newBuilder().uri(URI.create(var.qcInitTokenUrl)).header("Content-Type", "application/json")
				.POST(HttpRequest.BodyPublishers.ofString(json)).build();

		var client = HttpClient.newHttpClient();
		var response = client.send(request, HttpResponse.BodyHandlers.ofString());

		JSONObject jsnobject = new JSONObject(response.body());
		String token = jsnobject.getString("token");

		return token;
	}
	
	public static String GetTokenInStag() throws Exception {
		Var var = new Var();
		String json = readFileAsString(var.requestBcsStagTokenFile);

		var request = HttpRequest.newBuilder().uri(URI.create(var.stagInitTokenUrl)).header("Content-Type", "application/json")
				.POST(HttpRequest.BodyPublishers.ofString(json)).build();

		var client = HttpClient.newHttpClient();
		var response = client.send(request, HttpResponse.BodyHandlers.ofString());

		JSONObject jsnobject = new JSONObject(response.body());
		String token = jsnobject.getString("token");

		return token;
	}
	
	public static String GetAppNameInQc() throws Exception {
		Var var = new Var();
		String json = readFileAsString(var.requestBcsQcTokenFile);

		var request = HttpRequest.newBuilder().uri(URI.create(var.qcInitTokenUrl)).header("Content-Type", "application/json")
				.POST(HttpRequest.BodyPublishers.ofString(json)).build();

		var client = HttpClient.newHttpClient();
		var response = client.send(request, HttpResponse.BodyHandlers.ofString());

		JSONObject jsnobject = new JSONObject(response.body());
		String game = jsnobject.getString("game");

		return game;
	}
	
	public static String GetAppNameInStag() throws Exception {
		Var var = new Var();
		String json = readFileAsString(var.requestBcsStagTokenFile);

		var request = HttpRequest.newBuilder().uri(URI.create(var.stagInitTokenUrl)).header("Content-Type", "application/json")
				.POST(HttpRequest.BodyPublishers.ofString(json)).build();

		var client = HttpClient.newHttpClient();
		var response = client.send(request, HttpResponse.BodyHandlers.ofString());

		JSONObject jsnobject = new JSONObject(response.body());
		String game = jsnobject.getString("game");

		return game;
	}

	private static String readFileAsString(String file) throws IOException {
		return new String(Files.readAllBytes(Paths.get(file)));
	}
}
