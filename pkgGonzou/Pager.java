package pkgHonzou;
//2015.11.18 @ kobayashi
public class Pager{
	private int current;
	private int vol;
	private int size;
	public Pager(){
		current=1;
		vol=1;
		size=0;
	}
	public int getCurrent(){
		return this.current;
	}
	public String getFixed1(){
		return String.format("%03d",this.current);
	}
	public String getFixed2(){
		return String.format("%03d",this.current+1);
	}
	public void setCurrent(int c) throws Exception{
	//表紙から数えて、右側が奇数ページ、左側が偶数ページである。
	//総ページ数は偶数
		if(c >=1 && c <this.size && c % 2 == 1){
			this.current=c;
		}else if(c>=2 && c<=this.size && c%2 == 0){
			this.current=c-1;
		} 
		else{
			throw new Exception("invalid page set");
		}
	}
	public int getSize(){
		return this.size;
	}
	public int getVol(){
		return this.vol;
	}
	public void setSize(int s){
		this.size=s;
	}
	public void setVol(int v){
		this.vol=v;
	}
	public int getNext(){
		if(this.current<this.size-1){
			this.current +=2;
		}
		return this.current;
	}
	public int getPrev(){
		if(this.current>1){
			this.current -=2;
		}
		return this.current;
	}
	public int getTop(){
		this.current=1;
		return this.current;
	}
	public int getLast(){
		this.current=this.size-1;
		return this.current;
	}
	public boolean getHasNext(){
		return this.current < (this.size -1);
	}
	public boolean getHasPrev(){
		return this.current > 1;
	}
}
	
	
