package karate.common.utils;

import java.io.File;
//import java.io.FileReader;

//import javax.script.ScriptEngine;
//import javax.script.ScriptEngineManager;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.transfer.MultipleFileUpload;
import com.amazonaws.services.s3.transfer.TransferManager;
import com.amazonaws.services.s3.transfer.TransferManagerBuilder;

public class AWSClient {
	
	/* Read js file
	public String js(String script) throws Exception {
		ScriptEngineManager mgr = new ScriptEngineManager();
		ScriptEngine jsEngine = mgr.getEngineByName("JavaScript");
		jsEngine.eval(new FileReader("aws.js"));
        String result = (String) jsEngine.eval(script);
        return result;
	}
	*/
	
	Var var = new Var();
	AmazonS3 s3client;

	public AWSClient() throws Exception {
		this.initializeAmazon();
	}

	public void initializeAmazon() throws Exception {
		AWSCredentials credentials = new BasicAWSCredentials(var.accessKey, var.secretKey);
		s3client = AmazonS3ClientBuilder.standard().withCredentials(new AWSStaticCredentialsProvider(credentials))
				.withRegion(Regions.fromName(var.region)).build();
	}

	public void uploadFolderTos3bucket(String folderName, File file, boolean recursive) throws Exception {
		TransferManager x = TransferManagerBuilder.standard().withS3Client(s3client).build();
		MultipleFileUpload xfer = x.uploadDirectory(var.bucketName, folderName, file, recursive);

		try {
			xfer.waitForCompletion();
		} catch (AmazonServiceException e) {
			System.err.println("err: " + e.getMessage());
			System.exit(1);
		} catch (AmazonClientException e) {
			System.err.println("err: " + e.getMessage());
			System.exit(1);
		} catch (InterruptedException e) {
			System.err.println("err: " + e.getMessage());
			System.exit(1);
		}

		x.shutdownNow();
	}

}
