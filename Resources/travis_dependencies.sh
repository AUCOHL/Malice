sudo apt-get update
sudo apt-get install --yes valac libgtk-3-dev libusb-dev fuse curl make
mkdir -p ~/bin/
curl -sL https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$(arch).AppImage > appimagetool-$(arch).AppImage
chmod a+x appimagetool-$(arch).AppImage
sudo cp appimagetool-$(arch).AppImage /usr/bin/appimagetool