class Details implements Comparable<Details>
{
  String name;
  Integer score;
  
  Details(String name, int score)
  {
    this.name = name;
    this.score = score;
  }
  
  int compareTo(Details that) 
  {
    return this.score.compareTo(that.score);
  }
}
 