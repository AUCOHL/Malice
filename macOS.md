# On macOS
Malice is limited on macOS as a result of how GTK is configured, so we are no longer committed to the macOS app, but will continue to update it within the constraints of GTK not working until we develop a better solution.

## Dependencies
```bash
   # macOS
   which brew
   if [ "$?" == "1" ]; then
       /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
   fi
   brew install gtk+3
```

## Building
Xcode is needed as intermediate. Please do not build Malice from inside the Xcode IDE.

## First time setup
Short version: Download [D2XXHelper](http://www.ftdichip.com/Drivers/D2XX/MacOSX/D2xxHelper_v2.0.0.pkg) from FTDI's website, which is a needed driver. Please not that your use of the driver is subject to FTDI's license terms and not ours.

Long version:

Since OS X 10.9 Mavericks, [Apple introduced an FTDI kernel extension](https://developer.apple.com/library/content/technotes/tn2315/_index.html#//apple_ref/doc/uid/DTS40014014-CH1-TNTAG3) that makes user client driver-based apps, such as Malice, unable to obtain exclusive access to the device unless the kernel extension is unloaded or replaced with a codeless kernel extension with a higher priority that would not block exclusive access.

Luckily, FTDI themselves have provided the [codeless kernel extension](http://www.ftdichip.com/Drivers/D2XX.htm) that would override Apple's and allow Malice to work (you should find it in the row that says 'Mac OS X 10.4 Tiger or later'). The driver is under a proprietary license, but the alternative would be to unload the kext every time or delete it and Apple's driver is proprietary anyway. Please note libftdi does not link against the non-system driver and thus the GPL's integrity is preserved.

