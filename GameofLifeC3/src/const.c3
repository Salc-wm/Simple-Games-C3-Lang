module gofl;
import raylib;

const String TTBN = "C3 | Game Of Life";

const char PDG_TOP = 80;
const char PDG_LR = 10;

const uint HHT = 800 + PDG_TOP;  // Height - Altura
const uint WTH = 800 + PDG_LR;  // Width - largura

const char GRD_CELL_SIZE = 25;

const Color GRD_CELL_DEAD = {0, 25, 0, 255};
const Color GRD_CELL_LIFE = {65, 65, 65, 255};

def Table = int[<2>];


int center_text @local = WTH / 2 - PDG_TOP;

fn void center_draw_text(String text, int x, int y, int size, Color color) {
    raylib::draw_text(text, center_text + x, y, size, color);
}
