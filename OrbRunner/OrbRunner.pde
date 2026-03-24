class Orb
{

  //instance variables
  PVector center;
  PVector velocity;
  PVector acceleration;
  float bsize;
  float mass;
  color c;


  /**
makes an orb with random size, position, and mass
   */
  Orb()
  {
    bsize = random(10, MAX_SIZE);
    float x = random(bsize/2, width-bsize/2);
    float y = random(bsize/2, height-bsize/2);
    center = new PVector(x, y);
    mass = random(10, 100);
    velocity = new PVector();
    acceleration = new PVector();
    setColor();
  }


  /**
makes an orb with a given position, size, and mass   
and/or
   WHY IT EXISTS
   */
  Orb(float x, float y, float s, float m)
  {
    bsize = s;
    mass = m;
    center = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
    setColor();
  }


  /**
 updates the orb's motion using acc and velo.
   also checks wall bouncing if bounce is turned on.
   */
  void move(boolean bounce)
  {
    if (bounce) {
      xBounce();
      yBounce();
    }

    velocity.add(acceleration);
    center.add(velocity);
    acceleration.mult(0);
  }//move


  /**
 adds a force to this orb by converting force into acceleration
heavier = less force
   */
  void applyForce(PVector force)
  {
    PVector scaleForce = force.copy();
    scaleForce.div(mass);
    acceleration.add(scaleForce);
  }


  /**
calculates the drag force that pushes opposite the direction of motion

   */
  PVector getDragForce(float cd)
  {
    float dragMag = velocity.mag();
    dragMag = -0.5 * dragMag * dragMag * cd;
    PVector dragForce = velocity.copy();
    dragForce.normalize();
    dragForce.mult(dragMag);
    return dragForce;
  }


  /**
   calculates the gravitational force from another orb
    exists so one orb can pull another based on mass and distance
   */
  PVector getGravity(Orb other, float G)
  {
    float strength = G * mass*other.mass;
    //dont want to divide by 0!
    float r = max(center.dist(other.center), MIN_SIZE);
    strength = strength/ pow(r, 2);
    PVector force = other.center.copy();
    force.sub(center);
    force.mult(strength);
    return force;
  }

  /**
   getSpring()
   
   This should calculate the force felt on the calling object by
   a spring between the calling object and other.
   
   The resulting force should pull the calling object towards
   other if the spring is extended past springLength and should
   push the calling object away from o if the spring is compressed
   to be less than springLength.
   
   F = kx (ABhat)
   k: Spring constant
   x: displacement, the difference of the distance
   between A and B and the length of the spring.
   (ABhat): The normalized vector from A to B
   */
  /**
   calculates the spring force between this orb and another orb.
    pulls when stretched and pushes when compressed.
   */
PVector getSpring(Orb other, int springLength, float springK)
{
  PVector direction = PVector.sub(other.center, this.center);
  float distance = direction.mag();

  if (distance == 0) {
    return new PVector();
  }

  direction.normalize();//addded this, so when the spring force gets way too large when the orbs are far apart. That can make the whole chain collapse or act weird

  float displacement = distance - springLength;
  float mag = springK * displacement;

  direction.mult(mag);
  return direction;
}g



  /**
  checks for bounce against the top and bottom walls
if it happens reverse y velocity
   */
  boolean yBounce()
  {
    if (center.y > height - bsize/2) {
      velocity.y *= -1;
      center.y = height - bsize/2;

      return true;
    }//bottom bounce
    else if (center.y < bsize/2) {
      velocity.y*= -1;
      center.y = bsize/2;
      return true;
    }
    return false;
  }//yBounce


  /**
   checks for bounce against the left and right walls
if it happens reverse x velocity
   */
  boolean xBounce()
  {
    if (center.x > width - bsize/2) {
      center.x = width - bsize/2;
      velocity.x *= -1;
      return true;
    } else if (center.x < bsize/2) {
      center.x = bsize/2;
      velocity.x *= -1;
      return true;
    }
    return false;
  }//xbounce


  /**
  checks if an orb is touching another orb
   */
  boolean collisionCheck(Orb other)
  {
    return ( this.center.dist(other.center)
      <= (this.bsize/2 + other.bsize/2) );
  }//collisionCheck


  /**
   sets the orb's color based on its mass
heavier orb is closer to black

   */
  void setColor()
  {
    color c0 = color(0, 255, 255);
    color c1 = color(0);
    /*
  lerpColor blends between two colors.
    a value near 0 gives a color close to c0,
    and a value near 1 gives a color close to c1.

    */
    c = lerpColor(c0, c1, (mass-MIN_SIZE)/(MAX_MASS-MIN_SIZE));
  }//setColor


  //visual behavior
  void display()
  {
    noStroke();
    fill(c);
    circle(center.x, center.y, bsize);
    fill(0);
    //text(mass, center.x, center.y);
  }//display
}//Ball
