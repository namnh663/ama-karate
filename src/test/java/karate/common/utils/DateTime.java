package karate.common.utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateTime {

	public String getCurrentDate() {
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMdd");
		LocalDateTime now = LocalDateTime.now();
		return dtf.format(now);
	}
	
	public String getCurrentTime() {
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HHmmss");
		LocalDateTime now = LocalDateTime.now();
		return dtf.format(now);
	}
}
