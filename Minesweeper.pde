import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>() ; //ArrayList of just the minesweeper buttons that are mined
public final static int NUM_BOMBS = 400;

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to declare and initialize buttons goes here

  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i =0; i<NUM_ROWS; i++) {
    for (int j=0; j<NUM_COLS; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }
  setBombs();
}
public void setBombs()
{
  while (bombs.size()<NUM_BOMBS) {
    int row = (int)(Math.random()*20); 
    int col = (int)(Math.random()*20); 
    if (!bombs.contains(buttons[row][col])) {
      bombs.add(buttons[row][col]);
    }
    System.out.println(row + "," + col);
  }
}

public void draw()
{
  background( 0 );
  if (isWon())
    displayWinningMessage();
}
public boolean isWon()
{
   for (int i = 0; i<NUM_ROWS; i++){
      for (int j = 0; j<NUM_COLS; j++){
        if (!bombs.contains(buttons[i][j]) &&! buttons[i][j].isClicked()){
          //System.out.println("Not clicked " + i + " " + j);
          return false;
      }}
    }
    return true;
}
public void displayLosingMessage()
{
  for(int i = 0; i< bombs.size(); i++){
    if(bombs.get(i).isClicked()){
      buttons[10][10].setLabel("You Loser!!");
    }
  }
}
public void displayWinningMessage()
{
  if(isWon() == true){
    buttons[10][10].setLabel("w");
     }
    }
public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }
  // called by manager

  public void mousePressed () 
  {
    clicked = true;
    if (mouseButton == RIGHT && marked){
          marked=false;
          clicked = false;
        }
        else if (mouseButton == RIGHT && !marked){
          marked = true;
          clicked = false;
        }
        draw();
        if(bombs.contains(this) && clicked) displayLosingMessage();
        if (!clicked)return;
        //System.out.println("Bombs " + countBombs(r, c));
        if (countBombs(r, c) > 0){
          setLabel(str(countBombs(r, c)));
        }
        else
        for (int i = -1; i<=1; i++){
          for (int j = -1; j<=1; j++){
            if (isValid(r + i, c + j) && (i!= 0 || j!=0) && !(buttons[r+i][c+j].isClicked())){
              buttons[r+i][c+j].mousePressed();
            }
          }
        }
  }


  public void draw() 
  {    
    if (marked){
      color c = color(175, 100, 220);  // Define color 'c'
      fill(c);  // Use color variable 'c' as fill color
    }
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked){
      color c = color(0, 400, 255, 500);
      fill(c);
    }
    else 
    fill( 255);

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    if (r<NUM_ROWS && r>=0 && c<NUM_COLS && c>=0) {
      return true;
    }
    return false;
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    for (int i = -1; i<=1; i++) {
      for (int j = -1; j<=1; j++) {
        if (isValid(row+i, col+j) && (i!=0 || j!=0)) {
          if (bombs.contains(buttons[row+i][col+j])) {
            numBombs++;
          }
        }
      }
    }
    return numBombs;
  }
}