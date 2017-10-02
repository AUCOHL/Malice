# Malice
A GUI for [iceprog](https://github.com/cliffordwolf/icestorm) for Linux-based operating systems. Core is written in C, UI is written in Vala.

Supports the iCE40-HX8K Breakout Board and the iCEStick Evaluation Kit so far.

# Dependencies
## Running
Ubuntu 14.04 or higher.

```bash
   # macOS
   which brew
   if [ "$?" == "1" ]; then
       /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
   fi
   brew install gtk+3
```

(Unofficially supported, but the AppImage seems to work on Ubuntu 12.04 too).

### First time setup on Linux
A first time elevated-privilege command is needed so users without superuser access can upload programs to the FPGA.

```bash
    echo "ACTION==\"add\", ATTR{idVendor}==\"0403\", ATTR{idProduct}==\"6010\", MODE:=\"666\"" | sudo tee /etc/udev/rules.d/53-lattice-ftdi.rules > /dev/null
```

This is a limitation with Linux's FTDI driver.

## Building
Make, GTK+ 3.0 or higher, Vala 0.36.3 or higher, pkg-config 0.29.2 or higher.

Ubuntu 14.04 or higher, macOS 10.9 or higher.

# Usage
## Binaries
Right now, Linux AppImages are available under Releases for x86 and x86_64. Download the version corresponding to your architecture, mark it as executable (using either `chmod a+x *.AppImage` or from your file manager's properties) then (double-)click on the icon.

## From Source
Using your favorite terminal emulator:

```bash
    make
```

An AppImage file should appear in your root folder.

# On macOS
Malice is limited on macOS as a result of how GTK is configured, so we are no longer committed to the macOS app, but will continue to update it within the constraints of GTK not working until we develop a better solution.

## Building
Xcode is needed as intermediate. Please do not build Malice from inside the Xcode IDE.

## First time setup
Short version: Download [D2XXHelper](http://www.ftdichip.com/Drivers/D2XX/MacOSX/D2xxHelper_v2.0.0.pkg) from FTDI's website, which is needed driver. Please not that your use of the driver is subject to FTDI's license terms and not ours.

Long version:

Since OS X 10.9 Mavericks, [Apple introduced an FTDI kernel extension](https://developer.apple.com/library/content/technotes/tn2315/_index.html#//apple_ref/doc/uid/DTS40014014-CH1-TNTAG3) that makes user client driver-based apps, such as Malice, unable to obtain exclusive access to the device unless the kernel extension is unloaded or replaced with a codeless kernel extension with a higher priority that would not block exclusive access.

Luckily, FTDI themselves have provided the [codeless kernel extension](http://www.ftdichip.com/Drivers/D2XX.htm) that would override Apple's and allow Malice to work (you should find it in the row that says 'Mac OS X 10.4 Tiger or later'). The driver is under a proprietary license, but the alternative would be to unload the kext every time or delete it and Apple's driver is proprietary anyway. Please note libftdi does not link against the non-system driver and thus the GPL's integrity is preserved.

# License
GNU General Public License v2 or (at your option), any later version. Check 'LICENSE'.
