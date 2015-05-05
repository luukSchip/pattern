var nrCaptured = 0;
var modus = 1;
var xTranslationCal = 0;
var yTranslationCal = 0;
var xScaleCal = 0;
var yScaleCal = 0;

var nrOfStars = 50;
var space = 10;
var lengthOfStar = 100;
var inner = -10;
var controlValue = 10;

var w = 320;
var h = 240;
var threshold = 80;

var xCoords = [0,0];
var yCoords = [0,0];
var lastX = [0,0];
var lastY = [0,0];

var potentialRotationSpeed = [0,0,0];
var rotationSpeed = [0,0,0];
var rotation = [1,1,1];

var distThreshold = 600;

var inRange = false;
var meetingX;
var meetingY;

var printing = false;

function setup(){
  createCanvas(800,600);
}

function draw(){
  background(0);
  xCoords[0] = mouseX;
  yCoords[0] = mouseY;
  xCoords[1] = width - mouseX;
  yCoords[1] = height - mouseY;
  for(var i = 0; i < 2; i++){
    potentialRotationSpeed[i] = map(dist(xCoords[i],yCoords[i],lastX[i],lastY[i]),0,100,0,255);
    if(potentialRotationSpeed[i] > rotationSpeed[i] * 0.99){
      rotationSpeed[i] = potentialRotationSpeed[i];
    }
    lastX[i] = xCoords[i];
    lastY[i] = yCoords[i];
    if(i === 0){
      fill(255,0,0);
    }
    else{
      fill(0,255,0);
    }
    if(dist(xCoords[0],yCoords[0],xCoords[1],yCoords[1]) <= distThreshold){
      rotationSpeed[0] = rotationSpeed[0] * 0.3;
      //rotation[0] = rotation[0] + map(rotationSpeed[0],0,255,0,PI/8);
      rotation[0] = 1.94;
      var meanX = (xCoords[0] + xCoords[1]) / 2;
      var meanY = (yCoords[0] + yCoords[1]) / 2;
      drawStar2(meanX,meanY,rotation[0]);
    }
  }
}

function drawStar1( x,  y, r){ 
  var div = 8000;
  var v1 = x - xCoords[0] + 1;
  var v2 = y - yCoords[0] + 1;
  var v3 = x - xCoords[1] + 1;
  var v4 = y - yCoords[1] + 1;
  var v5 = v1 * v4 / div;
  var v6 = v2 * v3 / div;
  var v7 = v1 * v3 / div;
  var v8 = v2 * v4 / div;
  var v9 = v1 * v1 / div;
  var v10 = v2 * v2 / div;
  var v11 = v3 * v3 / div;
  var v12 = v4 * v4 / div;
 
  if(inRange === true){
    inRange = false;
  }
    strokeWeight(1);
    stroke(255,255,255);
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


function drawStar2(x, y, r){
  var div = 500;
  var v1 = x - xCoords[0];
  var v2 = y - yCoords[0];
  var v3 = x - xCoords[1];
  var v4 = y - yCoords[1];
  var v5 = v1 * v4 / div;
  var v6 = v2 * v3 / div;
  var v7 = v1 * v3 / div;
  var v8 = v2 * v4 / div;
  var v9 = v1 * v1 / div;
  var v10 = v2 * v2 / div;
  var v11 = v3 * v3 / div;
  var v12 = v4 * v4 / div;
  
  if(inRange === false){
    inRange = true;
    meetingX = x;
    meetingY = y;
  }
  translate(meetingX,meetingY);
  //rotate(r);
  for(var i = 0; i < nrOfStars; i++){
  // for(var i = 0; i < 1; i++){
    var xTranslation = sin(2*PI/nrOfStars*i)*50;
    var yTranslation = cos(2*PI/nrOfStars*i)*50;
    translate(xTranslation,yTranslation);
    rotate(v1 / width * 8*PI);
    stroke(255,255,255,65);
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
  if(printing){
    printValues();
  }
}

function keyPressed(key) {
  switch(key.which){
    case 32:
      printing = !printing;
      break;
  }
}

function printValues(){
    var values = {
      rotation: rotation[0],
      controlValue: controlValue,
      nrOfStars: nrOfStars,
      inner: inner,
      lengthOfStar: lengthOfStar,
      mouseY: mouseY,
      mouseX: mouseX
    }
    console.log(values);}

function mouseDragged() {
    threshold = map(mouseX,0,width,0,255);
}

// function stop() {
//     //opencv.stop();
//     super.stop();
// }