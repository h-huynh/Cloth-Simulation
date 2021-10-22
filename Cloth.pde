import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

//Create Window
String windowTitle = "Cloth Simulation by Henry Huynh";
PeasyCam cam;
Sphere s;

PImage img;
PImage texture;

void setup() {
  size(1280, 720, P3D);
  surface.setTitle(windowTitle);
  cam=new PeasyCam(this,1280);
  texture = loadImage("texture.jpg");
  img = loadImage("painting.jpg");
  s = new Sphere(new PVector(600,800,400),300, texture);
  initScene();
}

//Simulation Parameters
PVector gravity = new PVector(0,400,0);
float radius = 3;
float mass = 1.0;
float k = 70;
float kv = 60;

//Node information
PVector initialNode = new PVector(300,200,200);
int restLen = 100;
int initLen = 90;
int nodeLength = 10; 
int nodeWidth = 10;
PVector pos[][] = new PVector[nodeLength][nodeWidth];
PVector vel[][] = new PVector[nodeLength][nodeWidth];
PVector acc[][] = new PVector[nodeLength][nodeWidth];

void initScene(){
  float x = 200;
  for (int i = 0; i < nodeLength; i++){
    float z = 50;
    for (int j = 0; j < nodeWidth; j++){
      pos[i][j] = new PVector(x,50,z);
      vel[i][j] = new PVector(0,0,0);
      z = z + initLen;
    }
    x = x + initLen;
  }
}

//Updates the simulation by timestep dt
void update(float dt) {
  //Acceleration resets every timestep
  for (int i = 0; i < nodeLength; i++){
    for (int j = 0; j < nodeWidth; j++){
      acc[i][j] = new PVector(0,0,0);
      acc[i][j].add(gravity);
    }
  }
  
  
  //Hooke's law computations for full cloth with horizontal/vertical springs
  
  PVector newVel[][] = vel; //new velocity buffer
  
  //Horizontal springs
  for (int i = 0; i < nodeLength-1; i++){
    for (int j = 0; j < nodeWidth; j++){
      PVector diff = PVector.sub(pos[i+1][j],pos[i][j]);
      
      //Force to be applied based on difference to rest length & spring constant
      float springForce = -k * (diff.mag() - restLen);
      
      //Diff is now the normalized direction
      diff.normalize();
      
      //Calculations for dampening force
      float bot = PVector.dot(vel[i][j],diff);
      float top = PVector.dot(vel[i+1][j],diff);
      float dampForce = -kv * (top - bot);
      
      //Force vector
      PVector force = PVector.mult(diff, (springForce + dampForce));
      
      //Calculating the accelerations
      acc[i][j].add(PVector.mult(force, (-1.0/mass)));
      acc[i+1][j].add(PVector.mult(force, (1.0/mass)));
    }
  }
  
  //Vertical springs
  for (int i = 0; i < nodeLength; i++){
    for (int j = 0; j < nodeWidth-1; j++){
      PVector diff = PVector.sub(pos[i][j+1],pos[i][j]);
      
      //Force to be applied based on difference to rest length & spring constant
      float springForce = -k * (diff.mag() - restLen);
      
      //Diff is now the normalized direction
      diff.normalize();
      
      //Calculations for dampening force
      float bot = PVector.dot(vel[i][j],diff);
      float top = PVector.dot(vel[i][j+1],diff);
      float dampForce = -kv * (top - bot);
      
      //Force vector
      PVector force = PVector.mult(diff, (springForce + dampForce));
      
      //Calculating the accelerations
      acc[i][j].add(PVector.mult(force, (-1.0/mass)));
      acc[i][j+1].add(PVector.mult(force, (1.0/mass)));
    }
  }
  
  // Updating new velocities with net acceleration
  for (int i = 0; i < nodeLength; i++){
    for (int j = 0; j < nodeWidth-1; j++){
      newVel[i][j].add(PVector.mult(acc[i][j],dt));
      if (j == nodeWidth){
      newVel[i][j] = new PVector(0,0,0);
      }
    } 
  }
  
  //Updating the positions with the buffered velocities
  vel = newVel;
  for (int i = 0; i < nodeLength; i++){
    for (int j = 0; j < nodeWidth-1; j++){
        pos[i][j].add(PVector.mult(vel[i][j],dt));
      }
   } 
  
  //Sphere collision
  for (int i = 0; i < nodeLength; i++){
    for (int j = 0; j < nodeWidth-1; j++){
      if (s.hasCollided(pos[i][j])){
        
        //Obtain sphere normal
        PVector n = PVector.sub(s.center, pos[i][j]);
        n.mult(-1);
        n.normalize();
        
        PVector bounce = PVector.mult(n,s.radius);
        
        //Adjustable parameter for how bouncy the cloth is when it collides, reduce if it is too unrealistic
        bounce.mult(0.005);
        pos[i][j].add(bounce);
        
        //Velocity normal
        n.mult(PVector.dot(vel[i][j],n));
        
        //Adjust so that the cloth and sphere do not clip
        n.mult(1.5);
        vel[i][j].sub(n);
      }
    }
  }
  
}


// Generating the scene
boolean paused = true;
void draw(){
  background(0);
  
  //If simulation is not in paused state, update based on frameRate
  if (!paused) {
    for (int i = 0; i < 20; i++) {
      update(1/(15*frameRate));
    }   
  }
  
  //Draw sphere
  s.Draw();
  
  //Simulation lights
  
  //Interesting effect where the sphere can not be seen but it illuminates the cloth
  //pointLight(255,255,255,s.center.x,s.center.y,s.center.z);
  
  //Generic lighting
  //lights();
  
  /**
  //Draw cloth with vertex and lines
  for (int i = 0; i < nodeLength; i++){
    for (int j = 0; j < nodeWidth; j++){
      pushMatrix();
    
      if (i < nodeLength-1) {
      line(pos[i][j].x,pos[i][j].y,pos[i][j].z,pos[i+1][j].x,pos[i+1][j].y,pos[i+1][j].z);
      }
      if (j < nodeWidth-1) {
        line(pos[i][j].x,pos[i][j].y,pos[i][j].z,pos[i][j+1].x,pos[i][j+1].y,pos[i][j+1].z);
      }
      translate(pos[i][j].x,pos[i][j].y,pos[i][j].z);
      //sphere(radius);
      popMatrix();
    }
  }
  **/
  

  
  noFill();
  noStroke();
  textureMode(NORMAL); 
  for (int j = 0; j < nodeWidth-1; j++){
    beginShape(TRIANGLE_STRIP);
    texture(img);
    for (int i = 0; i < nodeLength; i++){
     float x1 = pos[i][j].x;
     float y1 = pos[i][j].y;
     float z1 = pos[i][j].z;
     float u = map(i,0,nodeLength-1,0,1);
     float v = map(j,0,nodeWidth-1,0,1);
     vertex(x1,y1,z1,u,v);
     float x2 = pos[i][j+1].x;
     float y2 = pos[i][j+1].y;
     float z2 = pos[i][j+1].z;
     float v2 = map(j+1,0,nodeWidth-1,0,1);
     vertex(x2,y2,z2,u,v2);
    }
    endShape();
  }
  
  //While simulation is in paused state
  if (paused){
    surface.setTitle(windowTitle + " [PAUSED]");
  }
  else{
    surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
  }
}

void keyPressed(){
  if (key == ' ')
    paused = !paused;
  if (key == 'r')
    initScene();
}


 
