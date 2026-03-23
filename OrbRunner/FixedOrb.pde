class FixedOrb extends Orb
{

  /**
   makes a fixed orb at a given position, size, and mass.
    exists so one orb can stay in place while the others move.
   */
  FixedOrb(float x, float y, float s, float m)
  {
    super(x, y, s, m);
    c = color(255, 0, 0);
  }

  /**
   make a fixed orb with random values from the Orb constructor
   */
  FixedOrb()
  {
    super();
    c = color(255, 0, 0);
  }

  /**
   overrides move so this orb does not move.
  make a stationary anchor point.
   */
  void move(boolean bounce)
  {
    //do nothing
  }
}//fixedOrb
