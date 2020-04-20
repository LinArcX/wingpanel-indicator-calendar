public class Widgets.PanelLabel : Gtk.Grid {
    private Gtk.Label date_label ;
    private Gtk.Label time_label ;
    private Services.TimeManager time_manager ;

    public string clock_format { get ; set ; }
    public bool clock_show_seconds { get ; set ; }
    public bool clock_show_weekday { get ; set ; }

    public LibCalendar.SolarHijri cal  { get ; construct ; }

    public PanelLabel (LibCalendar.SolarHijri solar) {
        GLib.Object (cal: solar) ;
    }

    construct {
        date_label = new Gtk.Label (null) ;
        date_label.margin_end = 12 ;

        var date_revealer = new Gtk.Revealer () ;
        date_revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_LEFT ;
        date_revealer.add (date_label) ;

        time_label = new Gtk.Label (null) ;

        valign = Gtk.Align.CENTER ;
        add (date_revealer) ;
        add (time_label) ;

        var clock_settings = new GLib.Settings ("io.elementary.desktop.wingpanel.datetime") ;
        clock_settings.bind ("clock-format", this, "clock-format", SettingsBindFlags.DEFAULT) ;
        clock_settings.bind ("clock-show-seconds", this, "clock-show-seconds", SettingsBindFlags.DEFAULT) ;
        clock_settings.bind ("clock-show-date", date_revealer, "reveal_child", SettingsBindFlags.DEFAULT) ;
        clock_settings.bind ("clock-show-weekday", this, "clock-show-weekday", SettingsBindFlags.DEFAULT) ;

        notify.connect (() => {
            update_labels () ;
        }) ;

        time_manager = Services.TimeManager.get_default () ;
        time_manager.minute_changed.connect (update_labels) ;
        time_manager.notify["is-12h"].connect (update_labels) ;
    }

    private string show_gr_to_sh(LibCalendar.SolarHijri cal) {
        string output = "" ;
        int16 y = 0 ;
        uint8 m = 0 ;
        uint16 d = 0 ;
        cal.gr_to_sh (2020, 04, 20, ref y, ref m, ref d) ;
        output = y.to_string () + "/" +
                 m.to_string () + "/" +
                 d.to_string () ;
        return output ;

    }

    private void update_labels() {
        // string date_format ;
        // if( clock_format == "ISO8601" ){
        // date_format = "%F" ;
        // } else {
        // date_format = Granite.DateTime.get_default_date_format (clock_show_weekday, true, false) ;
        // }

        // date_label.label = time_manager.format (date_format) ;
        date_label.label = show_gr_to_sh (cal) ;

        // string time_format = Granite.DateTime.get_default_time_format (time_manager.is_12h, clock_show_seconds) ;
        // time_label.label = time_manager.format (time_format) ;
    }

}
