all:
	@mkdir -p Build
	@mkdir -p Malice.AppDir/usr/
	@mkdir -p Malice.AppDir/usr/bin/
	@cc -O3 -std=c99 -c FTDI/ftdi.c Icestorm/iceprog.c
	@valac -X -O3 --pkg gtk+-3.0 -c Sources/*.vala
	@mv *.o Build/
	@cc -O3 `pkg-config --cflags gtk+-3.0` Build/*.o `pkg-config --libs gtk+-3.0` -lusb -o Malice.AppDir/usr/bin/Malice
	@appimagetool Malice.AppDir Malice.AppImage
debug:
	@mkdir -p Build
	@mkdir -p Malice.AppDir/usr/
	@mkdir -p Malice.AppDir/usr/bin/
	@cc -std=c99 -g -c FTDI/ftdi.c Icestorm/iceprog.c
	@valac --pkg gtk+-3.0 -gc Sources/*.vala
	@mv *.o Build/
	@cc `pkg-config --cflags gtk+-3.0` Build/*.o `pkg-config --libs gtk+-3.0` -lusb -o Malice.AppDir/usr/bin/Malice
	@appimagetool Malice.AppDir Malice.AppImage
clean:
	@rm -rf Build
	@rm -rf Malice.AppDir/usr
	@rm -f *.AppImage
	@rm -f *.o