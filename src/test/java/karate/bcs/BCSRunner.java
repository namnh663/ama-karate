package karate.bcs;

import java.io.File;

import org.junit.jupiter.api.Test;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;

import karate.common.utils.AWSClient;
import karate.common.utils.Report;
import karate.common.utils.Var;
import karate.common.utils.DateTime;
import karate.common.utils.WebHooks;

public class BCSRunner {

	@Test
	public void testParallel() throws Exception {
		Var var = new Var();
		AWSClient awsClient = new AWSClient();
		WebHooks slack = new WebHooks();
		DateTime dt = new DateTime();
		Report report = new Report();
		String date = dt.getCurrentDate();
		String time = dt.getCurrentTime();

		Results results = Runner.path("classpath:karate/bcs").tags("~@skip").outputCucumberJson(true).parallel(0);
		report.generateReportBCS(results.getReportDir());
		
		slack.postMessages(slack.header());
		slack.postMessage(
				">*scenarios*: " + String.valueOf(results.getScenariosTotal()) + " | " 
				+ "*passed*: " + String.valueOf(results.getScenariosPassed()) + " | " 
				+ "*failed*: " + String.valueOf(results.getFailCount()));
		slack.postMessage(results.getErrorMessages());
		slack.postMessage(var.backlogBcsUrl + var.textLinkBcs);
		slack.postMessage(var.baseCdnUrl + "bcs/" + date + "/" + time + "/" + var.reportFile + var.textLink);

		awsClient.uploadFolderTos3bucket(var.s3Path + "bcs/" + date + "/" + time, new File(var.inputPath), true);
	}

}