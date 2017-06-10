all:
	@mkdir -p Build
	@clang -c FTDI/ftdi.c Icestorm/iceprog.c
	@valac --pkg gtk+-3.0 -c Sources/*.vala
	@mv *.o Build/
	@clang `pkg-config --cflags gtk+-3.0` Build/*.o `pkg-config --libs gtk+-3.0` -lusb -o Malice
debug:
	@mkdir -p Build
	@clang -g -c FTDI/ftdi.c Icestorm/iceprog.c
	@valac --pkg gtk+-3.0 -gc Sources/*.vala
	@mv *.o Build/
	@clang `pkg-config --cflags gtk+-3.0` Build/*.o `pkg-config --libs gtk+-3.0` -lusb -o Malice
clean:
	@rm -rf Build
	@rm -f Malice
	@rm -f *.o
	@rm -f Resources/\#malice.glade\#
	@rm -f Resources/malice.glade\~