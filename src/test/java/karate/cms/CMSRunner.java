package karate.cms;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.File;
import org.junit.jupiter.api.Test;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;

import karate.common.utils.AWSClient;
import karate.common.utils.Report;
import karate.common.utils.DateTime;

public class CMSRunner {

	@Test
	public void testParallel() throws Exception {
		AWSClient awsClient = new AWSClient();
		Report report = new Report();
				
		Results results = Runner.path("classpath:karate/bcs").tags("@debug").outputCucumberJson(true).parallel(5);
		report.generateReportCMS(results.getReportDir());
		assertEquals(0, results.getFailCount(), results.getErrorMessages());

		String defaultPath = "qc/automation-report/";
		DateTime date = new DateTime();
		awsClient.uploadFolderTos3bucket(defaultPath + date.getCurrentDate() + "/test-env",
				new File("target/cucumber-html-reports"), true);
	}

}