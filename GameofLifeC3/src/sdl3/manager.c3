module gofl_sdl3::system_sdl @local;

import sdl3;

import sdl3::event_type;
import sdl3::keycode;
import sdl3::subsystem;
import sdl3::windows_flags;

import cst;

const FRect BORDER = {5, cst::PDG_TOP-4, cst::WTH - cst::PDG_LR, cst::HHT - cst::PDG_TOP};

fn void init(ZString title, bool *api) @public
{
    if (sdl3::init(subsystem::VIDEO | subsystem::EVENTS) < 0) sdl3::log_error("sdl3 init failed: %s", sdl3::get_error());
    defer sdl3::quit();

    Window* window = sdl3::create_window(title, cst::WTH, cst::HHT, windows_flags::HIDDEN);

    Renderer* rendr = sdl3::create_renderer(window, null);
    sdl3::show_window(window);

    defer sdl3::destroy_window(window);
    defer sdl3::destroy_renderer(rendr);

    Event e;

    bool is_running = true; while (is_running && !*api)
    {
        if (sdl3::wait_event(&e))
        {
            if (e.type == event_type::QUIT || e.keyboard.key == keycode::SDLK_ESCAPE) is_running = false;
            if (e.keyboard.key == keycode::SDLK_TAB) *api = true;

        }

        // Logic

        sdl3::render_clear(rendr);

            sdl3::set_render_draw_color(rendr, 0, 0, 0, 255);
            sdl3::render_rect(rendr, &BORDER);

        // Background Color
        sdl3::set_render_draw_color(rendr, 10, 10, 10, 255);

        sdl3::render_present(rendr);
    }
}
