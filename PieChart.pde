Table table;

void setup() {
  size(800, 800);
  background(255);


  table = loadTable("dataset-edit.csv", "header");


  color[] colors = {
    color(128,0,0),
    color(0,128,128),
    color(0,0,128),
    color(245,130,48),
    color(255,225,25)
  };


  int[] groups = {0, 0, 0, 0, 0};

  for (TableRow row : table.rows()) {
    float y = row.getFloat("y");
    if (y >= 0 && y < 20) { groups[0]++; }
    if (y >= 20 && y < 40) { groups[1]++; }
    if (y >= 40 && y < 60) { groups[2]++; }
    if (y >= 60 && y < 80) { groups[3]++; }
    if (y >= 80 && y < 100) { groups[4]++; }
  }

  drawPieChart(groups, colors);
}

void drawPieChart(int[] data, color[] colors) {
  float total = 0;
  for (int i = 0; i < data.length; i++) {
    total += data[i];
  }

  float lastAngle = 0;
  float cx = width / 2;
  float cy = height / 2;
  float diameter = 500;

  textAlign(CENTER, CENTER);
  textSize(16);

  for (int i = 0; i < data.length; i++) {
    fill(colors[i]);
    float angle = data[i] / total * TWO_PI;
    arc(cx, cy, diameter, diameter, lastAngle, lastAngle + angle, PIE);


    float mid = lastAngle + angle / 2;
    float labelX = cx + cos(mid) * 200;
    float labelY = cy + sin(mid) * 200;

    fill(0);
    text(getLabel(i), labelX, labelY);

    lastAngle += angle;
  }

  fill(0);
  textSize(24);
  text("Pie Chart of Y-Value Distribution", width/2, 60);
}


String getLabel(int i) {
  if (i == 0) return "0–19";
  if (i == 1) return "20–39";
  if (i == 2) return "40–59";
  if (i == 3) return "60–79";
  if (i == 4) return "80–100";
  return "";
}
