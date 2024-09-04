module conwaysgameoflife;

//import gofl_rylib5::system_rl5;
import gofl_rylib::system_rl;

import gofl_sdl3::system_sdl;

const String TTBN = "C3 | Game Of Life";

fn void api_change(bool *api_c) {
    if (*api_c) system_rl::init(TTBN, api_c);
    //if (*api_c) system_rl5::init(TTBN, api_c);

    if (!*api_c) {
        system_sdl::init(TTBN, api_c);

        if (*api_c) api_change(api_c);
    }
}

fn void main() {
    bool api_c = true;

    api_change(&api_c);
}

