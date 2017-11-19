# ❄️ Malice
A GUI for [iceprog](https://github.com/cliffordwolf/icestorm) for Linux-based operating systems. Core is written in C, UI is written in Vala.

Officially, supports the iCE40-HX8K Breakout Board and the iCEStick Evaluation Kit.

# Dependencies
## Running
Ubuntu 14.04 or higher.

(Unofficially supported, but the AppImage seems to work on Ubuntu 12.04 too.

### First time setup
A first time elevated-privilege command is needed so users without superuser access can upload programs to the FPGA.

```bash
    echo "ACTION==\"add\", ATTR{idVendor}==\"0403\", ATTR{idProduct}==\"6010\", MODE:=\"666\"" | sudo tee /etc/udev/rules.d/53-lattice-ftdi.rules > /dev/null
```

This is a limitation with Linux's Lattice FTDI driver.

## Building
Make, GTK+ 3.0 or higher, Vala 0.36.3 or higher, pkg-config 0.29.2 or higher.

Ubuntu 14.04 or higher, macOS 10.9 or higher.

The actual building is as easy as `make`.

# Usage
The binary produced is an AppImage. Mark it as an executable (using either `chmod a+x *.AppImage` or from your file manager's properties) then (double-)click on the icon.

# on macOS
Try [this document](macOS.md).

# ⚖️ License
GNU General Public License v2 or (at your option), any later version. Check 'LICENSE'.
