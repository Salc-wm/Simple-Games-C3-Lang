module conwaysgameoflife;

import gofl_rylib5::system_rl5;
import gofl_rylib::system_rl;

import gofl_sdl2::system_sdl2;
import gofl_sdl3::system_sdl;

import gofl_opengl::system_glfw;

const String TTBN = "C3 | Game Of Life";

fn void api_change(char *api_c) {
    if (*api_c == 1) system_rl::init(TTBN, api_c);
    if (*api_c == 2) system_rl5::init(TTBN, api_c);

    if (*api_c == 3) system_sdl::init(TTBN, api_c);
    if (*api_c == 4) system_sdl2::init(TTBN, api_c);

    if (*api_c == 5) system_glfw::init(TTBN, api_c);

    if (*api_c == 1) api_change(api_c);
}

fn void main() {
    char api_c = 5;

    api_change(&api_c);
}

