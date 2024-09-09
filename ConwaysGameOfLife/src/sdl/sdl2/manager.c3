module gofl_sdl2::system_sdl2 @local;

import sdl;
import std::io;


fn void init(String title, char *api) @public
{
    if (sdl::init(sdl::INIT_VIDEO) < 0) sdl::logError(LOG_CATEGORY_APPLICATION, "Couldn't initialize SDL: %s\n", sdl::getError());
    defer sdl::quit();

    Window* window = sdl::createWindow(title, 1700, 900, 640, 500, (int)sdl::WINDOW_OPENGL);
    if (!window) sdl::logError(LOG_CATEGORY_APPLICATION, "Failed to open %d x %d window: %s\n", 800, 800, sdl::getError());

    sdl::setHint(sdl::HINT_RENDER_SCALE_QUALITY, "linear");

    Renderer* renderer = sdl::createRenderer(window, 0, (int)sdl::RENDERER_ACCELERATED);
    if (!renderer) sdl::logError(LOG_CATEGORY_APPLICATION, "Failed to create renderer: %s\n", sdl::getError());

    defer sdl::destroyWindow(window);
    defer sdl::destroyRenderer(renderer);

    Event e;
    sdl::pollEvent(&e);

    bool is_running = true; while (is_running && *api == 4)
    {
        if (sdl::waitEvent(&e)) {
            if (e.type == sdl::QUIT || e.key.keysym.mod == (ushort)sdl::SCANCODE_ESCAPE) is_running = false;
        }

        // Logic

        sdl::renderClear(renderer);

            //sdl2::set_render_draw_color(rendr, 0, 0, 0, 255);
            //sdl2::render_rect(renderer, &BORDER);

        // Background Color
        sdl::setRenderDrawColor(renderer, 10, 10, 10, 255);

        sdl::renderPresent(renderer);
        sdl::delay(16);
    }
}
