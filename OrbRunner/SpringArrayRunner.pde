/** -----------------------------------------------
 SpringArrayDriver (Most Work Goes Here)
 
 TASK:
 You will write a program that creates an array of orbs.
 When run, the simulation should show the orbs,
 connected by springs,
 moving according to the push/pull of the spring forces.
 
 Earth gravity will be a toggle-able option,
 as well as whether the simulation is running movement or not.
 
 Part 0: Create and populate the array of orbs.
 
 Part 1: Draw the "springs" connecting the orbs.
 
 Part 2: Calculate and apply the spring force to the
 orbs in the array.
 Part 3: Apply earth based gravity and drag if those
 options are turned on.
 
 Part 4: Allow for the removal and addition of orbs
 
 CONCURRENT TASK:
 As you go, or just before you submit,
 Fill in the placeholder comment zones with YOUR OWN WORDS.
 ----------------------------------------------- */


int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float MIN_CHARGE = 20;
float MAX_CHARGE = 50;
float G_CONSTANT = 1;
float D_COEF = 0.1;
float C_NUM = 9;

int SPRING_LENGTH = 50;
float  SPRING_K = 0.005;

int MOVING = 0;
int BOUNCE = 1;
int GRAVITY = 2;
int DRAGF = 3;
int ESTATIC = 4; 
boolean[] toggles = new boolean[5];
String[] modes = {"Moving", "Bounce", "Gravity", "Drag", "Electrostatic"};

FixedOrb earth;
Orb[] orbs;
int orbCount;


void setup()
{
  size(600, 600);

  //Part 0: Write makeOrbs below
  makeOrbs(true);
  //Part 3: create earth to simulate gravity
  earth = new FixedOrb(width/2, height * 200, 1, 20000, 20);
}//setup

void draw()
{
  background(255);
  displayMode();

  //draw the orbs and springs
  for (int o = 0; o < orbCount; o++) {
    orbs[o].display();

    //Part 1: write drawSpring below
    //Use drawspring correctly to draw springs
    if (o < orbCount - 1) {
      drawSpring(orbs[o], orbs[o + 1]);
    }
  }//draw orbs & springs

  if (toggles[MOVING]) {
    //Part 2: write applySprings below
    applySprings();

    //part 3: apply other forces if toggled on
    for (int o = 0; o < orbCount; o++) {
      if (toggles[GRAVITY]) {
        //PVector gf = new PVector(0, 0.3 * orbs[o].mass);// changed so that they fall down and not towards the fixed orb
        PVector gf = orbs[o].getGravity(orbs[0],G_CONSTANT);
        orbs[o].applyForce(gf);
      } 

      if (toggles[DRAGF]) {
        PVector df = orbs[o].getDragForce(D_COEF);
        orbs[o].applyForce(df);
      }
      
      if (toggles[ESTATIC]) {
        //PVector ef = new PVector ();
        //for (int p = 1; p < orbCount; p++) {
        //  PVector es0 = orbs[o].getStatic(orbs[p-1],C_NUM);
        //  PVector es1 = orbs[o].getStatic(orbs[p],C_NUM);
        //  if (p==1) {
          //  ef = es0.add(es1);
          //}
          //ef = ef.add(es1);
      PVector ef = orbs[o].getStatic(orbs[0], C_NUM);
      orbs[o].applyForce(ef);          
        
        
        //orbs[o].applyForce(ef);
      } 
    }//gravity, drag

    for (int o = 0; o < orbCount; o++) {
      orbs[o].move(toggles[BOUNCE]);
    }
  }//moving
}//draw


/**
 makeOrbs(boolean ordered)
 
 Set orbCount to NUM_ORBS
 Initialize and create orbCount Orbs in orbs.
 All orbs should have random mass and size.
 The first orb should be a FixedOrb
 If ordered is true:
 The orbs should be spaced SPRING_LENGTH distance
 apart along the middle of the screen.
 If ordered is false:
 The orbs should be positioned radomly.
 
 Each orb will be "connected" to its neighbors in the array.
 */
void makeOrbs(boolean ordered)
{
  orbCount = NUM_ORBS;
  orbs = new Orb[orbCount];

  for (int i = 0; i < orbCount; i++) {
    float s = random(MIN_SIZE, MAX_SIZE);
    float m = random(MIN_MASS, MAX_MASS);
    float e = random(MIN_CHARGE, MAX_CHARGE);

    if (ordered) {
      float x = 100 + i * SPRING_LENGTH;
      float y = height/2;

      if (i == 0) {
        orbs[i] = new FixedOrb(x, y, s, m, e);
      } else {
        orbs[i] = new Orb(x, y, s, m, e);
      }
    } else {
      if (i == 0) {
        orbs[i] = new FixedOrb();
      } else {
        orbs[i] = new Orb();
      }
    }
  }
}//makeOrbs


/**
 drawSpring(Orb o0, Orb o1)
 
 Draw a line between the two Orbs.
 Line color should change as follows:
 red: The spring is stretched.
 green: The spring is compressed.
 black: The spring is at its normal length
 */
void drawSpring(Orb o0, Orb o1)
{
  float d = dist(o0.center.x, o0.center.y, o1.center.x, o1.center.y);

  if (d > SPRING_LENGTH) {
    stroke(255, 0, 0); // stretched
  } else if (d < SPRING_LENGTH) {
    stroke(0, 255, 0); // compressed
  } else {
    stroke(0);   // normal
  }
  line(o0.center.x, o0.center.y, o1.center.x, o1.center.y);
}//drawSpring


/**
 applySprings()
 
 FIRST: Fill in getSpring in the Orb class.
 
 THEN:
 Go through the Orbs array and apply the spring
 force correctly for each orb. We will consider every
 orb as being "connected" via a spring to is
 neighboring orbs in the array.
 */
void applySprings()
{
  // go through each pair of orbs next to them
  for (int i = 0; i < orbCount - 1; i++) {
    Orb current = orbs[i];
    Orb next = orbs[i + 1];

    // get spring force from one orb to another orb
    PVector force1 = current.getSpring(next, SPRING_LENGTH, SPRING_K);
    PVector force2 = next.getSpring(current, SPRING_LENGTH, SPRING_K);

    current.applyForce(force1);
    next.applyForce(force2);
    PVector diff = PVector.sub(next.center, current.center);// direction from one orb
    float dist = diff.mag();//how far apart they are
    float displacement = dist - SPRING_LENGTH;//stretched or compressed the string is

       println("SPRING | dist:", dist, "disp:", displacement, "force:", force1);
  }
}//applySprings



/**
 addOrb()
 
 Add an orb to the arry of orbs.
 
 If the array of orbs is full, make a
 new, larger array
 that contains all
 the current orbs
 and the new one.
 (check out arrayCopy() to help)
 */
void addOrb()
{
  Orb[] newOrbs = new Orb[orbCount + 1];

  //copy the old orbs into the new array； look at ref for arrayCopy
  arrayCopy(orbs, newOrbs);

  float s = 30;
  float m = 50;
  float e = 20;
  //place of last orb; I had it at random, but it sends all the orbs flying
  //sometimes it becomes
  Orb lastOrb = orbs[orbCount - 1];
  float x = lastOrb.center.x + SPRING_LENGTH;
  float y = lastOrb.center.y;



  // adds new orb
  newOrbs[orbCount] = new Orb(x, y, s, m, e);

  // switch to the new array
  orbs = newOrbs;
  orbCount++;
}//addOrb

/**
 keyPressed()
 
 Toggle the various modes on and off
 Use 1 and 2 to setup model.
 Use - and + to add/remove orbs.
 */

void keyPressed()
{
  if (key == ' ') {
    if (toggles[MOVING] == true) {
      toggles[MOVING] = false;
    } else {
      toggles[MOVING] = true;
    }
  }

  if (key == 'g') {
    if (toggles[GRAVITY] == true) {
      toggles[GRAVITY] = false;
    } else {
      toggles[GRAVITY] = true;
    }
  }

  if (key == 'b') {
    if (toggles[BOUNCE] == true) {
      toggles[BOUNCE] = false;
    } else {
      toggles[BOUNCE] = true;
    }
  }

  if (key == 'd') {
    if (toggles[DRAGF] == true) {
      toggles[DRAGF] = false;
    } else {
      toggles[DRAGF] = true;
    }
  }
  
  if (key == 'e') {
    if (toggles[ESTATIC] == true) {
      toggles[ESTATIC] = false;
    } else {
      toggles[ESTATIC] = true;
    }
  }

  if (key == '1') {
    makeOrbs(true);
  }

  if (key == '2') {
    makeOrbs(false);
  }



  if (key == '-') {
    orbCount = orbCount - 1;
  }//removal
  if (key == '=' || key == '+') {
    //Part 4: Write addOrb() below
    addOrb();
  }//addition
}//keyPressed


void displayMode()
{
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int spacing = 85;
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
    //set box color
    if (toggles[m]) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }

    float w = textWidth(modes[m]);
    rect(x, 0, w+5, 20);
    fill(0);
    text(modes[m], x+2, 2);
    x+= w+5;
  }
}//display
