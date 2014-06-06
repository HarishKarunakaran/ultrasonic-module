import processing.serial.*;

/* The following Processing Sketch was created by ScottC on
 the 10 Nov 2012 : http://arduinobasics.blogspot.com/
 
 Inspired by this Processing sketch by Daniel Shiffman:
 http://processing.org/learning/basics/sinewave.html
 
*/
import processing.serial.*;


int numOfShapes = 60; // Number of squares to display on screen 
int shapeSpeed = 2; // Speed at which the shapes move to new position
 // 2 = Fastest, Larger numbers are slower

//Global Variables 
Square[] mySquares = new Square[numOfShapes];
int shapeSize, distance;
String comPortString;
Serial myPort;

/* -----------------------Setup ---------------------------*/
void setup(){
 size(displayWidth,displayHeight); //Use entire screen size.
 smooth(); // draws all shapes with smooth edges.
 
 /* Calculate the size of the squares and initialise the Squares array */
 shapeSize = (width/numOfShapes); 
 for(int i = 0; i<numOfShapes; i++){
 mySquares[i]=new Square(int(shapeSize*i),height-40);
 }
 
 /*Open the serial port for communication with the Arduino
 Make sure the COM port is correct - I am using COM port 8 */
 myPort = new Serial(this, "COM21", 9600);
 myPort.bufferUntil('\n'); // Trigger a SerialEvent on new line
}

/* ------------------------Draw -----------------------------*/
void draw(){
 background(0); //Make the background BLACK
 delay(50); //Delay used to refresh screen
 drawSquares(); //Draw the pattern of squares
}


/* ---------------------serialEvent ---------------------------*/
void serialEvent(Serial cPort){
 comPortString = cPort.readStringUntil('\n');
 if(comPortString != null) {
 comPortString=trim(comPortString);
 
 /* Use the distance received by the Arduino to modify the y position
 of the first square (others will follow). Should match the
 code settings on the Arduino. In this case 200 is the maximum
 distance expected. The distance is then mapped to a value
 between 1 and the height of your screen */
 distance = int(map(Integer.parseInt(comPortString),1,25,1,height));
 if(distance<0){
 /*If computer receives a negative number (-1), then the
 sensor is reporting an "out of range" error. Convert all
 of these to a distance of 0. */
 distance = 0;
 }
 }
}


/* ---------------------drawSquares ---------------------------*/
void drawSquares(){
 int oldY, newY, targetY, redVal, blueVal;
 
 /* Set the Y position of the 1st square based on 
 sensor value received */
 mySquares[0].setY((height-shapeSize)-distance);
 
 /* Update the position and colour of each of the squares */
 for(int i = numOfShapes-1; i>0; i--){
 /* Use the previous square's position as a target */
 targetY=mySquares[i-1].getY();
 oldY=mySquares[i].getY();
 
 if(abs(oldY-targetY)<2){
 newY=targetY; //This helps to line them up
 }else{
 //calculate the new position of the square
 newY=oldY-((oldY-targetY)/shapeSpeed);
 }
 //Set the new position of the square
 mySquares[i].setY(newY);
 
 /*Calculate the colour of the square based on its
 position on the screen */
 blueVal = int(map(newY,0,height,0,255));
 redVal = 255-blueVal;
 fill(redVal,0,blueVal);
 
 /* Draw the square on the screen */
 rect(mySquares[i].getX(), mySquares[i].getY(),shapeSize,shapeSize);
 }
}

/* ---------------------sketchFullScreen---------------------------*/
// This puts processing into Full Screen Mode
boolean sketchFullScreen() {
 return true;
}

/* ---------------------CLASS: Square ---------------------------*/
class Square{
 int xPosition, yPosition;
 
 Square(int xPos, int yPos){
 xPosition = xPos;
 yPosition = yPos;
 }
 
 int getX(){
 return xPosition;
 }
 
 int getY(){
 return yPosition;
 }
 
 void setY(int yPos){
 yPosition = yPos;
 }
}

