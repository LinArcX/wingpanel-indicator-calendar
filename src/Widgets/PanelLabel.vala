public class Widgets.PanelLabel : Gtk.Grid {

    private Gtk.Label date_label ;
    private Gtk.Label time_label ;

    private GLib.DateTime dt { get ; set ; }
    private Services.TimeManager time_manager ;
    public LibCalendar.SolarHijri cal  { get ; construct ; }

    public PanelLabel (LibCalendar.SolarHijri solar) {
        GLib.Object (cal: solar) ;
    }

    construct {
        date_label = new Gtk.Label (null) ;
        date_label.margin_end = 12 ;
        date_label.margin_top = 2 ;

        var date_revealer = new Gtk.Revealer () ;
        date_revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_LEFT ;
        date_revealer.add (date_label) ;

        time_label = new Gtk.Label (null) ;

        valign = Gtk.Align.CENTER ;
        add (date_revealer) ;
        add (time_label) ;

        var clock_settings = new GLib.Settings ("io.elementary.desktop.wingpanel.datetime") ;
        clock_settings.bind ("clock-format", this,
                             "clock-format", SettingsBindFlags.DEFAULT) ;
        clock_settings.bind ("clock-show-seconds", this,
                             "clock-show-seconds", SettingsBindFlags.DEFAULT) ;
        clock_settings.bind ("clock-show-date", date_revealer,
                             "reveal_child", SettingsBindFlags.DEFAULT) ;
        clock_settings.bind ("clock-show-weekday", this,
                             "clock-show-weekday", SettingsBindFlags.DEFAULT) ;

        notify.connect (() => {
            update_labels () ;
        }) ;

        time_manager = Services.TimeManager.get_default () ;
        time_manager.minute_changed.connect (update_labels) ;
        time_manager.notify["is-12h"].connect (update_labels) ;
    }

    private void calculate_jalali_date() {
        string output = "" ;
        int16 y = 0 ;
        uint8 m = 0 ;
        uint16 d = 0 ;

        cal.gr_to_sh ((int16) dt.get_year (),
                      (uint8) dt.get_month (),
                      (uint16) dt.get_day_of_month (),
                      ref y, ref m, ref d) ;

        output = d.to_string () + "  " +
                 cal.get_month_name ((int) m) + "  " +
                 y.to_string () ;

        date_label.label = output ;
    }

    private void calculate_current_time() {
        time_label.label = dt.get_hour ().to_string () + ":" +
                           dt.get_minute ().to_string () ;
    }

    private void update_labels() {
        dt = new GLib.DateTime.now_local () ;
        calculate_jalali_date () ;
        calculate_current_time () ;
    }

}
