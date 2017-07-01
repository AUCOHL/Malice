ARCH=$(shell uname -i)

ifeq ($(OS),Windows_NT)
all:
	@echo Unsupported OS.
else
ifeq ($(shell uname),Darwin)
all: app
else
ifeq ($(shell uname),Linux)
all: appimage
else
all:
	@echo Unsupported OS.
endif
endif
endif

unix:
	@mkdir -p Build
	@valac -C --pkg gtk+-3.0 Sources/Malice.vala
	@cc -O3 `pkg-config --cflags gtk+-3.0` -std=c99 FTDI/ftdi.c Icestorm/iceprog.c Sources/*.c `pkg-config --libs gtk+-3.0` -lusb -o Build/Malice
appimage: unix
	@mkdir -p Malice.AppDir
	@mkdir -p Malice.AppDir/usr/
	@mkdir -p Malice.AppDir/usr/bin/
	@mkdir -p Malice.AppDir/Resources/
	@cp Build/Malice Malice.AppDir/usr/bin/Malice
	@cp Resources/AppRun Malice.AppDir/
	@cp Resources/Malice.svg Malice.AppDir/
	@cp Resources/Malice.desktop Malice.AppDir/
	@cp Resources/Malice.glade Malice.AppDir/Resources/
	@cp Resources/Malice.svg Malice.AppDir/Resources/
	@appimagetool Malice.AppDir Malice_${ARCH}.AppImage
	@rm -rf Malice.AppDir
app: unix
	@xcodebuild
	@cp -r Build/Release/Malice.app/ Malice.app/
	@rm -rf Malice.app/Contents/_CodeSignature
	@mkdir -p Malice.app/Contents/usr/
	@mkdir -p Malice.app/Contents/usr/bin/
	@cp Build/Malice Malice.app/Contents/usr/bin/Malice
clean:
	@rm -rf Build
	@rm -rf DerivedData
	@rm -rf Malice.AppDir/
	@rm -rf Malice.app
	@rm -f Sources/Malice.c
	@rm -f *.AppImage