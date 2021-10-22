class Sphere {
  PVector center;
  float radius;
  PShape globe;
  
  public Sphere(PVector center,float radius, PImage img){
      this.center=center;
      this.radius=radius;
      noStroke();
      noFill();  
      this.globe = createShape(SPHERE, radius);
      globe.setTexture(img);
  }
  
  public void Draw(){
    pushMatrix();
    translate(center.x,center.y,center.z);
    shape(globe);
    popMatrix();
  }
  
  public boolean hasCollided(PVector nodePos){
    float d=dist(center.x, center.y, center.z, nodePos.x, nodePos.y, nodePos.z);
    if(d<=radius+20){
      return true;
    }
    return false;
  }
}
