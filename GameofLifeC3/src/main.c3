module game;

import gofl_rylib::system_ry;
import gofl_sdl3::system_sdl;

import cst;

const String TTBN = "C3 | Game Of Life";

fn void api_change(bool *api_c) {
    if (*api_c) system_ry::init(TTBN, api_c);

    if (!*api_c) {
        system_sdl::init(TTBN, api_c);

        if (*api_c) api_change(api_c);
    }
}

fn void main() {
    bool api_c = true;

    api_change(&api_c);
}

