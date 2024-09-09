module gofl_rylib5::system_rl5 @local;

import cst_rl;
import gofl_simul;

import raylib5::rl;

import cst;

macro bool key_pressed($key) => rl::isKeyPressed($key);

/**
 * @require row >= 0, column >= 0
 **/
macro Table @get_grid_rc(int row, int column) => { row / cst::GRD_CELL_SIZE, column / cst::GRD_CELL_SIZE };
macro Color background_color() => rl::getColor(0x101010FF);

macro void center_draw_text(Text_opt args, Color color, bool align = true) =>
    rl::drawText(args.state, align? cst::CENTER_TEXT + args.r : args.r, args.g, args.b, color);


const Color COLOR_TEXT = rl::LIGHTGRAY;

const Color[2] CL_TEXTS_AC = { COLOR_TEXT, COLOR_TEXT };
const Color[3] CL_TEXTS_TITLE = { COLOR_TEXT, rl::GREEN, COLOR_TEXT };
const Color[2] CL_TEXTS_STATE = { rl::GREEN, rl::GRAY };


fn Table get_grid_mouse_pos() @inline {
    Vector2 mouse_position = rl::getMousePosition();

    return @get_grid_rc(
        (int)mouse_position.y - cst::PDG_TOP, (int)mouse_position.x
    );
}

fn void keyboard_actions(Simulation* game, char *api) {
    if (key_pressed(rl::KEY_ENTER) || key_pressed(rl::KEY_SPACE)) {|
        if (!game.run) {
            rl::setTargetFPS(12);
            game.start();

            return;
        }

        rl::setTargetFPS(120);
        game.stop();
    |};

    Table grid_hover_mouse = get_grid_mouse_pos();
    game.toggleCell(grid_hover_mouse, rl::isMouseButtonPressed(MouseButton.LEFT)? true:false, 1);
    game.toggleCell(grid_hover_mouse, rl::isMouseButtonPressed(MouseButton.RIGHT), 0);

    if (key_pressed(rl::KEY_F)) {
        game.createRandomState();
    } else if (rl::isKeyPressed(rl::KEY_G)) game.clearGrid();

    if (key_pressed(rl::KEY_TAB)) *api = 3;
}

fn void gofl_update(Simulation game, char *api) {
    while (!rl::windowShouldClose() && *api == 2)
    {
        game.update();

        rl::beginDrawing();
            rl::clearBackground(background_color());
            rl::drawRectangleLines(5, cst::BORDER.x, cst::BORDER.y, cst::BORDER.z, rl::BLACK);

            game.draw();
            game_ui(&game);

        rl::endDrawing();
        keyboard_actions(&game, api);
    }
}

fn void game_ui(Simulation* game) {
    rl::drawFPS(rl::getScreenWidth() - cst::PDG_TOP, cst::PDG_LR);

    foreach (idx, ui: cst::GUI_TEXTS_TITLE) center_draw_text(ui, CL_TEXTS_TITLE[idx]);
    foreach (idx, ui: cst::GUI_TEXTS_AC) center_draw_text(ui, CL_TEXTS_AC[idx], false);

    center_draw_text({"Raylib 5 -> OpenGL", 112, cst::PDG_TOP-70, 16}, rl::ORANGE, false);

    if (game.@isRunning()) {
        center_draw_text(cst::GUI_TEXTS_STATE[0], CL_TEXTS_STATE[0]);
    } else {
        center_draw_text(cst::GUI_TEXTS_STATE[1], CL_TEXTS_STATE[1]);
    }


    rl::drawText((ZString)string::new_format("%d", game.getLivingCells()), 120, cst::PDG_TOP-35, 20, rl::GREEN);
}

fn void init(String title, char *api) @public
{
    rl::initWindow(cst::WTH, cst::HHT, title);
    defer rl::closeWindow();

    rl::setTargetFPS(0);


    //Image logo = rl::loadImage("resources/img/c3golf.png");

    //rl::setWindowIcon(logo);
    //rl::unloadImage(logo);


    Grid game_grid = gofl_rylib5::grid(cst::WTH, cst::HHT);
    // Game State: run | Living cells: l_cells | Grid 1/Grid 2: grid
    Simulation simulation = { .grid = game_grid };

    gofl_update(simulation, api);
}
