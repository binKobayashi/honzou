package pkgHonzou;
//2015.11.18 @ kobayashi
public class Search{
	private String word;
	public Search(){
		this.word=null;
	}
	public String getWord(){
		return this.word;
	}
	public void setWord(String w) throws Exception{
		if(w.length()>1){
		String temp=w.trim().replaceAll("'","");
		temp=temp.replaceAll("%","");
		temp=temp.replaceAll("_","");
		temp=temp.toUpperCase().replaceAll("SELECT","");
		temp=temp.toUpperCase().replaceAll("UPDATE","");
		temp=temp.toUpperCase().replaceAll("DELETE","");

		this.word="'%"+temp+"%'";
		}else{
			this.word="'2文字以上を指定してください'";
		}
	}
}
	
	
