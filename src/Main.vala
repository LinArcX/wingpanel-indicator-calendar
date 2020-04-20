public class Calendar.Indicator : Wingpanel.Indicator {

    public static GLib.Settings settings ;

    private Gtk.Grid main_grid ;
    private Widgets.PanelLabel panel_label ;
    private GLib.DateTime dt { get ; set ; }
    private Gtk.Label lbl_ghamari { get ; set ; }
    private Gtk.Label lbl_georgian { get ; set ; }
    private Gtk.Label lbl_event { get ; set ; }
    private LibCalendar.SolarHijri calendar { get ; set ; }

    public Indicator () {
        Object (
            code_name: "wingpanel-indicator-calendar",
            description: "A wingpanel indicator to show calendar") ;
    }

    construct {
        visible = true ;
        settings = new GLib.Settings ("com.github.linarcx.wingpanel-indicator-calendar") ;
    }

    public override Gtk.Widget get_display_widget() {
        if( panel_label == null ){
            calendar = new LibCalendar.SolarHijri () ;
            panel_label = new Widgets.PanelLabel (calendar) ;
        }
        return panel_label ;
    }

    public override Gtk.Widget ? get_widget () {
        if( main_grid == null ){
            lbl_georgian = new Gtk.Label ("") ;
            lbl_ghamari = new Gtk.Label ("") ;
            lbl_event = new Gtk.Label ("") ;

            var pixbuf_georgian = new Gdk.Pixbuf.from_file_at_size ("/usr/share/icons/hicolor/scalable/apps/united-states.svg", 50, 30) ;
            var icon_georgian = new Gtk.Image.from_pixbuf (pixbuf_georgian) ;

            var pixbuf_ghamari = new Gdk.Pixbuf.from_file_at_size ("/usr/share/icons/hicolor/scalable/apps/saudi-arabia.svg", 50, 30) ;
            var icon_ghamari = new Gtk.Image.from_pixbuf (pixbuf_ghamari) ;

            lbl_georgian.halign = Gtk.Align.START ;
            lbl_georgian.set_justify (Gtk.Justification.LEFT) ;
            lbl_georgian.width_request = 80 ;
            // lbl_georgian.expand = true ;
            lbl_georgian.height_request = 30 ;
            lbl_ghamari.height_request = 30 ;
            lbl_event.height_request = 40 ;

            main_grid = new Gtk.Grid () ;
            main_grid.attach (lbl_georgian, 0, 0) ;
            main_grid.attach (icon_georgian, 1, 0) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 0, 1) ;
            main_grid.attach (lbl_ghamari, 0, 2) ;
            main_grid.attach (icon_ghamari, 1, 2) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 0, 3) ;
            main_grid.attach (lbl_event, 0, 4) ;
            main_grid.expand = true ;

            var scrolled_window = new Gtk.ScrolledWindow (null, null) ;
            scrolled_window.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC) ;
            scrolled_window.min_content_width = 100 ;
            scrolled_window.min_content_height = 200 ;
            scrolled_window.max_content_height = 500 ;
            scrolled_window.add (main_grid) ;

        }
        return main_grid ;
    }

    private void calculate_georgian_date() {
        lbl_georgian.set_label (dt.get_year ().to_string () + "  " +
                                dt.get_month ().to_string () + "  " +
                                dt.get_day_of_month ().to_string ()) ;
    }

    private void calculate_ghamari_date() {
        string output = "" ;
        int16 y = 0 ;
        uint8 m = 0 ;
        uint16 d = 0 ;

        calendar.gr_to_is ((int16) dt.get_year (),
                           (uint8) dt.get_month (),
                           (uint16) dt.get_day_of_month (),
                           ref y, ref m, ref d) ;
        lbl_ghamari.set_label (y.to_string () + "  " + m.to_string () + "  " + d.to_string ()) ;
    }

    public override void opened() {
        dt = new GLib.DateTime.now_local () ;
        calculate_georgian_date () ;
        calculate_ghamari_date () ;

        int random_number = Random.int_range (0, 100) ;
        lbl_event.set_label (random_number.to_string ()) ;
    }

    public override void closed() {
    }

}

public Wingpanel.Indicator get_indicator(Module module) {
    debug ("Activating Calendar Indicator") ;
    var indicator = new Calendar.Indicator () ;
    return indicator ;
}

// pixbuf = gtk.gdk.pixbuf_new_from_file ('/path/to/the/image.png') ;
// pixbuf = pixbuf.scale_simple (width, height, gtk.gdk.INTERP_BILINEAR) ;
// image = gtk.Image () ;
// image.set_from_pixbuf (pixbuf) ;
// image = gtk.image_new_from_pixbuf (pixbuf) ;


// pixbuf_georgian.scale_simple (2, 1, Gdk.InterpType.BILINEAR) ;
// var icon_ghamari = new Gtk.Image.from_file ("/usr/share/icons/hicolor/scalable/apps/saudi-arabia.svg") ;
// icon_georgian.set_size_request (5, 4) ;
// icon_georgian.icon_size = 7 ;
//// icon_ghamari.set_size_request (5, 4) ;
// icon_georgian.pixel_size = 8 ;
// icon_ghamari.pixel_size = 8 ;
