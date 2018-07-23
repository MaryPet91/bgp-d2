package benchmark;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import kmer.D2Coupled;

public class SequentialBenchmark {

	public static void main(String[] args) throws IOException {
		
		if( args.length != 3 ) {
			System.out.println("You must specify <INPUT_DIR> <TOP_LINES_OCCURANCES> <FLAG_ONLY_TIME>");
			System.out.println("   FLAG_ONLY_TIME: must be [yes,no] -- if yes, print also the result of d2 score on stdout");
			System.exit(-1);
		}
		
		String INPUT_DIR = args[0]; //"/Users/you/folder/"
		int TOP_LINES_OCCURANCES = Integer.valueOf(args[1]);
		String FLAG_ONLY_TIME = args[2];
		
		File folder = new File(INPUT_DIR);
		File[] listOfFiles = folder.listFiles();
		List<String> listOfFileString = new ArrayList<>();
		
		int i = 0;
		for( File f: listOfFiles ) {
			if( f.isFile() ) {
				listOfFileString.add(f.getAbsolutePath());
				i++;	
			}
		}
		
		long startTime, endTime, msTime;
		startTime = System.currentTimeMillis();
		
		D2Coupled d2c = new D2Coupled(TOP_LINES_OCCURANCES);
		
		List<String> results = d2c.score(listOfFileString.toArray(new String[listOfFileString.size()]));
		
		endTime = System.currentTimeMillis();
		msTime = endTime - startTime;
		
		System.out.println("TIME : " + msTime + "ms");
		
		if( FLAG_ONLY_TIME.equals("no") ) {
			System.out.println("Results:");
			for( String e: results ) {
				System.out.println(e);
			}
		}
	}
	
}