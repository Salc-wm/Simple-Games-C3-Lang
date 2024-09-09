module gofl_rylib::system_rl @local;

import cst_rl;
import gofl_simul;

import raylib;
import raylib::keyboard;

import cst;

macro bool key_pressed($key) => raylib::is_key_pressed($key);

macro Table @get_grid_rc(int row, int column) => { row / cst::GRD_CELL_SIZE, column / cst::GRD_CELL_SIZE };
macro Color background_color() => raylib::get_color(0x101010FF);

macro void center_draw_text(Text_opt args, Color color, bool align = true) =>
    raylib::draw_text(args.state, align? cst::CENTER_TEXT + args.r : args.r, args.g, args.b, color);


const Color COLOR_TEXT = raylib::LIGHTGRAY;

const Color[2] CL_TEXTS_AC = { COLOR_TEXT, COLOR_TEXT };
const Color[3] CL_TEXTS_TITLE = { COLOR_TEXT, raylib::GREEN, COLOR_TEXT };
const Color[2] CL_TEXTS_STATE = { raylib::GREEN, raylib::GRAY };


fn Table get_grid_mouse_pos() @inline {
    Vector2 mouse_position = raylib::get_mouse_position();

    return @get_grid_rc(
        (int)mouse_position.y - cst::PDG_TOP, (int)mouse_position.x
    );
}

fn void keyboard_actions(Simulation* game, char *api) {
    if (key_pressed(keyboard::ENTER) || key_pressed(keyboard::SPACE)) {|
        if (!game.run) {
            raylib::set_target_fps(12);
            game.start();

            return;
        }

        raylib::set_target_fps(120);
        game.stop();
    |};

    Table grid_hover_mouse = get_grid_mouse_pos();
    game.toggleCell(grid_hover_mouse, raylib::is_mouse_button_down(MouseButton.BUTTON_LEFT)? true:false, 1);
    game.toggleCell(grid_hover_mouse, raylib::is_mouse_button_down(MouseButton.BUTTON_RIGHT), 0);

    if (key_pressed(keyboard::F)) {
        game.createRandomState();
    } else if (raylib::is_key_pressed(keyboard::G)) game.clearGrid();

    if (key_pressed(keyboard::TAB)) *api = 2;
}

fn void gofl_update(Simulation game, char *api) {
    while (!raylib::window_should_close() && *api == 1)
    {
        game.update();

        raylib::begin_drawing();
            raylib::clear_background(background_color());
            raylib::draw_rectangle_lines(5, cst::BORDER.x, cst::BORDER.y, cst::BORDER.z, raylib::BLACK);

            game.draw();
            game_ui(&game);

        raylib::end_drawing();
        keyboard_actions(&game, api);
    }
}

fn void game_ui(Simulation* game) {
    raylib::draw_fps(raylib::get_screen_width() - 80, 10);

    foreach (idx, ui: cst::GUI_TEXTS_TITLE) center_draw_text(ui, CL_TEXTS_TITLE[idx]);
    foreach (idx, ui: cst::GUI_TEXTS_AC) center_draw_text(ui, CL_TEXTS_AC[idx], false);

    center_draw_text({"Raylib -> OpenGL", 112, cst::PDG_TOP-70, 16}, raylib::ORANGE, false);

    if (game.@isRunning()) {
        center_draw_text(cst::GUI_TEXTS_STATE[0], CL_TEXTS_STATE[0]);
    } else {
        center_draw_text(cst::GUI_TEXTS_STATE[1], CL_TEXTS_STATE[1]);
    }

    raylib::draw_text(string::new_format("%d", game.getLivingCells()), 120, cst::PDG_TOP-35, 20, raylib::GREEN);
}

fn void init(String title, char *api) @public
{
    raylib::init_window(cst::WTH, cst::HHT, title);
    defer raylib::close_window();

    raylib::set_target_fps(0);


    //Image logo = raylib::load_image("resources/img/c3golf.png");

    //raylib::set_window_icon(logo);
    //raylib::unload_image(logo);


    Grid game_grid = gofl_rylib::grid(cst::WTH, cst::HHT);
    // Game State: run | Living cells: l_cells | Grid 1/Grid 2: grid
    Simulation simulation = { .grid = game_grid };

    gofl_update(simulation, api);
}
