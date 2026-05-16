# ABG UI Library

---

ABG UI Library is a small personal C UI helper library built around Raylib.

This module is part of the larger ABG C library ecosystem and is meant to provide lightweight UI primitives, layout helpers, drawing utilities, and drawing wrappers for personal C/Raylib projects.

The current version focuses on simple UI building blocks such as buttons, panels, windows, rectangle movement, rectangle insetting, point collision checks, and Raylib-compatible drawing helpers.

This project is intentionally simple and is meant to be easy to build, inspect, and expand.

---

## Table of Contents

- [Project Structure](#project-structure)
- [Important Folders](#important-folders)
- [Headers](#headers)
- [Build Output](#build-output)
- [Build Requirements](#build-requirements)
- [Raylib Dependency](#raylib-dependency)
- [Building with Make](#building-with-make)
- [Installing on Linux / WSL](#installing-on-linux--wsl)
- [Testing Install](#testing-install)
- [Using ABG UI in Other Projects](#using-abg-ui-in-other-projects)
- [Linker Flag](#linker-flag)
- [Example Usage](#example-usage)
- [Cleaning Build Files](#cleaning-build-files)
- [Notes](#notes)

---

## Project Structure

```txt
abg-ui/
├── Makefile
├── include/
│   └── abg_ui.h
├── src/
│   └── abg_ui.c
└── build/
    ├── abg_ui.o
    └── libabg_ui.a
```

## Important Folders
```
| Folder     | Purpose                |
| :--------- | :--------------------- |
| `include/` | Public header files    |
| `src/`     | C source files         |
| `build/`   | Generated build output |
```

## Headers
The public header for this library is:
```C
#include "abg_ui.h"
```

The current API provides the following basic UI/data types:
```
ABG_Rect
ABG_Color
ABG_Window
ABG_Panel
ABG_Button
```

Also provides helpers for:
```
Rectangle collision checks
Rectangle insetting
Rectangle movement
Rectangle creation
Converting ABG_Rect to Raylib Rectangle
Drawing filled rectangles
Drawing rectangle outlines
```

## Build Output
This project builds into a static library archive:
```
libabg_ui.a
```
Default output:
```
build/abg_ui.a
```
Theh static library contains the compiled object files:
```
build/abg_ui.o
```

## Build Requirements
You will need a C compiler and basic build tools.

### For Linux / WSL

Install build tools:

```Bash
sudo apt update
sudo apt install build-essential
```

This gives access to:
```
gcc
make
ar
```
- `gcc` is the GNU C compiler.
- `make` controls the build process.
- `ar` creates the static library archive.


## Raylib Dependency

ABG UI uses Raylib as the renderer.

The public header include Raylib:
```C
#include "raylib.h"
```

The implementation also calls Raylib drawing functions such as;
```C
DrawRectangleRec(...)
DrawRectangleLines(...)
```

## Building with Make
From the project root:
```Bash
make
```
This builds:
```Bash
build/libabg-ui.a
```
To rebuild from scratch:
```Bash
make rebuild
```
To clean generated files:
```Bash
make clean
```

## Installing on Linux / WSL
After building the library, it can be installed into the Linux system paths.

From project root:
```Bash
sudo make install
```
This copies the puclib header to:
```
usr/local/include/
```
And the static library to:
```
usr/local/lib
```
Installed files:
```
/usr/local/include/abg_ui.h
/usr/local/include/abg_ui.a
```
To uninstall:
```
sudo make uninstall
```
This removes:
```
/usr/local/include/abg_ui.h
/usr/local/include/abg_ui.a
```

## Testing Install

To verify installation, check if the files exist:
```Bash
ls -l /usr/local/include/abg_ui.h
ls -l /usr/local/lib/libabg_ui.a
```
Create a temporary test directory:
```Bash
mkdir -p /tmp/abg-ui-install-test
cd /tmp/abg-ui-install-test
```
Create a test file
```Bash
nano test.c
```
Add:
```C
#include <raylib.h>
#include "abg_ui.h"

int main(void) {
    InitWindow(800, 450, "ABG UI Test");
    SetTargetFPS(60);

    ABG_Rect panel = ABG_RectFromSize(100, 100, 300, 150);
    ABG_Rect inner = ABG_RectInset(panel, 12);

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        ABG_DrawRect(panel, LIGHTGRAY);
        ABG_DrawRectLines(panel, DARKGRAY);
        ABG_DrawRect(inner, SKYBLUE);

        EndDrawing();
    }

    CloseWindow();

    return 0;
}
```
Compile:
```Bash
gcc test.c -labg_ui -lraylib -o test
```
Run:
```Bash
./test
```
## Using ABG UI in Other Projects
After installing, another Raylib/C project can use:
```C
#include "abg_ui.h"
```
Example:
```C
#include <raylib.h>
#include "abg_ui.h"

#define SCREEN_W 900
#define SCREEN_H 600

int main(void) {
    InitWindow(SCREEN_W, SCREEN_H, "ABG UI Example");
    SetTargetFPS(60);

    ABG_Rect button = ABG_RectFromSize(300, 250, 200, 50);

    while (!WindowShouldClose()) {
        Vector2 mouse = GetMousePosition();
        bool hovered = ABG_RectContainsPoint(button, mouse.x, mouse.y);

        BeginDrawing();
        ClearBackground(RAYWHITE);

        ABG_DrawRect(button, hovered ? SKYBLUE : LIGHTGRAY);
        ABG_DrawRectLines(button, DARKGRAY);
        DrawText("Button", (int)button.x + 65, (int)button.y + 16, 20, BLACK);

        EndDrawing();
    }

    CloseWindow();

    return 0;
}
```
Compile:
```Bash
gcc main.c -labg_ui -lraylib -o main
```
## Linker Flas
The linker flag for this library is:
```Bash
-labg_ui
```
Because ABG UI depends on Raylib, most project should link both:
```Bash
-labg_ui -lraylib
```
Depending on how Raylib was installed, additional library linker flags may be required:
```Bash
-lGL -lm -lpthread -ldl -lrt -lX11
```
If the library is not installed globally, pass the local include and library paths manually:
```Bash
gcc main.c -I/path/to/abg-ui/include -L/path/to/abg-ui/build -labg_ui -lraylib -o main
```
Example using a local clone next to your project:
```Bash
gcc main.c -I../abg-ui/include -L../abg-ui/build -labg_ui -lraylib -o main
```
## Notes

This library is currently a small learning project and will continue to be developed.

The main goal of abg-ui is to provide simple, reusable UI helpers for C/Raylib projects without hiding too much behavior behind a large framework.

The current API is intentionally minimal. It is designed to support small games, prototypes, tools, menus, sliders, panels, buttons, and future UI components.

Future versions may add more complete widgets such as:
```
Buttons
Sliders
Panels
Windows
Text input
Checkboxes
Dropdowns
Layout helpers
Theme/style helpers
```


## License
The project is for educational and demonstration purposes. Feel free to use, modify, and distribute the code as you wish.