# Malice (Beta)
A simple interface for [iceprog](https://github.com/cliffordwolf/icestorm). Core is written in C, UI is written in Vala.

Supports the iCE40-HX8K Breakout Board and the iCEStick Evaluation Kit, so far.

# Dependencies
## Running
GTK+ 3.0 or higher. (Planning to statically link on macOS).

### First time setup on Linux
A first time elevated-privilege command is needed so users without superuser access can upload programs to the FPGA.

```bash
    echo "ACTION==\"add\", ATTR{idVendor}==\"0403\", ATTR{idProduct}==\"6010\", MODE:=\"666\"" | sudo tee /etc/udev/rules.d/53-lattice-ftdi.rules > /dev/null
```

This is a limitation with Linux's FTDI driver.

### First time setup on macOS
Since OS X 10.9 Mavericks, [Apple introduced an FTDI kernel extension](https://developer.apple.com/library/content/technotes/tn2315/_index.html#//apple_ref/doc/uid/DTS40014014-CH1-TNTAG3) that makes user client driver-based apps, such as Malice, unable to obtain exclusive access to the device unless the kernel extension is unloaded or replaced with a codeless kernel extension with a higher priority.

This is a solution but, like Linux, it requires sudo.

```bash
    curl -s https://raw.githubusercontent.com/Skyus/Malice/master/Resources/io.cloudv.Malice.ftdidaemon.plist | sudo tee /Library/LaunchDaemons/io.cloudv.Malice.ftdidaemon.plist > /dev/null
```

Fortunately, unlike Linux, there is another solution that would help keep this as portable as possible: either rewrite iceprog for Apple IOKit or write an interface for wrapper IOKit based on libftdi. Either would be a tall order at the moment unfortunately.

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

Either an app or an AppImage file (depending on your operating system) should appear in your root folder.

### macOS Notes
Please note that a GTK installation is needed on macOS is as well. Do not open the Xcode UI as it is just part of a bigger workflow in the Makefile: the binary Xcode produces is only a bootstrap.

## Windows
Coming soon.

# License
GNU General Public License v2 or (at your option), any later version. Check 'LICENSE'.