const char PDG_TOP = 80;
const char PDG_LR = 10;

const uint HHT = 800 + PDG_TOP;  // Height - Altura
const uint WTH = 800 + PDG_LR;  // Width - largura

const char GRD_CELL_SIZE = 25;

const short CENTER_TEXT = WTH/ 2 - PDG_TOP;

const int[<3>] BORDER = {PDG_TOP-4, WTH - PDG_LR, HHT - PDG_TOP};


struct Text_opt {
    ZString state;
    short r, g, b;
}

const Text_opt[2] GUI_TEXTS_AC = {
    {"Living cells:", 20, cst::PDG_TOP-35, 19},

    {"Graphic API:", 10, cst::PDG_TOP-70, 17},
};

const Text_opt[3] GUI_TEXTS_TITLE = {
    {"The Game Of", -5, 18, 20},
    {"LIFE!", 133, 18, 20},

    {"Game:", 40, 55, 24}
};

const Text_opt[2] GUI_TEXTS_STATE = {
    {"On", 110, 55, 24},
    {"Off", 110, 55, 24}
};
