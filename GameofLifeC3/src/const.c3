module gameoflifec3;
import raylib;

const String TTBN = "C3 | Game Of Life";

const char PDG_TOP = 80;
const char PDG_LR = 10;

const uint HHT = 800 + PDG_TOP;  // Height - Altura
const uint WTH = 800 + PDG_LR;  // Width - largura

const GRD_CELL_SIZE = 25;

const Color GRD_CELL_DEAD = {0, 25, 0, 255};
const Color GRD_CELL_LIFE = {55, 55, 55, 255};


int center_text = WTH / 2 - PDG_TOP;

fn void center_draw_text(String text, int x, int y, int size, Color color) {
    raylib::draw_text(text, center_text + x, y, size, color);
}
