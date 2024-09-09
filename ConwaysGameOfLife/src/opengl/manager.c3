module gofl_opengl::system_glfw;

import glfw;

import std::io;

macro void error_callback(String description) =>
    io::printn(description);

fn void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods) {
    if (key == glfw::KEY_ESCAPE && action == glfw::PRESS) glfw::setWindowShouldClose(window, glfw::GLFW_TRUE);
}

fn void init(String title, char *api) {
    GLFWwindow* window;

    if (!glfw::init()) error_callback("Error: GLFW not initialized!");
    defer glfw::terminate();

    glfw::windowHint(glfw::CONTEXT_VERSION_MAJOR, 2);
    glfw::windowHint(glfw::CONTEXT_VERSION_MINOR, 0);

    window = glfw::createWindow(800, 800, title, null, null);
    if (!window) error_callback("Error: Window not inicializate");
    defer glfw::destroyWindow(window);

    glfw::setKeyCallback(window, &key_callback);

    glfw::makeContextCurrent(window);
    glfw::swapInterval(1);

    while (!glfw::windowShouldClose(window) && *api == 5)
    {
        uint width, height;

        //glfw::getFramebufferSize(window, &width, &height);
        float ratio = width / (float) height;

        //glViewport(0, 0, width, height);
        //glClear(GL_COLOR_BUFFER_BIT);

        glfw::swapBuffers(window);
        glfw::pollEvents();
    }
}
