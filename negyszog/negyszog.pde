Table table;
boolean startFill = false;
int bgColor = 204;
boolean redraw = false;
float x1, y1, x2, y2, x3, y3, x4, y4;

void setup() {
    size(640, 480);
    table = new Table();    
    table.addColumn("x");
    table.addColumn("y");
}

void draw() {    
    if (table.getRowCount() > 1) {
        if (redraw) {
            background(204);
            drawRectangle(table);
            scanlineFill();
            parquet();
            redraw = false;
        }        
    }
}

void drawRectangle(Table table) {
    if (table.getRowCount()>1) {
        x1 = table.getRow(0).getInt("x");
        y1 = table.getRow(0).getInt("y");

        x2 = table.getRow(1).getInt("x");
        y2 = table.getRow(1).getInt("y");

        x3 = x2 + (y2-y1);
        y3 = y2 - (x2-x1);
        
        x4 = x1 + (y2-y1);
        y4 = y1 - (x2-x1);

        drawLine(x1, y1, x2, y2);
        drawLine(x2, y2, x3, y3);
        drawLine(x3, y3, x4, y4);
        drawLine(x4, y4, x1, y1);
    }
}

void parquet() {
    float x12 = abs(x1-x2);
    float y12 = abs(y1-y2);
    float x13 = abs(x1-x3);
    float y13 = abs(y1-y3);
    float x23 = abs(x2-x3);
    float y23 = abs(y2-y3);

    float x1_tmp = x1, y1_tmp = y1;    
    float x2_tmp = x2, y2_tmp = y2;
    float x3_tmp = x3, y3_tmp = y3;    
    
    int x12_delta = (int)((x2 >= x1) ? x12 : -x12);
    int y12_delta = (int)((y2 >= y1) ? y12 : -y12);
    int x23_delta = (int)((x3 >= x2) ? x23 : -x23);
    int y23_delta = (int)((y3 >= y2) ? y23 : -y23);
    int x13_delta = (int)((x1 >= x3) ? x13 : -x13);
    int y13_delta = (int)((y1 >= y3) ? y13 : -y13);
        
    double size = 0.707106781 * Math.sqrt(Math.pow((x2-x1),2) + Math.pow((y2-y1),2)); // sqrt(2)/2 * oldalhossz    
    int fitCount = (int) (width / size );
    
    for (int i = 0; i < fitCount; i++) {        
        x1_tmp += x12_delta;
        y1_tmp += y12_delta;
        x2_tmp += x23_delta;
        y2_tmp += y23_delta;       
        x3_tmp += x13_delta;        
        y3_tmp += y13_delta;
                
        drawParallelLinesCombined(x1, y1, x2, y2, x2_tmp, y2_tmp, x3_tmp, y3_tmp, x12, y12, fitCount);        
        drawParallelLinesCombined(x2, y2, x3, y3, x1_tmp, y1_tmp, x3_tmp, y3_tmp, x23, y23, fitCount);
    }
}

void drawParallelLines(float x1, float y1, float x3, float y3, float x, float y, float x12, float y12, int fitCount) {
    if ( (x1-x3) * (y1-y3) >= 0 ) {
        drawLine(x+x12*fitCount, y+y12*fitCount, x, y);
        drawLine(x-x12*fitCount, y-y12*fitCount, x, y);
    } else {
        drawLine(x+x12*fitCount, y-y12*fitCount, x, y);
        drawLine(x-x12*fitCount, y+y12*fitCount, x, y);
    }
}

void drawParallelLinesCombined(float x1, float y1, float x3, float y3, float xTop, float yTop, float xBottom, float yBottom, float x12, float y12, int fitCount) {
    if ( (x1-x3) * (y1-y3) >= 0 ) {
        drawLine(xTop+x12*fitCount, yTop+y12*fitCount, xTop, yTop);
        drawLine(xTop-x12*fitCount, yTop-y12*fitCount, xTop, yTop);
        drawLine(xBottom+x12*fitCount, yBottom+y12*fitCount, xBottom, yBottom);
        drawLine(xBottom-x12*fitCount, yBottom-y12*fitCount, xBottom, yBottom);
    } else {
        drawLine(xTop+x12*fitCount, yTop-y12*fitCount, xTop, yTop);
        drawLine(xTop-x12*fitCount, yTop+y12*fitCount, xTop, yTop);
        drawLine(xBottom+x12*fitCount, yBottom-y12*fitCount, xBottom, yBottom);
        drawLine(xBottom-x12*fitCount, yBottom+y12*fitCount, xBottom, yBottom);
    }
}

void scanlineFill() {
    loadPixels(); // pixels[] miatt
    int x1 = 0, x2 = 0;
    for (int y = 1; y < height; y++) {
        for (int x = 1; x < width; x++) {
            if (pixels[y*width+x] != color(bgColor)) { // get(x, y) = pixels[y*width+x]
                x2 = x;
                if (!startFill) {
                    x1 = x;
                    x2 = x;
                    startFill = true;
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

void mousePressed() {
    redraw = true;    
    if (table.getRowCount() == 2) {
        table.clearRows();
    }
    TableRow newRow = table.addRow();    
    newRow.setInt("x", mouseX);
    newRow.setInt("y", mouseY);
}
