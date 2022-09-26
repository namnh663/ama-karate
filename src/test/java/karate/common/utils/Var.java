package karate.common.utils;

public class Var {
	
	public String s3Path = "qc/automation-report/";
	public String baseCdnUrl = "<https://mycdnurl.com/";
	public String bucketName = "inputbucketname";
	public String accessKey = "inputkey";
	public String secretKey = "inputkey";
	public String region = "us-east-1";
	public String webhook = "https://mywebhookurl.com";
	public String oauthUrl = "https://myurl.com/oauth/token";
	public String qcInitTokenUrl = "https://qc.bcs.amanotes.net/v4/init";
	public String stagInitTokenUrl = "https://staging.bcs.amanotes.net/v4/init";
	public String backlogBcsUrl = "<https://myurl.com/backlog";
	public String formatMessageFile = "src/test/java/karate/common/files/header-slack.json";
	public String requestCmsTokenFile = "src/test/java/karate/common/files/request-cms-token.json";
	public String requestBcsQcTokenFile = "src/test/java/karate/common/files/request-bcs-qc-token.json";
	public String requestBcsStagTokenFile = "src/test/java/karate/common/files/request-bcs-stag-token.json";
	public String inputPath = "target/cucumber-html-reports";
	public String reportFile = "overview-features.html";
	public String textLinkBcs = "|Click here to go to BCS backlog & create bug if any>";
	public String textLink = "|View Report>";
	
	public static String songIdInvalid = "Song id input is invalid, Please check your input.";
	public static String artistIdInvalid = "Artists id  is invalid, Please check your input.";
	public static String listIdFormatInvalid = "IdList input format is invalid, Please check your input.";
	public static String tokenInvalid = "Token is invalid , Please check your input.";
	
	public static String getArtistIdInvalid() {
		return artistIdInvalid;
	}
	
	public static String getTokenInvalid() {
		return tokenInvalid;
	}

	public static String getListIdFormatInvalid() {
		return listIdFormatInvalid;
	}

	public static String getSongIdInvalid() {
		return songIdInvalid;
	}
}
