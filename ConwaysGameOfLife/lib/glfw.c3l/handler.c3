module glfw;
import std::io;

EventHandler* handle;

struct EventHandler {
    double mouse_x_pos, mouse_y_pos,
    mouse_x_delta, mouse_y_delta,
    scrollY;

    bool scrolling,
    left_mouse_click, right_mouse_click;

    GLFWwindow window;
    KeyboardEvent on_keyboard_event;
    MouseEvent on_mouse_event;
    uint last_key;
}

fn void EventHandler.init(&self) {
    setMouseButtonCallback(self.window, (MouseCallback)&mouseEvents);
    setKeyCallback(self.window, (KeyCallback)&keyboardEvents);
    setScrollCallback(self.window, (ScrollCallback)&scrollEvents);

    handle = self;
}

fn void scrollEvents(GLFWwindow window, double xoffset, double yoffset) {
    handle.scrollY = yoffset;
    handle.scrolling = true;
}

fn void mouseEvents(GLFWwindow window, int button, int action, int mods) {
    // left mouse button action
    if (button == 0) {|
        if (action == 1) {
            handle.left_mouse_click = true;
            return;
        }

        handle.left_mouse_click = false;
    |};

    // right button
    if (button == 1) {|
        if (action == 1) {
            handle.right_mouse_click = true;
            return;
        }

        handle.right_mouse_click = false;
    |};
}

fn void keyboardEvents(GLFWwindow window, int key, int scancode, int action, int mods) =>
    handle.last_key = key;

fn void EventHandler.update(&self) {
    self.scrolling = false;

    glfw::pollEvents();
    double x_local, y_local;
    getCursorPos(self.window, &x_local, &y_local);

    self.mouse_x_delta = x_local - self.mouse_x_pos;
    self.mouse_y_delta = y_local - self.mouse_y_pos;

    self.mouse_x_pos = x_local;
    self.mouse_y_pos = y_local;
}
