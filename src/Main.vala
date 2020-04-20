public class DateTime.Indicator : Wingpanel.Indicator {
    public static GLib.Settings settings ;

    private Widgets.PanelLabel panel_label ;
    private Gtk.Grid main_grid ;
    private Gtk.ListBox event_listbox ;
    private uint update_events_idle_source = 0 ;

    public Indicator () {
        Object (
            code_name: Wingpanel.Indicator.DATETIME,
            display_name: "Date & Time",
            description: "The date and time indicator"
            ) ;
    }

    static construct {
        settings = new GLib.Settings ("io.elementary.desktop.wingpanel.datetime") ;
    }

    construct {
        visible = true ;
    }

    public override Gtk.Widget get_display_widget() {
        if( panel_label == null ){
            var solar = new LibCalendar.SolarHijri () ;
            panel_label = new Widgets.PanelLabel (solar) ;
        }

        return panel_label ;
    }

    public override Gtk.Widget ? get_widget () {
        if( main_grid == null ){
            var placeholder_label = new Gtk.Label ("No Events on This Day") ;
            placeholder_label.wrap = true ;
            placeholder_label.wrap_mode = Pango.WrapMode.WORD ;
            placeholder_label.margin_start = 12 ;
            placeholder_label.margin_end = 12 ;
            placeholder_label.max_width_chars = 20 ;
            placeholder_label.justify = Gtk.Justification.CENTER ;
            placeholder_label.show_all () ;

            var placeholder_style_context = placeholder_label.get_style_context () ;
            placeholder_style_context.add_class (Gtk.STYLE_CLASS_DIM_LABEL) ;
            placeholder_style_context.add_class (Granite.STYLE_CLASS_H3_LABEL) ;

            event_listbox = new Gtk.ListBox () ;
            event_listbox.selection_mode = Gtk.SelectionMode.NONE ;
            event_listbox.set_placeholder (placeholder_label) ;

            var scrolled_window = new Gtk.ScrolledWindow (null, null) ;
            scrolled_window.hscrollbar_policy = Gtk.PolicyType.NEVER ;
            scrolled_window.add (event_listbox) ;

            var settings_button = new Gtk.ModelButton () ;
            settings_button.text = "Date & Time Settings…" ;

            main_grid = new Gtk.Grid () ;
            main_grid.margin_top = 12 ;
            // main_grid.attach (calendar, 0, 0) ;
            main_grid.attach (new Gtk.Separator (Gtk.Orientation.VERTICAL), 1, 0) ;
            main_grid.attach (scrolled_window, 2, 0) ;
            main_grid.attach (new Wingpanel.Widgets.Separator (), 0, 2, 3) ;
            main_grid.attach (settings_button, 0, 3, 3) ;

            var size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL) ;
            size_group.add_widget (event_listbox) ;

            settings_button.clicked.connect (() => {
                try {
                    AppInfo.launch_default_for_uri ("settings://time", null) ;
                } catch ( Error e ) {
                    warning ("Failed to open time and date settings: %s", e.message) ;
                }
            }) ;
        }

        return main_grid ;
    }

    private void idle_update_events() {
        if( update_events_idle_source > 0 ){
            GLib.Source.remove (update_events_idle_source) ;
        }

        update_events_idle_source = GLib.Idle.add (update_events) ;
    }

    private bool update_events() {
        foreach( unowned Gtk.Widget widget in event_listbox.get_children ()){
            widget.destroy () ;
        }
        event_listbox.show_all () ;
        update_events_idle_source = 0 ;
        return GLib.Source.REMOVE ;
    }

    public override void opened() {
    }

    public override void closed() {
    }

}

public Wingpanel.Indicator get_indicator(Module module) {
    debug ("Activating DateTime Indicator") ;
    var indicator = new DateTime.Indicator () ;
    return indicator ;
}
