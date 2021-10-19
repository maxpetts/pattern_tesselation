Pattern pattern;
Pattern tess_pattern;

int cell_width = 10;
int cell_spacing = 2;
int pattern_size = 5;
int pattern_repeat = 10;

int win_height = cell_spacing + ((cell_width + cell_spacing) * pattern_size) * pattern_repeat;
int win_width = ((cell_width + (cell_spacing * 2)) * pattern_size) + ((cell_width + cell_spacing) * pattern_size) * pattern_repeat;

void settings() {
  size(win_width, win_height);
}

void setup() {
  if (cell_width < 10) {
    print("Please be aware this isn't designed to run so small");
  }

  pattern = new Pattern();
  tess_pattern = new Pattern();

  // Add rotate button
  // pattern_size * (cell_width + cell_spacing) - cell_spacing works for rect length but not elegant
  fill(255);
  rect(cell_spacing, (cell_width + (cell_spacing * 2)) * pattern_size, pattern_size * (cell_width + cell_spacing) - cell_spacing, 20);
  fill(30);
  text("rotate 90", cell_spacing * 2, (cell_width + (cell_spacing * 3.5)) * pattern_size);

  // Add clear button
  fill(255);
  rect(cell_spacing, (cell_width + (cell_spacing * 5)) * pattern_size, pattern_size * (cell_width + cell_spacing) - cell_spacing, 20);
  fill(30);
  text("clear", cell_spacing * 2, (cell_width + (cell_spacing * 6.5)) * pattern_size);
}

void draw() {
  // the x arg centers the drawable pattern
  pattern.drawPattern(cell_spacing, cell_spacing);
  pattern.drawTesselatedPattern((cell_width + (cell_spacing * 2)) * pattern_size, cell_spacing, 10);
}

void mousePressed() {
  // Individual cell pressing
  if (mouseX > cell_spacing &&
    mouseX < pattern_size * (cell_width + cell_spacing) - cell_spacing &&
    mouseY > cell_spacing &&
    mouseY < pattern_size * (cell_width + cell_spacing) - cell_spacing) {
    if (mouseButton == RIGHT)
      pattern.clearCell(mouseX / (cell_width + cell_spacing), mouseY / (cell_width + cell_spacing);
    else
      pattern.toggleCell(mouseX / (cell_width + cell_spacing), mouseY / (cell_width + cell_spacing));
  }

  // rotate button
  if (mouseX > cell_spacing &&
    mouseX < pattern_size * (cell_width + cell_spacing) - cell_spacing &&
    mouseY > (cell_width + (cell_spacing * 2)) * pattern_size &&
    mouseY < 20 + (cell_width + (cell_spacing * 2)) * pattern_size) {
    pattern.rotateCW();
  }

  // clear button
  if (mouseX > cell_spacing &&
    mouseX < pattern_size * (cell_width + cell_spacing) - cell_spacing &&
    mouseY > (cell_width + (cell_spacing * 5)) * pattern_size &&
    mouseY < 20 + (cell_width + (cell_spacing * 5)) * pattern_size) {
    pattern.clearAllCells();
  }
}

class Cell {
  public boolean toggled = false;
  color colour = color(255);

  void clicked() {
    toggled = toggled ? false : true;
    updateColour();
  }

  public void drawCell(int cell_x, int cell_y, int cell_width) {
    fill(colour);
    rect(cell_x, cell_y, cell_width, cell_width);
  }

  void updateColour() {
    colour = color(random(255), random(255), random(255));
    redraw();
  }
  
  void reset() {
   toggled = false;
   colour = color(255);
   redraw();
  }
}

class Pattern {
  Cell[][] cells = new Cell[pattern_size][pattern_size];

  Pattern() {
    for (int i = 0; i < pattern_size; i++) {
      for (int j = 0; j < pattern_size; j++) {
        cells[i][j] = new Cell();
      }
    }
  }

  void drawPattern(int pattern_x, int pattern_y) {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells.length; j++) {
        cells[i][j].drawCell(
          pattern_x + i * (cell_width + cell_spacing),
          pattern_y + j * (cell_width + cell_spacing),
          cell_width);
      }
    }
  }

  void drawTesselatedPattern(int pattern_x, int pattern_y, int repeat) {
    int tesselated_spacing = (cell_width + cell_spacing) * pattern_size;
    for (int i = 0; i < repeat; i++) {
      for (int j = 0; j < repeat; j++) {
        drawPattern(pattern_x + (i * tesselated_spacing), pattern_y + (j * tesselated_spacing));
      }
    }
  }

  void rotateCW() {
    int size = cells.length;
    Cell[][] temp = new Cell[size][size];

    for (int i = 0; i < size; ++i) {
      for (int j = 0; j < size; ++j) {
        temp[i][j] = cells[j][size - i - 1];
      }
    }
    cells = temp;
    redraw();
  }

  void toggleCell(int x, int y) {
    if (x >= 0 && x < pattern_size && y >= 0 && y < pattern_size) {
      cells[x][y].clicked();
    }
  }

  void clearCell(int x, int y) {
    if (x >= 0 && x < pattern_size && y >= 0 && y < pattern_size) {
      cells[x][y].clear();
    }
  }

  void clearAllCells() {
    pattern = null;
    System.gc();
    pattern = new Pattern();
    redraw();
  }
}
