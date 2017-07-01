# Malice (Beta)
A simple interface for [iceprog](https://github.com/cliffordwolf/icestorm). Core is written in C, UI is written in Vala.

Supports the iCE40-HX8K Breakout Board and the iCEStick Evaluation Kit, so far.

# Dependencies
## Running
GTK+ 3.0 or higher. (Planning to statically link in macOS).

## Building
Make, GTK+ 3.0 or higher, Vala 0.36.3 or higher.

### macOS
Xcode is also needed.

# Usage
## Binaries
Right now, Linux AppImages are available under Releases for x86 and x86_64. Download the version corresponding to your architecture, mark it as executable (using either `chmod a+x *.AppImage` or from your file manager's properties) then (double-)click on the icon.

## From Source
Using your favorite terminal emulator:

```bash
    make
```

Either an .app or a .AppImage file (depending on your operating system) should appear in your root folder. Please note that a GTK installation is needed on macOS is as well.

## Windows
Coming soon.

# License
GNU General Public License v2 or (at your option), any later version. Check 'LICENSE'.