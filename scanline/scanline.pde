/* Fábián Gábor //<>//
 * CXNU8T
 */
/* 
 Készítsen diszkrét szakaszhalmazt megjelenítő alkalmazást statikusan és dinamikusan!
 
 (Statikus: első kattintásra nem történik semmi, második kattintásra megjelenik az első és a második kattintás által definiált egyértelmű szakasz.
 Dinamikus: első kattintásra nem történik semmi, a második kattintásig folyamatosan megjelenik az az egyértelmű szakasz, melyet az első kattintás és az egér aktuális pozíciója definiál. Második kattintásra megjelenik az első és a második kattintás által definiált egyértelmű szakasz.)
 */
Table table;
boolean closed = true;
boolean dynamic = false;
int bgColor = 204;
boolean startFill = true;

void setup() {
    size(640, 480);

    table = new Table();    
    table.addColumn("x");
    table.addColumn("y");
}

void draw() {
    background(bgColor);
    drawLines(table);
    //triangle(320, 40, 40, 440, 600, 440);
    
    if (table.getRowCount() > 2)
        scanlineFill();
        
    println(frameRate);
    //textSize(12);
    //text("SHIFT: toggle open/closed shape", 5, 12); 
    //text("TAB:   toggle dynamic drawing", 5, 30);
    //fill(122);
}

void drawLine(float x, float y, float x0, float y0) {
    float m;
    float i, j;

    if (x0 != x) { // nem függőleges
        m = (y0 - y) / (x0 - x);

        if (abs(m) <= 1) {
            j = (x < x0) ? y : y0;
            for (i = (x < x0) ? x : x0; i < ((x > x0) ? x : x0); i++) {
                point(i, j);
                j += m;
            }
        } else {
            i = (y < y0) ? x : x0;
            for (j = (y < y0) ? y : y0; j < ((y > y0) ? y : y0); j++) {
                point(i, j);
                i += 1/m;
            }
        }
    } else {    // függőleges
        for (j = (y < y0) ? y : y0; j < ((y > y0) ? y : y0); j++) {
            point(x, j);
        }
    }
}

void scanlineFill() {
    loadPixels();
    int x1 = 0, x2 = 0;
    for (int y = 1; y < height; y++) { //<>//
        startFill = false;
        for (int x = 1; x < width; x++) {
            if (pixels[y*width+x] != color(bgColor)) {
                if (!startFill) {
                    x1 = x;
                    x2 = x;
                    startFill = true;
                } else {
                    x2 = x;                    
                }
            }            
        } // sor vége
        
        if (x1 == x2 && x1 > 0) {
            startFill = false;            
        }
        
        if (startFill) {
            drawLine(x1,y,x2,y);
            startFill = false;
        }
    } // oszlop vége
}

void drawLines(Table table) {    
    int x, y, x0, y0, i;
    x = 0;
    y = 0;

    if (table.getRowCount() > 0) {
        x = table.getRow(0).getInt("x");
        y = table.getRow(0).getInt("y");
    }

    for (i = 0; i < table.getRowCount()-1; i++) {
        x0 = table.getRow(i).getInt("x");
        y0 = table.getRow(i).getInt("y");

        x = table.getRow(i+1).getInt("x");
        y = table.getRow(i+1).getInt("y");

        drawLine(x, y, x0, y0);
    }

    if (dynamic) {
        drawLine(x, y, mouseX, mouseY);
    }

    if (i > 1 && closed) {
        x0 = table.getRow(0).getInt("x");
        y0 = table.getRow(0).getInt("y");

        if (dynamic) {
            drawLine(x0, y0, mouseX, mouseY);
        } else {
            drawLine(x, y, x0, y0);
        }
    }
}

void mousePressed() {
    TableRow newRow = table.addRow();    
    newRow.setInt("x", mouseX);
    newRow.setInt("y", mouseY);    
}

void keyPressed() {
    if (keyCode == SHIFT) {
        closed = !closed;        
    }
    if (key == TAB) {
        dynamic = !dynamic;        
    }
}
