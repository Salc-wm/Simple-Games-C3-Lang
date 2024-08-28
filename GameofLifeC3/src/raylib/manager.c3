module gofl_rylib::system_ry @local;
import gofl_rylib;

import raylib;
import raylib::keyboard;

import cst;
import std::io;

struct Text_opt {
    String state;
    short r, g, b;
    Color color;
}

macro bool key_pressed($key) => raylib::is_key_pressed($key);

macro Table @get_grid_rc(float row, float column, #size) => { (short)row / #size, (short)column / #size };
macro Color background_color() => raylib::get_color(0x101010FF);

macro void center_draw_text(Text_opt args, bool align = true) =>
    raylib::draw_text(args.state, align? cst::CENTER_TEXT + args.r : args.r, args.g, args.b, args.color);

const int[<3>] BORDER = {cst::PDG_TOP-4, cst::WTH - cst::PDG_LR, cst::HHT - cst::PDG_TOP};

const Color COLOR_TEXT @local = raylib::LIGHTGRAY;

const Text_opt[3] UI_TEXTS_AC = {
    {"Living cells:", 20, cst::PDG_TOP-35, 19, COLOR_TEXT},

    {"Graphic API:", 10, cst::PDG_TOP-70, 17, COLOR_TEXT},
    {"Raylib -> OpenGL", 112, cst::PDG_TOP-70, 16, raylib::ORANGE}
};

const Text_opt[3] UI_TEXTS_TITLE = {
    {"The Game Of", -5, 18, 20, COLOR_TEXT},
    {"LIFE!", 133, 18, 20, raylib::GREEN},

    {"Game:", 40, 55, 24, COLOR_TEXT}
};

const Text_opt[2] UI_TEXTS_STATE = {
    {"On", 110, 55, 24, raylib::GREEN},
    {"Off", 110, 55, 24, raylib::GRAY}
};

fn Table get_grid_mouse_pos() {
    Vector2 mouse_position = raylib::get_mouse_position();

    return @get_grid_rc(
        mouse_position.y - cst::PDG_TOP,
        mouse_position.x - cst::PDG_LR, cst::GRD_CELL_SIZE
    );
}

fn void keyboard_actions(Simulation* game, bool *api) {
    if (key_pressed(keyboard::ENTER) || key_pressed(keyboard::SPACE)) {|
        if (!game.run) {
            game.start();

            return;
        }

        game.stop();
    |};

    Table grid_hover_mouse = get_grid_mouse_pos();
    game.actionCell(grid_hover_mouse, raylib::is_mouse_button_down(MouseButton.BUTTON_LEFT)? true:false);

    if (key_pressed(keyboard::F)) {
        game.createRandomState();
    } else if (raylib::is_key_pressed(keyboard::G)) game.clearGrid();

    if (key_pressed(keyboard::TAB)) *api = false;
}

fn void gofl_update(Simulation game, bool *api) {
    while (!raylib::window_should_close() && *api)
    {
        game.update();

        raylib::begin_drawing();
            raylib::clear_background(background_color());
            raylib::draw_rectangle_lines(5, BORDER.x, BORDER.y, BORDER.z, raylib::BLACK);

            game.draw();
            game_ui(&game);

        raylib::end_drawing();
        keyboard_actions(&game, api);
    }
}

fn void game_ui(Simulation* game) {
    raylib::draw_fps(raylib::get_screen_width() - 80, 10);

    foreach (ui: UI_TEXTS_TITLE) center_draw_text(ui);
    foreach (ui: UI_TEXTS_AC) center_draw_text(ui, false);

    center_draw_text(game.@isRunning()? UI_TEXTS_STATE[0] : UI_TEXTS_STATE[1]);

    raylib::draw_text(string::new_format("%d", game.getLivingCells()), 120, cst::PDG_TOP-35, 20, raylib::GREEN);
}

fn void init(String title, bool *api) @public
{
    raylib::init_window(cst::WTH, cst::HHT, title);
    defer raylib::close_window();

    raylib::set_target_fps(12);


    Image logo = raylib::load_image("resources/img/c3golf.png");

    raylib::set_window_icon(logo);
    raylib::unload_image(logo);


    Grid game_grid = gofl_rylib::grid(cst::WTH, cst::HHT);
    // Game State: run | Living cells: l_cells | Grid 1/Grid 2: grid
    Simulation simulation = { .grid = game_grid };

    gofl_update(simulation, api);
}
