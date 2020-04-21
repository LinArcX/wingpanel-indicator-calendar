public class Calendar.Indicator : Wingpanel.Indicator {

    public static GLib.Settings settings ;

    private Gtk.Grid main_grid ;
    private Widgets.PanelLabel panel_label ;
    private GLib.DateTime dt { get ; set ; }
    private Gtk.Label lbl_ghamari { get ; set ; }
    private Gtk.Label lbl_georgian { get ; set ; }
    private LibCalendar.SolarHijri calendar { get ; set ; }
    private LibCalendar.JsonParser _json_parser { get ; set ; }

    private Gtk.Label lbl_persian_solar_event { get ; set ; }
    private Gtk.Label lbl_persian_lonar_event { get ; set ; }
    private Gtk.Label lbl_persian_national_event { get ; set ; }
    private Gtk.Label lbl_persian_personage_event { get ; set ; }

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
            _json_parser = new LibCalendar.JsonParser () ;
            panel_label = new Widgets.PanelLabel (calendar) ;
        }
        return panel_label ;
    }

    public override Gtk.Widget ? get_widget () {
        if( main_grid == null ){
            lbl_georgian = new Gtk.Label ("") ;
            lbl_ghamari = new Gtk.Label ("") ;
            lbl_georgian.expand = true ;
            lbl_georgian.height_request = 30 ;
            lbl_ghamari.height_request = 30 ;

            var pixbuf_georgian = new Gdk.Pixbuf.from_file_at_size ("/usr/share/icons/hicolor/scalable/apps/united-states.svg", 50, 30) ;
            var icon_georgian = new Gtk.Image.from_pixbuf (pixbuf_georgian) ;
            icon_georgian.margin_right = 10 ;

            var pixbuf_ghamari = new Gdk.Pixbuf.from_file_at_size ("/usr/share/icons/hicolor/scalable/apps/saudi-arabia.svg", 50, 30) ;
            var icon_ghamari = new Gtk.Image.from_pixbuf (pixbuf_ghamari) ;
            icon_ghamari.margin_right = 10 ;

            lbl_persian_solar_event = new Gtk.Label ("There's no solar event!") ;
            lbl_persian_lonar_event = new Gtk.Label ("There's no lonar event!") ;
            lbl_persian_national_event = new Gtk.Label ("There's no national event!") ;
            lbl_persian_personage_event = new Gtk.Label ("There's no personage event!") ;
            lbl_persian_solar_event.height_request = 40 ;
            lbl_persian_lonar_event.height_request = 40 ;
            lbl_persian_national_event.height_request = 40 ;
            lbl_persian_personage_event.height_request = 40 ;

            main_grid = new Gtk.Grid () ;
            main_grid.attach (lbl_georgian, 0, 0) ;
            main_grid.attach (icon_georgian, 1, 0) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 0, 1) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 1, 1) ;

            main_grid.attach (lbl_ghamari, 0, 2) ;
            main_grid.attach (icon_ghamari, 1, 2) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 0, 3) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 1, 3) ;

            main_grid.attach (lbl_persian_solar_event, 0, 4) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 0, 5) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 1, 5) ;

            main_grid.attach (lbl_persian_lonar_event, 0, 6) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 0, 7) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 1, 7) ;

            main_grid.attach (lbl_persian_national_event, 0, 8) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 0, 9) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 1, 9) ;

            main_grid.attach (lbl_persian_personage_event, 0, 10) ;
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
        lbl_georgian.set_label (dt.get_day_of_month ().to_string () + "  " +
                                calendar.get_georgian_month_name (dt.get_month ()) + "  " +
                                dt.get_year ().to_string ()) ;
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
        lbl_ghamari.set_label (d.to_string () + "  " + calendar.get_islamic_month_name (m) + "  " + y.to_string ()) ;
    }

    private void show_persian_solar_events() {
        int16 y = 0 ;
        uint8 m = 0 ;
        uint16 d = 0 ;
        calendar.gr_to_sh ((int16) dt.get_year (),
                           (uint8) dt.get_month (),
                           (uint16) dt.get_day_of_month (),
                           ref y, ref m, ref d) ;
        lbl_persian_solar_event.set_label (_json_parser.get_persian_solar_events (m, d)) ;
    }

    private void show_persian_lonar_events() {
        int16 y = 0 ;
        uint8 m = 0 ;
        uint16 d = 0 ;
        calendar.gr_to_sh ((int16) dt.get_year (),
                           (uint8) dt.get_month (),
                           (uint16) dt.get_day_of_month (),
                           ref y, ref m, ref d) ;
        lbl_persian_lonar_event.set_label (_json_parser.get_persian_lonar_events (m, d)) ;
    }

    private void show_persian_national_events() {
        int16 y = 0 ;
        uint8 m = 0 ;
        uint16 d = 0 ;
        calendar.gr_to_sh ((int16) dt.get_year (),
                           (uint8) dt.get_month (),
                           (uint16) dt.get_day_of_month (),
                           ref y, ref m, ref d) ;
        string current_national_event = _json_parser.get_persian_national_events (m, d) ;
        lbl_persian_national_event.set_label (current_national_event) ;
    }

    private void show_persian_personage_events() {
        int16 y = 0 ;
        uint8 m = 0 ;
        uint16 d = 0 ;
        calendar.gr_to_sh ((int16) dt.get_year (),
                           (uint8) dt.get_month (),
                           (uint16) dt.get_day_of_month (),
                           ref y, ref m, ref d) ;
        lbl_persian_personage_event.set_label (_json_parser.get_persian_personage_events (m, d)) ;
    }

    public override void opened() {
        dt = new GLib.DateTime.now_local () ;
        calculate_georgian_date () ;
        calculate_ghamari_date () ;

        show_persian_solar_events () ;
        show_persian_lonar_events () ;
        show_persian_national_events () ;
        show_persian_personage_events () ;
    }

    public override void closed() {
    }

}

public Wingpanel.Indicator get_indicator(Module module) {
    debug ("Activating Calendar Indicator") ;
    var indicator = new Calendar.Indicator () ;
    return indicator ;
}
