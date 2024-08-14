module gameoflifec3;

import raylib;
import raylib::keyboard;

macro int[<2>] @get_grid_rc(int row, int column, $size) => { row / $size, column / $size };
fn Color background_color() => raylib::get_color(0x101010FF);

fn void keyboard_actions(Simulation* game) {
    if (raylib::is_key_pressed(keyboard::ENTER) || raylib::is_key_pressed(keyboard::SPACE)) {|
        if (!game.run) {
            game.start();

            return;
        }

        game.stop();
    |};

    Vector2 mouse_position = raylib::get_mouse_position();
    int[<2>] grid_hover_mouse = @get_grid_rc(
        (int)mouse_position.y - PDG_TOP,
        (int)mouse_position.x - PDG_LR, GRD_CELL_SIZE
    );

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
            raylib::draw_rectangle_lines(5, PDG_TOP-4, 800, HHT-PDG_TOP, raylib::BLACK);

            game.draw();
            game_ui(&game);

        raylib::end_drawing();
        keyboard_actions(&game);
    }
}

fn void game_ui(Simulation* game) {
    Color color_text = raylib::LIGHTGRAY;

    center_draw_text("The Game Of", -5, 18, 20, color_text);
    center_draw_text("LIFE!", 133, 18, 20, raylib::GREEN);

    center_draw_text("Game:", 40, 55, 24, color_text);

    if (game.isRunning()) {
        center_draw_text("On", 110, 55, 24, raylib::GREEN);
    } else {
        center_draw_text("Off", 110, 55, 24, raylib::GRAY);
    }

    raylib::draw_fps(raylib::get_screen_width() - 80, 10);

    raylib::draw_text("Living cells:", 20, PDG_TOP-35, 19, color_text);
    raylib::draw_text(string::new_format("%d", game.getLivingCells()), 120, PDG_TOP-35, 20, raylib::GREEN);
}

fn void main()
{
    raylib::init_window(WTH, HHT, TTBN);
    defer raylib::close_window();

    raylib::set_target_fps(12);

    Image logo = raylib::load_image("resources/img/c3golf.png");

    raylib::set_window_icon(logo);
    raylib::unload_image(logo);

    // Game State | Living cells | Grid 1/Grid 2
    Simulation simulation = { false, 0, grid(WTH, HHT), grid(WTH, HHT) };

    gofl_update(simulation);
}

