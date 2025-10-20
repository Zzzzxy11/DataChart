Table table;
color[] COLORS = {
  color(128,0,0),
  color(0,128,128),
  color(0,0,128),
  color(245,130,48),
  color(255,225,25)
};
String[] BIN_LABELS = {"0–19", "20–39", "40–59", "60–79", "80–100"};
float MARGIN_LEFT = 90;
float MARGIN_RIGHT = 50;
float MARGIN_TOP = 70;
float MARGIN_BOTTOM = 90;
int[] groups;

void setup() {
  size(800, 800);
  smooth(4);
  table = loadTable("dataset-edit.csv", "header");
  groups = processData();
  drawBarGraph();
  noLoop();
}

int[] processData() {
  int[] g = {0,0,0,0,0};
  for (TableRow row : table.rows()) {
    float y = row.getFloat("y");
    if (y >= 0 && y < 20) g[0]++;
    else if (y < 40) g[1]++;
    else if (y < 60) g[2]++;
    else if (y < 80) g[3]++;
    else if (y <= 100) g[4]++;
  }
  return g;
}

void drawBarGraph() {
  background(250);
  float originX = MARGIN_LEFT;
  float originY = height - MARGIN_BOTTOM;
  float axisW = width - MARGIN_LEFT - MARGIN_RIGHT;
  float axisH = height - MARGIN_TOP - MARGIN_BOTTOM;
  int maxCount = 0;
  for (int v : groups) maxCount = max(maxCount, v);
  if (maxCount == 0) maxCount = 1;
  drawXAxis(originX, originY, axisW);
  drawYAxis(originX, originY, axisH, maxCount, 5);
  float spacing = 12;
  float barW = (axisW - spacing * (groups.length + 1)) / groups.length;
  drawBars(originX, originY, axisH, barW, spacing, groups, maxCount);
  textAlign(CENTER);
  fill(40);
  textSize(12);
  for (int i = 0; i < groups.length; i++) {
    float barX = originX + spacing + i * (barW + spacing);
    float labelX = barX + barW/2;
    text(BIN_LABELS[i], labelX, originY + 18);
    float hPix = map(groups[i], 0, maxCount, 0, axisH);
    text(groups[i], labelX, originY - hPix - 6);
  }
  textAlign(CENTER, CENTER);
  textSize(18);
  fill(20);
  text("Bar Graph of Y-Value Distribution", width/2, MARGIN_TOP/2);
}

void drawBars(float originX, float originY, float axisH,
              float barW, float spacing, int[] values, int maxCount) {
  rectMode(CORNER);
  noStroke();
  for (int i = 0; i < values.length; i++) {
    float hPix = map(values[i], 0, maxCount, 0, axisH);
    float x = originX + spacing + i * (barW + spacing);
    float y = originY - hPix;
    fill(COLORS[i % COLORS.length]);
    rect(x, y, barW, hPix);
  }
}

void drawXAxis(float originX, float originY, float axisW) {
  stroke(0);
  strokeWeight(1.5);
  line(originX, originY, originX + axisW, originY);
  fill(30);
  textAlign(CENTER, TOP);
  textSize(13);
  text("Ranges", originX + axisW/2, originY + 40);
}

void drawYAxis(float originX, float originY, float axisH, int maxCount, int tickCount) {
  stroke(0);
  strokeWeight(1.5);
  line(originX, originY, originX, originY - axisH);
  textAlign(RIGHT, CENTER);
  textSize(12);
  for (int t = 0; t <= tickCount; t++) {
    float val = map(t, 0, tickCount, 0, maxCount);
    float y = originY - map(val, 0, maxCount, 0, axisH);
    stroke(0);
    line(originX - 5, y, originX, y);
    stroke(0, 50);
    line(originX, y, originX + (width - MARGIN_LEFT - MARGIN_RIGHT), y);
    noStroke();
    fill(30);
    text(nf(val, 0, 0), originX - 10, y);
  }
  pushMatrix();
  translate(originX - 55, originY - axisH/2);
  rotate(-HALF_PI);
  textAlign(CENTER, CENTER);
  textSize(13);
  fill(30);
  text("Count", 0, 0);
  popMatrix();
}
