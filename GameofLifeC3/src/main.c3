module game;

import raylib;
import raylib::keyboard;

import gofl;


macro Table @get_grid_rc(float row, float column, #size) => { (short)row / #size, (short)column / #size };
fn Color background_color() => raylib::get_color(0x101010FF);

fn Table get_grid_mouse_pos() {
    Vector2 mouse_position = raylib::get_mouse_position();

    return @get_grid_rc(
        mouse_position.y - gofl::PDG_TOP,
        mouse_position.x - gofl::PDG_LR, gofl::GRD_CELL_SIZE
    );
}

fn void keyboard_actions(Simulation* game) {
    if (raylib::is_key_pressed(keyboard::ENTER) || raylib::is_key_pressed(keyboard::SPACE)) {|
        if (!game.run) {
            game.start();

            return;
        }

        game.stop();
    |};

    Table grid_hover_mouse = get_grid_mouse_pos();
    if (raylib::is_mouse_button_down(MouseButton.BUTTON_LEFT)) {
        game.toggleCell(grid_hover_mouse);
    } else {
        game.hoverCell(grid_hover_mouse);
    }

    if (raylib::is_key_pressed(keyboard::F)) {
        game.createRandomState();
    } else if (raylib::is_key_pressed(keyboard::G)) {
        game.clearGrid();
    }
}

fn void gofl_update(Simulation game) {
    while (!raylib::window_should_close())
    {
        game.update();

        raylib::begin_drawing();
            raylib::clear_background(background_color());
            raylib::draw_rectangle_lines(5, gofl::PDG_TOP-4, 800, gofl::HHT-gofl::PDG_TOP, raylib::BLACK);

            game.draw();
            game_ui(&game);

        raylib::end_drawing();
        keyboard_actions(&game);
    }
}

fn void game_ui(Simulation* game) {
    Color color_text = raylib::LIGHTGRAY;

    gofl::center_draw_text("The Game Of", -5, 18, 20, color_text);
    gofl::center_draw_text("LIFE!", 133, 18, 20, raylib::GREEN);

    gofl::center_draw_text("Game:", 40, 55, 24, color_text);

    if (game.isRunning()) {
        gofl::center_draw_text("On", 110, 55, 24, raylib::GREEN);
    } else {
        gofl::center_draw_text("Off", 110, 55, 24, raylib::GRAY);
    }

    raylib::draw_fps(raylib::get_screen_width() - 80, 10);

    raylib::draw_text("Living cells:", 20, gofl::PDG_TOP-35, 19, color_text);
    raylib::draw_text(string::new_format("%d", game.getLivingCells()), 120, gofl::PDG_TOP-35, 20, raylib::GREEN);
}

fn void main()
{
    raylib::init_window(gofl::WTH, gofl::HHT, gofl::TTBN);
    defer raylib::close_window();

    raylib::set_target_fps(12);

    Image logo = raylib::load_image("resources/img/c3golf.png");

    raylib::set_window_icon(logo);
    raylib::unload_image(logo);

    Grid game_grid = gofl::grid(gofl::WTH, gofl::HHT);
    // Game State: run | Living cells: l_cells | Grid 1/Grid 2: grid
    Simulation simulation = { .grid = game_grid };

    gofl_update(simulation);
}

