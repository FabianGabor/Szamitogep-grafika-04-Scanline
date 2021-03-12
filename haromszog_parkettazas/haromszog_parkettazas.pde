/* Fábián Gábor
 * CXNU8T
 */
/*
Készítse el azt az alkalmazást, mely egy megadott (statikusan vagy dinamikusan) szakaszt alapul véve előállít egy – a szakaszt, 
mint oldalélt tartalmazó – szabályos háromszöget, majd ezt kitölti, végül a háromszög szerint parkettázza a grafikus felületet! 
A program futásidőben újabb bemenő adattal állítsa elő a megfelelő modellt úgy, hogy az előző nem látszik!
*/

Table table;
boolean closed = true;
boolean dynamic = false;
int bgColor = 204;

void setup() {
    size(640, 480);

    table = new Table();    
    table.addColumn("x");
    table.addColumn("y");
}

void draw() {
    background(bgColor);
    drawLines(table);    
    
    /*
    if (table.getRowCount() > 2)
        scanlineFill();
        */
        
    println(frameRate);
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

void drawLines(Table table) {    
    int xA, yA, xB, yB, xC, yC;

    if (table.getRowCount()>1) {
        xA = table.getRow(0).getInt("x");
        yA = table.getRow(0).getInt("y");
    
        xB = table.getRow(1).getInt("x");
        yB = table.getRow(1).getInt("y");
    
        xC = (int)(xA + xB + sqrt(3) * (yB - yA) ) / 2;
        yC = (int)(yA + yB + sqrt(3) * (xA - xB) ) / 2;
    
        drawLine(xB, yB, xA, yA);
        drawLine(xC, yC, xA, yA);
        drawLine(xC, yC, xB, yB);
    }

    /*
    if (dynamic) {
        drawLine(x, y, mouseX, mouseY);
    }

    if (i == 1 && closed) {
        x0 = table.getRow(0).getInt("x");
        y0 = table.getRow(0).getInt("y");

        if (dynamic) {
            drawLine(x0, y0, mouseX, mouseY);
        } else {
            drawLine(x, y, x0, y0);
        }
    }
    */
}

void mousePressed() {
    // ellenorizni, hogy csak 2 pont legyen!
    if (table.getRowCount() == 2) {
        table.clearRows();
    }
    
    TableRow newRow = table.addRow();    
    newRow.setInt("x", mouseX);
    newRow.setInt("y", mouseY);  
}
