using Gtk;

enum ProgrammingOptions
{
    SRAM = 0,
    SPIFlash,
    Both
}

class FPGABoard
{
    public string name;
    public ProgrammingOptions po;
    public string? message;

    public FPGABoard(string name, ProgrammingOptions po, string? message)
    {
        this.name = name;
        this.po = po;
        this.message = message;
    }

    public static FPGABoard[] boards;
}

extern int iceprog_check_programmer();
extern char * iceprog_program(bool prog_sram, char * filename);

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
Mutex ui_mutex;

async void program()
{
    ui_mutex.lock();
    var error = iceprog_program(!(malice_elements.flashoption.active), malice_elements.filechooser.get_filename());
    if (error != null)
    {
        var errorString = (string)error;
        malice_elements.messagelabel.label = errorString;
    }
    else
    {
        malice_elements.messagelabel.label = "Succeeded.";
    }

    malice_elements.programbutton.sensitive = true;
    malice_elements.programbutton.label = "Program";
    ui_mutex.unlock();
}

async void check_board()
{
    ui_mutex.lock();
    var board = malice_elements.boardselector.active - 1;
    if (board < 0)
    {
        malice_elements.filechooser.sensitive = false;
        malice_elements.flashoption.sensitive = false;
        malice_elements.programbutton.sensitive = false;
        malice_elements.messagelabel.label = "";
        ui_mutex.unlock();
        return;
    }
    malice_elements.filechooser.sensitive = true;
    
    if (FPGABoard.boards[board].po == ProgrammingOptions.SPIFlash)
    {
        malice_elements.flashoption.active = true;
        malice_elements.flashoption.sensitive = false;
    }
    else if (FPGABoard.boards[board].po == ProgrammingOptions.SRAM)
    {
        malice_elements.flashoption.active = false;
        malice_elements.flashoption.sensitive = false;
    }
    else
    {
        malice_elements.flashoption.sensitive = true;
    }

    if (FPGABoard.boards[board].message != null)
    {
        malice_elements.messagelabel.label = FPGABoard.boards[board].message;
    }
    else
    {
        malice_elements.messagelabel.label = "";                
    }
    ui_mutex.unlock();
}

async void check_programmer()
{
    ui_mutex.lock();
    malice_elements.ftdistatus.visible = false;
    malice_elements.ftdispinner.visible = true;
    malice_elements.ftdirefresh.visible = false;
    malice_elements.ftdimessage.label = "Looking for an FTDI chip...";
    malice_elements.boardselector.sensitive = false;

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
    
    malice_elements.ftdistatus.visible = true;
    malice_elements.ftdispinner.visible = false;
    malice_elements.ftdirefresh.visible = true;
    ui_mutex.unlock();
    check_board();
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

    builder.connect_signals(null);
    window.show_all();
    
    //Connections
    window.destroy.connect(Gtk.main_quit);    
    malice_elements.ftdirefresh.clicked.connect(check_programmer);
    malice_elements.boardselector.changed.connect(check_board);

    //TO-DO: File Filters
    malice_elements.filechooser.selection_changed.connect(
        () =>
        {
            var chosen = (malice_elements.filechooser.get_filename() != null);

            if (chosen)
            {
                malice_elements.programbutton.sensitive = true;
            }
            else
            {
                malice_elements.programbutton.sensitive = false;
            }
        }
    );
    malice_elements.programbutton.clicked.connect(
        () =>
        {
            ui_mutex.lock();
            malice_elements.programbutton.sensitive = false;
            malice_elements.programbutton.label = "Programming...";
            ui_mutex.unlock();

            program.begin(
                (obj, res) =>
                {
                    program.end(res);
                }
            );
        }
    );

    //UI
    FPGABoard.boards = 
    {
        new FPGABoard("iCEStick Evaluation Kit", ProgrammingOptions.SPIFlash, "An unmodified iCEStick does not support SRAM programming. A faulty flash program may render the device inoperable."),
        new FPGABoard("iCE40-HX8K Breakout Board", ProgrammingOptions.Both, "Jumper configuration is needed to switch between SRAM-based programming and SPI flash programming. Check your user manual."),
        new FPGABoard("Other", ProgrammingOptions.Both, "(Note: Picking an unavailable option may render a device inoperable.)")
    };

    for (var i = 0; i < FPGABoard.boards.length; i++)
    {
        malice_elements.boardselector.append_text(FPGABoard.boards[i].name);
    }

    //Asynchronous Tasks
    ui_mutex = Mutex();
    check_programmer.begin(
        (obj, res) =>
        {
            check_programmer.end(res);
        }
    );

    //End
    window.show();
    Gtk.main();
    return 0;
}
