import java.io.*;
import java.nio.file.Path;
import java.nio.file.Paths;

//2016.2.25 by_kobayashi
//keyword を漢字／よみがなで2行に変換
//このあと、keywordsに登録
public class ReadText0 {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		 FileReader fr = null;
		 BufferedReader br = null;
		 FileWriter fw = null;
		 BufferedWriter bw = null;
		    try {
		        fr = new FileReader("./q.txt");
		        br = new BufferedReader(fr);
		        fw = new FileWriter("./q2.txt");
		        bw = new BufferedWriter(fw);
		 
		        String line;
		        int testCount=0;
		        while ((line = br.readLine()) != null){// && testCount++<10) {
		            System.out.println(line);
		            String[] cells = line.split("\t", 0);
		            bw.write(String.format("%s\t%s\t%s\n",cells[0],cells[1],cells[2]));
		            bw.write(String.format("%s\t%s\t%s\n",cells[0],cells[1],cells[3]));
		            
		        }
		    } catch (FileNotFoundException e) {
		        e.printStackTrace();
		    } catch (IOException e) {
		        e.printStackTrace();
		    } finally {
		        try {
		            br.close();
		            fr.close();
		            bw.close();
		            fw.close();
		        } catch (IOException e) {
		            e.printStackTrace();
		        }
		    }
	}

}

