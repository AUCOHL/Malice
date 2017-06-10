using Gtk;

class FPGABoard
{
    public string name;
    public bool sramSupported;
    public string? message;

    public FPGABoard(string name, bool sramSupported, string? message)
    {
        this.name = name;
        this.sramSupported = sramSupported;
        this.message = message;
    }

    public static FPGABoard[] boards;
}

extern int iceprog_check_programmer();

struct Malice
{
    Spinner ftdispinner;
    Image ftdistatus;
    Label ftdimessage;
    Button ftdirefresh;
    FileChooserButton filechooser;
    ComboBoxText boardselector;
    CheckButton flashoption;
    Button programbutton;
    Label messagelabel;
}
Malice malice_elements;

async void check_programmer()
{
    malice_elements.ftdistatus.hide();
    malice_elements.ftdispinner.show();
    malice_elements.ftdirefresh.hide();
    malice_elements.ftdimessage.label = "Looking for an FTDI chip...";
    malice_elements.filechooser.sensitive = false;
    malice_elements.boardselector.sensitive = false;
    malice_elements.flashoption.sensitive = false;
    malice_elements.programbutton.sensitive = false;
    malice_elements.messagelabel.label = "";

    if (iceprog_check_programmer() == 0)
    {
        malice_elements.ftdistatus.stock = "gtk-apply";
        malice_elements.ftdimessage.label = "Device detected.";
        malice_elements.boardselector.sensitive = true;
    }
    else
    {
        malice_elements.ftdistatus.stock = "gtk-cancel";
        malice_elements.ftdimessage.label = "Failed to detect device.";
    }
    
    malice_elements.ftdistatus.show();
    malice_elements.ftdispinner.hide();
    malice_elements.ftdirefresh.show();
}

int main (string[] args)
{
    Gtk.init (ref args);

    //Load XML
    var builder = new Builder();
    try
    {
        builder.add_from_file("Resources/malice.glade");
    }
    catch (Error e)
    {
        stderr.printf("Fatal: Could not load UI file: %s. Malice will now quit.", e.message);
        return -1;
    }

    //Load Window and Icon
    var window = builder.get_object("main") as Window;
    try
    {
        window.icon = new Gdk.Pixbuf.from_file("Resources/icon.png");
    }
    catch (Error e)
    {
        stderr.printf("Error: Could not load application icon: %s\n", e.message);
    }

    malice_elements.ftdispinner = builder.get_object("ftdispinner") as Spinner;
    malice_elements.ftdistatus = builder.get_object("ftdistatus") as Image;
    malice_elements.ftdimessage  = builder.get_object("ftdimessage") as Label;
    malice_elements.ftdirefresh = builder.get_object("ftdirefresh") as Button;
    malice_elements.boardselector = builder.get_object("boardselector") as ComboBoxText;
    malice_elements.filechooser = builder.get_object("filechooser") as FileChooserButton;
    malice_elements.flashoption = builder.get_object("flashoption") as CheckButton;
    malice_elements.programbutton = builder.get_object("programbutton") as Button;
    malice_elements.messagelabel = builder.get_object("messagelabel") as Label;

    window.show_all();
    window.destroy.connect(Gtk.main_quit);

    //UI
    FPGABoard.boards = 
    {
        new FPGABoard("iCEStick Evaluation Kit", false, "An unmodified iCEStick does not support SRAM programming. A faulty flash program may render the device inoperable."),
        new FPGABoard("iCE40-HX8K Breakout Board", true, "Jumper configuration is needed to switch between SRAM-based programming and SPI flash programming. Check your user manual."),
        new FPGABoard("iCEStick Evaluation Kit (Modified)", false, null)
    };

    for (var i = 0; i < FPGABoard.boards.length; i++)
    {
        malice_elements.boardselector.append_text(FPGABoard.boards[i].name);
    }



    //Routine End
    builder.connect_signals(null);
    malice_elements.ftdirefresh.clicked.connect(check_programmer);

    //Asynchronous Tasks
    check_programmer.begin(
        (obj, res) =>
        {
            check_programmer.end(res);
        }
    );

    //End
    Gtk.main();
    return 0;
}
