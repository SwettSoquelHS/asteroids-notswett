/*
  Spaceship class
 Should extend Mover class and implement show.
 You may add additional methods to this class, for example "rotate" and "accelerate" 
 might be useful.
 */
public class Spaceship extends Mover {   

  ArrayList shieldVerticies;
  static final int NUM_SHIELD_VERTICIES = 6;
  static final float SHIELD_RADIUS = 30.0;
  static final float bulletCapacity = 38.0;

  protected float flubAngle;

  ArrayList bullets;


  Spaceship(float x, float y) {
    super(x, y);
    shieldVerticies = new ArrayList();

    for (int i = 0; i < NUM_SHIELD_VERTICIES; i++) {
      float angle = radians(360.0/NUM_SHIELD_VERTICIES*i);
      shieldVerticies.add(
        new PVector(      
        (float)Math.cos(angle)*SHIELD_RADIUS, (float)Math.sin(angle)*SHIELD_RADIUS
        ));
    }
    bullets = new ArrayList(25);
    flubAngle = 0.0;
  }

  Spaceship(float x, float y, float speed, float direction) {
    this(x, y);
    this.speed = speed;
    this.direction = direction;
  }

  void show() {
    pushMatrix();
    translate(x, y);    
    fill(myColor);
    rotate(radians(direction));
    drawShip();  
    drawShield();
    popMatrix();
  }

  void update() {
    super.update();

    //must work backwards...
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = (Bullet)bullets.get(i);
      if (b != null) {
        b.update();

        //if bullet is offscreen then it should be deleted
        if ( !b.alive() ) { 
          bullets.remove(i);
        } else {
          b.show();
        }
      }
    }
  }

  void drawShip() {
    triangle(-10, -10, -10, 10, 20, 0);
  }

  void drawShield() {

    fill(#05F562, 20);
    stroke(#05F562);    
    float shieldStrength = 6.0 - bullets.size()/.9;

    if (shieldStrength > 0.1) {
      strokeWeight(Math.max(shieldStrength, 0.1));

      float flubX = (float)Math.cos(radians(flubAngle))*20.0 + 30.5;
      float flubY = (float)Math.sin(radians(flubAngle))*20.0 + 30.5;
      flubAngle = flubAngle + 3.4;
      for (int i = 0; i < shieldVerticies.size()-1; i++) {
        PVector p1 = (PVector)shieldVerticies.get(i);
        PVector p2 = (PVector)shieldVerticies.get(i+1);
        curve(p1.x+flubX, p1.y+flubY, p1.x, p1.y, p2.x, p2.y, p2.x - flubX, p2.y - flubY);
      }
      PVector p2 = (PVector)shieldVerticies.get(shieldVerticies.size()-1);
      PVector p1 = (PVector)shieldVerticies.get(0);
      curve(p1.x+flubX, p1.y+flubY, p1.x, p1.y, p2.x, p2.y, p2.x - flubX, p2.y - flubY);

      strokeWeight(1);
    }
  }

  void rotate_ship(float amount) {    
    direction += amount;
  }

  void increaseSpeedBy(float amount) {
    if (speed+amount < 5) {
      speed += amount;
    } 
    if (speed < 0) {
      speed = 0;
    }
  }

  void fireBullet() {
    if (bullets.size()<bulletCapacity)
      bullets.add(new Bullet(x, y, speed+3, direction));
  }

  boolean hasHitTarget(Movable target) {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = (Bullet)bullets.get(i);
      if (b!= null) {
        if (target.collidingWith(b)) {
          return true;
        }
      }
    }
    return false;
  }
}
