import raylib;

const char PDG_TOP = 80;
const char PDG_LR = 10;

const uint HHT = 800 + PDG_TOP;  // Height - Altura
const uint WTH = 800 + PDG_LR;  // Width - largura

const char GRD_CELL_SIZE = 25;

const Color GRD_CELL_DEAD = {0, 25, 0, 255};
const Color GRD_CELL_LIFE = {65, 65, 65, 255};

const short CENTER_TEXT = WTH/ 2 - PDG_TOP;
