// --- BEGIN SHIM; REMOVE TO RUN ON DESKTOP ---
// (jump to line 62 for project code)

void circle(float x, float y, float extent) {
  ellipse(x, y, extent, extent);
}

void square(float x, float y, float extent) {
  rect(x, y, extent, extent)
}

void clear() {
  background(color(255, 255, 255));
}

void delay(int length) {
  long blockTill = Date.now() + length;
  while (Date.now() <= blockTill) {}
}

String __errBuff = "";
String __outBuff = "";

var System = {};
System.out = {};
System.err = {};

System.err.print = function (chars) {
  __errBuff += chars;
  String[] newlines = __errBuff.split("\n");
  if (newlines.length > 0) {
    String[] linesToPrint = newlines.slice(0, newlines.length - 1);
    linesToPrint.forEach(function (line) {
      console.error(line);
    })
    __errBuff = newlines[newlines.length - 1];
  }
};

System.currentTimeMillis = function () { return Date.now(); }

System.err.println = function (chars) {
  System.err.print(chars + "\n");
};

System.out.print = function (chars) {
  __outBuff += chars;
  String[] newlines = __outBuff.split("\n");
  if (newlines.length > 0) {
    String[] linesToPrint = newlines.slice(0, newlines.length - 1);
    linesToPrint.forEach(function (line) {
      console.log(line);
    })
    __outBuff = newlines[newlines.length - 1];
  }
};

System.out.println = function (chars) {
  System.out.print(chars + "\n");
};
// --- END SHIM; REMOVE TO RUN ON DEKTOP ---
Bacterium[] bacteria;

float targetX = 256, targetY = 256;
float actualX = 256, actualY = 256;


long timeTillNextUpdate = 0L;
boolean auto = false;

void setup() {
  size(512, 512);
  bacteria = new Bacterium[1_000];
  for (int i = 0; i < bacteria.length; i++) {
    bacteria[i] = new Bacterium();
  }
}

void draw() {
  background(color(64, 64, 64));
  
  if (auto) {
    actualX = lerp(actualX, mouseX, 0.3);
    actualY = lerp(actualY, mouseY, 0.3);
    fill(color(230, 0, 0));
    circle(actualX, actualY, 75);
  } else {
    if (System.currentTimeMillis() > timeTillNextUpdate) {
      timeTillNextUpdate = System.currentTimeMillis() + (long) (Math.random() * 1000) + 1000;
      targetX = (int) (Math.random() * 500) + 12;
      targetY = (int) (Math.random() * 500) + 12;
    }
    actualX = lerp(actualX, targetX, 0.2);
    actualY = lerp(actualY, targetY, 0.2);
    fill(color(0, 230, 0));
    circle(actualX, actualY, Math.max((int) ((timeTillNextUpdate - System.currentTimeMillis()) / 8), 20));
  }

  
  
  for (int i = 0; i < bacteria.length; i++) {
    bacteria[i].tick();
    bacteria[i].draw();
  }
}

void mouseReleased() {
  auto = !auto;
}

class Bacterium {
  float x, y;
  color clr;
  long ignoreTill;
  
  Bacterium() {
    this.x = (int) (Math.random() * 512);
    this.y = (int) (Math.random() * 512);
    this.clr = color(
      (int) (Math.random() * 128) + 128,
      (int) (Math.random() * 128) + 128,
      (int) (Math.random() * 128) + 128
    );
    this.ignoreTill = -1L;
  }
  
  Bacterium(float x, float y, color clr) {
    this.x = x;
    this.y = y;
    this.clr = clr;
  }
  
  void tick() {
    //randomMove();
    if (System.currentTimeMillis() > this.ignoreTill) {
      biasedMove(actualX, actualY);
    } else randomMove();
  }
  
  
  void biasedMove(float tX, float tY) {
    // create some error
    tX += Math.random() * 300 * (Math.random() > 0.5 ? 1 : -1);
    tY += Math.random() * 300 * (Math.random() > 0.5 ? 1 : -1);
    
    double distance = Math.sqrt(Math.pow(this.x - tX, 2) + Math.pow(this.y - tY, 2)),
      multi = 0.03;
     
    if (distance > 40) {
        double vectorX = (tX - this.x) * multi;
        double vectorY = (tY - this.y) * multi;
        this.x += vectorX;
        this.y += vectorY;
    } else {
      this.ignoreTill = System.currentTimeMillis() + (long) (Math.random() * 2_000);
    }
  }
  
  void randomMove() {
    this.x += Math.random() * 10 * (Math.random() > 0.5 ? 1 : -1);
    this.y += Math.random() * 10 * (Math.random() > 0.5 ? 1 : -1);
  }
  
  void draw() {
    push();
    {
      double jitterX = Math.random() * 1.5 * (Math.random() > 0.5 ? 1 : -1), 
        jitterY = Math.random() * 1.5 * (Math.random() > 0.5 ? 1 : -1);
      translate(this.x + (float) jitterX, this.y + (float) jitterY);
      fill(this.clr);
      circle(0, 0, 10);
    }
    pop();
  }
}
