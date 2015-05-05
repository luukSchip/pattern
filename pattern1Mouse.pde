 //import controlP5.*;
//import hypermedia.video.*;
import java.awt.*;

int nrCaptured = 0;


int modus = 1;
float xTranslationCal = 0;
float yTranslationCal = 0;
float xScaleCal = 0;
float yScaleCal = 0;

int nrOfStars = 10;
int space = 10;
int lengthOfStar = 100;
int inner = -10;
int controlValue = 10;

int w = 320;
int h = 240;
int threshold = 80;

//ControlP5 controlP5;
//OpenCV opencv;

float[] xCoords = {0,0};
float[] yCoords = {0,0};
float[] lastX = {0,0};
float[] lastY = {0,0};

float[] potentialRotationSpeed = {0,0,0};
float[] rotationSpeed = {0,0,0};
float[] rotation = {1,1,1};

float distThreshold = 300;

boolean inRange = false;
float meetingX;
float meetingY;


void setup(){
  size(1024,768);
  /*
  controlP5 = new ControlP5(this);
  controlP5.addSlider("inner",-100,100,0,0,100,20);
  controlP5.addSlider("rotation",0,10,0,25,100,20);
  controlP5.addSlider("lengthOfStar",-500,500,0,50,100,20);
  controlP5.addSlider("nrOfStars",1,100,0,75,100,20);
  */
  //opencv = new OpenCV( this );
  //opencv.capture(w,h);
}

void draw(){
  background(0);
  xCoords[0] = mouseX;
  yCoords[0] = mouseY;
  xCoords[1] = width - mouseX;
  yCoords[1] = height - mouseY;
  for(int i = 0; i < 2; i++){
    potentialRotationSpeed[i] = map(dist(xCoords[i],yCoords[i],lastX[i],lastY[i]),0,100,0,255);
    if(potentialRotationSpeed[i] > rotationSpeed[i] * 0.99){
      rotationSpeed[i] = potentialRotationSpeed[i];
    }
    lastX[i] = xCoords[i];
    lastY[i] = yCoords[i];
    if(i == 0){
      fill(255,0,0);
    }
    else{
      fill(0,255,0);
    }
    ellipse(xCoords[i],yCoords[i],10,10);
    if((xCoords[1] == 0 && yCoords[1] == 0) || dist(xCoords[0],yCoords[0],xCoords[1],yCoords[1]) > distThreshold){
      rotationSpeed[i] = (int)rotationSpeed[i] * 0.5;
      rotation[i] = rotation[i] + map(rotationSpeed[i],0,255,0,PI/8);
      drawStar1(xCoords[i],yCoords[i],rotation[i]);
      controlValue = (int)map(xCoords[0],meetingX-distThreshold/2,meetingX+distThreshold/2,0,100);
    }
    if(dist(xCoords[0],yCoords[0],xCoords[1],yCoords[1]) <= distThreshold){
      rotationSpeed[0] = (int)rotationSpeed[0] * 0.3;
      rotation[0] = rotation[0] + map(rotationSpeed[0],0,255,0,PI/8);
      float meanX = (xCoords[0] + xCoords[1]) / 2;
      float meanY = (yCoords[0] + yCoords[1]) / 2;
      controlValue = (int)map(xCoords[0],meetingX-distThreshold/2,meetingX+distThreshold/2,0,100);
      nrOfStars = constrain((int)map(yCoords[0],meetingY-distThreshold/2,meetingY+distThreshold/2,0,100),2,100);
      inner = (int)map(xCoords[1],meetingX-distThreshold/2,meetingX+distThreshold/2,-100,100);
      lengthOfStar = (int)map(yCoords[1],meetingY-distThreshold/2,meetingY+distThreshold/2,-300,300);
      drawStar2(meanX,meanY,rotation[0]);
    }
  }
}

void drawStar1(float x, float y,float r){ 
  int div = 8000;
  float v1 = x - xCoords[0] + 1;
  float v2 = y - yCoords[0] + 1;
  float v3 = x - xCoords[1] + 1;
  float v4 = y - yCoords[1] + 1;
  float v5 = v1 * v4 / div;
  float v6 = v2 * v3 / div;
  float v7 = v1 * v3 / div;
  float v8 = v2 * v4 / div;
  float v9 = v1 * v1 / div;
  float v10 = v2 * v2 / div;
  float v11 = v3 * v3 / div;
  float v12 = v4 * v4 / div;
 
  if(inRange == true){
    inRange = false;
  }
    strokeWeight(1);
    stroke(255,255,255,65);
    translate(x,y);
    rotate(r);
    noFill();
    beginShape();
    vertex(0, 0); // first point
    bezierVertex(v1, v2, v3-v5,v4-v6, v3, v4);
    bezierVertex(v3+v5,v3+v6, v7-v9,v8-v10, v7, v8);
    bezierVertex(v7+v9,v8+v10, -v3-v11,-v3-v12, -v3, -v4);
    bezierVertex(-v3+v11, v3+v12, -v1,-v2, 0, 0);
    endShape();
    rotate(-r);
    translate(-x,-y);  
}


void drawStar2(float x, float y,float r){
  int div = 40;
  float v1 = x - xCoords[0];
  float v2 = y - yCoords[0];
  float v3 = x - xCoords[1];
  float v4 = y - yCoords[1];
  float v5 = v1 * v4 / div;
  float v6 = v2 * v3 / div;
  float v7 = v1 * v3 / div;
  float v8 = v2 * v4 / div;
  float v9 = v1 * v1 / div;
  float v10 = v2 * v2 / div;
  float v11 = v3 * v3 / div;
  float v12 = v4 * v4 / div;
  
  if(inRange == false){
    inRange = true;
    meetingX = x;
    meetingY = y;
  }
  translate(meetingX,meetingY);
  rotate(r);
  for(int i = 0; i < nrOfStars; i++){
    float xTranslation = sin(2*PI/nrOfStars*i)*100;
    float yTranslation = cos(2*PI/nrOfStars*i)*100;
    translate(xTranslation,yTranslation);
    //rotate(r);
    noFill();
    beginShape();
    vertex(0, 0); // first point
    bezierVertex(v1, v2, v3-v5,v4-v6, v3, v4);
    bezierVertex(v3+v5,v3+v6, v7-v9,v8-v10, v7, v8);
    bezierVertex(v7+v9,v8+v10, -v3-v11,-v3-v12, -v3, -v4);
    bezierVertex(-v3+v11, v3+v12, -v1,-v2, 0, 0);
    endShape();
    translate(-xTranslation,-yTranslation);
    rotate(-r);
  }
  //rotate(-r);
  translate(-meetingX,-meetingY);
}

void keyPressed() {
    //if ( key==' ' ){ opencv.remember();}
    if (key=='c'){
      save(nrCaptured + ".tif");
      nrCaptured++;
      println("WTF");
  }
  if(key == '1'){
    modus = 1;
  }
  if(key == '2'){
    modus = 2;
  }
  if(key == '3'){
    modus = 3;
  }
  if(key == '4'){
    modus = 4;
  }
  if(key == '5'){
    modus = 5;
  }
  if(key == '6'){
    modus = 6;
  }
  
  if(key == 'd'){
    if(modus == 1){
      xTranslationCal+=1;
      println("hoiii");
    }
    if(modus == 2){
      xScaleCal+=1;
      println("hoiisss");
    }
    if(modus == 3){
      xTranslationCal+=10;
      println("hoiii");
    }
    if(modus == 4){
      xScaleCal+=10;
      println("hoiisss");
    }
  }
  if(key == 'a'){
    if(modus == 1){
      xTranslationCal--;
    }
    if(modus == 2){
      xScaleCal--;
    }
    if(modus == 3){
      xTranslationCal-=10;
      println("hoiii");
    }
    if(modus == 4){
      xScaleCal-=10;
      println("hoiisss");
    }
  }
  if(key == 'w'){
    if(modus == 1){
      yTranslationCal--;
    }
    if(modus == 2){
      yScaleCal--;
    }
    if(modus == 3){
      yTranslationCal-=10;
      println("hoiii");
    }
    if(modus == 4){
      yScaleCal-=10;
      println("hoiisss");
    }
  }
  if(key == 's'){
    if(modus == 1){
      yTranslationCal++;
    }
    if(modus == 2){
      yScaleCal++;
    }
    if(modus == 3){
      yTranslationCal+=10;
      println("hoiii");
    }
    if(modus == 4){
      yScaleCal+=10;
      println("hoiisss");
    }
  }
}

void mouseDragged() {
    threshold = int( map(mouseX,0,width,0,255) );
}

public void stop() {
    //opencv.stop();
    super.stop();
}
