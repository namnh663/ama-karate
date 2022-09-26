package karate.common.utils;

import java.io.File;

public class GetFileNameUtils {

	public static String input(String path) {

		File f = new File(path);
		String Name = f.getName();
		return Name;
	}
}
