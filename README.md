# Malice (Beta)
A simple interface for [iceprog](https://github.com/cliffordwolf/icestorm). Core is written in C, UI is written in Vala.

Supports the iCE40-HX8K Breakout Board and the iCEStick Evaluation Kit, so far.

# Dependencies
## Running
GTK+ 3.0 or higher.

## Building
Make, GTK+ 3.0 or higher, Vala 0.36.3 or higher.

### macOS
Xcode is also needed, as well as [DylibBundler](https://github.com/auriamg/macdylibbundler).

# Usage
## Unix
Using your favorite terminal emulator:

```bash
    make unix
    ./Build/Malice
```

Mind you, the resources are location-sensitive if you use the application in this manner.

macOS is not supported in this manner because of how resources are handled in the .app file.

## Linux
Again, using your favorite terminal emulator:

```bash
    make appimage
```

Then double click Malice.AppImage. Technology is amazing sometimes.

## macOS
**WARNING: This version is extremely finicky and unsupported.**

### First Time Setup
You will need to do it every time the .xcodeproj changes, including when you first clone/download the repository. It is recommended that you do not commit your .xcodeproj by using `git reset Malice.xcodeproj/` before committing any changes.

On the terminal:
    
    make mac_libraries
    -I/usr/local/include > cflags.txt
    `pkg-config --cflags gtk+-3.0` > cflags.txt

In Xcode, manually change Build Settings > Other C Flags to the contents of cflags.txt.

Remove all dylibs from the project and readd the ones in Build/Libraries.

### App
On the terminal:

    make app

A Malice.app should appear in the root folder.

Unlike the Linux version, this is *not* portable. Well, actually: They're both quite the same, except most Linux-based OSes come with GTK+ and macOS doesn't, so on Linux it is portable and on macOS it is not

## Windows
Windows is not yet supported.

# License
GNU General Public License v2 or (at your option), any later version. Check 'LICENSE'.