package karate.common.utils;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.client.methods.RequestBuilder;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

public class WebHooks {
	Var var = new Var();
	
	public void postMessage(String value) throws Exception {
		CloseableHttpClient closeableHttpClient = HttpClients.createDefault();

		try {
			URI WebhookURL = new URI(var.webhook);
			JSONObject js = new JSONObject();
			String json = js.put("text", value).toString();
			StringEntity entity = new StringEntity(json);

			HttpUriRequest httpUriRequest = RequestBuilder.post().setUri(WebhookURL).setEntity(entity).build();

			CloseableHttpResponse closeableHttpClientResponse = closeableHttpClient.execute(httpUriRequest);

			String getResponse = EntityUtils.toString(closeableHttpClientResponse.getEntity());

			System.out.println(getResponse);

		} catch (IOException | URISyntaxException e) {
			e.printStackTrace();
		} finally {
			try {
				closeableHttpClient.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void postMessages(String condition) throws Exception {
		CloseableHttpClient closeableHttpClient = HttpClients.createDefault();

		try {
			URI WebhookURL = new URI(var.webhook);
			StringEntity entity = new StringEntity(condition);

			HttpUriRequest httpUriRequest = RequestBuilder.post().setUri(WebhookURL).setEntity(entity).build();

			CloseableHttpResponse closeableHttpClientResponse = closeableHttpClient.execute(httpUriRequest);

			String getResponse = EntityUtils.toString(closeableHttpClientResponse.getEntity());

			System.out.println(getResponse);

		} catch (IOException | URISyntaxException e) {
			e.printStackTrace();
		} finally {
			try {
				closeableHttpClient.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	
	public String header() throws Exception {
		String json = readFileAsString(var.formatMessageFile);
		
		return json;
	}
	
	private static String readFileAsString(String file) throws IOException {
		return new String(Files.readAllBytes(Paths.get(file)));
	}
}
