// ----------------------------------------
// MEGA PLATE WITH COLOR
// ----------------------------------------

Bacteria[] bugs;
int numZones = 5;
float zoneWidth;

// antibiotic strength for each zone
int[] zoneStrength = {1, 10, 100, 1000, 10000};

void setup() {
  size(600, 600);

  zoneWidth = width / numZones;

  bugs = new Bacteria[300];

  // create bacteria in zone 0 (left side)
  for (int i = 0; i < bugs.length; i++) {
    bugs[i] = new Bacteria();
  }
}

void draw() {
  background(0);

  drawZones();

  // update bacteria
  for (int i = 0; i < bugs.length; i++) {
    if (bugs[i].alive) {
      bugs[i].move();
      bugs[i].checkZone();
      bugs[i].show();
    }
  }
}

// ----------------------------------------
// CLICK TO SCATTER BACTERIA
// ----------------------------------------
void mousePressed() {
  for (int i = 0; i < bugs.length; i++) {
    if (bugs[i].alive) {
      bugs[i].scatter(mouseX, mouseY);
    }
  }
}

// ----------------------------------------
// DRAW ANTIBIOTIC ZONES
// ----------------------------------------
void drawZones() {
  for (int i = 0; i < numZones; i++) {
    float shade = 40 + i * 30; // darker = stronger antibiotic
    fill(shade);
    noStroke();
    rect(i * zoneWidth, 0, zoneWidth, height);
  }
}

// ----------------------------------------
// BACTERIA CLASS
// ----------------------------------------
class Bacteria {

  float x, y;
  float angle;
  float speed;

  int resistance; 
  boolean alive;

  int timeInBadZone;

  Bacteria() {
    x = random(zoneWidth);
    y = random(height);

    angle = random(TWO_PI);
    speed = 1.5;

    resistance = 1;
    alive = true;

    timeInBadZone = 0;
  }
  
  
  // fix gradient so that fewer follow as pass through different zones
//influence based on mouse posiiton
//see if dies off in certain band
//w = weight 
//mouse position - x initial mulitplied by weight to get following distance of bacteria
//fix so bacteria can't go backwards

  void move() {
    angle += random(-0.2, 0.2);
    
    //float w = 0.01;
   // x = x + (mouseX-x) * w;
    //y = y + (mouseY - y) * w;

    float bias = 0.5;  // forward push
    x += cos(angle) * speed + bias;
    y += sin(angle) * speed;

    x = constrain(x, 0, width);
    y = constrain(y, 0, height);
  }

  void checkZone() {
    int zone = int(x / zoneWidth);
    zone = constrain(zone, 0, numZones - 1);

    if (zoneStrength[zone] > resistance) {

      int danger = zoneStrength[zone];
      timeInBadZone += danger / 2;

      if (timeInBadZone > 80) {
        resistance = zoneStrength[zone];
        timeInBadZone = 0;
      }

      if (timeInBadZone > 200) {
        alive = false;
      }

    } else {
      timeInBadZone = 0;
      resistance = zoneStrength[zone];
    }
  }

  // ----------------------------------------
  // SCATTER FUNCTION — PUSHES BACTERIA AWAY
  // ----------------------------------------
  void scatter(float mx, float my) {
    float d = dist(x, y, mx, my);
    float radius = 200;  // scatter radius

    if (d < radius) {
      float force = (radius - d) / radius;
      float angleAway = atan2(y - my, x - mx);

      x += cos(angleAway) * force * 20;
      y += sin(angleAway) * force * 20;

      x = constrain(x, 0, width);
      y = constrain(y, 0, height);
    }
  }

  void show() {
    if (!alive) return;

    if (resistance == 1) fill(255);            // white
    else if (resistance == 10) fill(150, 0, 200);  // purple
    else if (resistance == 100) fill(0, 0, 255);   // blue
    else if (resistance == 1000) fill(255, 255, 0); // yellow
    else if (resistance == 10000) fill(255, 0, 0);  // red

    noStroke();
    ellipse(x, y, 4, 4);
  }
}
