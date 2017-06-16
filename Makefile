VALAFLAGS = --pkg gtk+-3.0
ifeq ($(shell uname),Darwin)
	VALAFLAGS += -D __APPLE__
endif

all:
	@echo make unix, make appimage or make app
base:
	@mkdir -p Build
	@valac -C --pkg gtk+-3.0 Sources/Malice.vala
unix: base
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
	@appimagetool Malice.AppDir Malice.AppImage
	@rm -rf Malice.AppDir
mac_libraries: base
	@valac -C -D __APPLE__ --pkg gtk+-3.0 Sources/Malice.vala
	@cc -O3 `pkg-config --cflags gtk+-3.0` -std=c99 FTDI/ftdi.c Icestorm/iceprog.c Sources/*.c `pkg-config --libs gtk+-3.0` -lusb -o Build/Malice
	@mkdir -p Build/Libraries/
	@rm -f Build/Libraries/*
	@cp `otool -L Build/Malice | grep -o '/usr/local/opt/[^\\(]*'` Build/Libraries/
app: mac_libraries
	@xcodebuild
	@dylibbundler -od -b -x Build/Release/Malice.app/Contents/MacOS/Malice -d Build/Release/Malice.app/Contents/libs/ &> /dev/null
	@cp -r Build/Release/Malice.app/ Malice.app/
clean:
	@rm -rf Build
	@rm -rf DerivedData
	@rm -rf Malice.AppDir/
	@rm -rf Malice.app
	@echo '' > Sources/Malice.c
	@rm -f *.AppImage