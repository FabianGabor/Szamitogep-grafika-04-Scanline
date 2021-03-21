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

int xA, yA, xB, yB, xC, yC;

void setup() {
    size(640, 480);

    table = new Table();    
    table.addColumn("x");
    table.addColumn("y");
    
    
    TableRow newRow;    
    newRow = table.addRow();
    newRow.setInt("x", 200);
    newRow.setInt("y", 300);
    
    newRow = table.addRow();
    newRow.setInt("x", 400);
    newRow.setInt("y", 400);    
    
    
}

void draw() {
    background(bgColor);
    drawLines(table);

    //scanlineFill();

    if (table.getRowCount() > 1) {
        parquet(xA, yA, xB, yB, xC, yC);        
    }
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
    //int xA, yA, xB, yB, xC, yC;

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
}

void lineThroughPoint(float m, float x0, float y0) {
    float x = 0;
    float yStart = m*x + y0 - m*x0;
    float yEnd = m*x + y0 - m*x0;

    while (x<width) {
        x++;
        yEnd = m*x + y0 - m*x0;
    }
    drawLine(0, yStart, x, yEnd);
}

void parquet(int x1, int y1, int x2, int y2, int x3, int y3) {
    float m;
    
    if (x3 != x2) {
        m = (y3 - y2)*1.0 / (x3 - x2);
        lineThroughPoint(m, x1, y1);
        
        //m = (y3 - y1)*1.0 / (x3 - x1);
        //lineThroughPoint(m, x2, y2);
        
        //m = (y2 - y1)*1.0 / (x2 - x1);
        //lineThroughPoint(m, x3, y3);
        
        float deltaX, deltaY;    
        float x, y;
        
                
        deltaX = tan((90.0 - atan(m) * 180 / PI) * PI / 180) * abs(y2-y1);
        deltaX = abs(x2-x1) - deltaX;
        deltaY = 0;
        x = x1;
        y = y1;
        
        while (x>0 && y>0) {
            x-=deltaX;
            y-=deltaY;
        }
        
        while (abs((y - height - m * x)/m) < width || abs((y - 0 - m * x)/m) < width) {
            lineThroughPoint(m, x, y);
            x+=deltaX;
            y+=deltaY;             //<>//
        }
        
    }
}

void mousePressed() {
    // ellenorzi, hogy csak 2 pont legyen!
    if (table.getRowCount() == 2) {
        table.clearRows();
    }

    TableRow newRow = table.addRow();    
    newRow.setInt("x", mouseX);
    newRow.setInt("y", mouseY);
}
