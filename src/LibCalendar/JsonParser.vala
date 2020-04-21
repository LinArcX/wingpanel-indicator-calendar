public errordomain MyError {
    INVALID_FORMAT
}

public class LibCalendar.JsonParser : GLib.Object {
    string current_event = "" ;
    int _month = 0 ;
    int _day = 0 ;

    public void process_events(Json.Node parent_node) throws Error {
        if( parent_node.get_node_type () != Json.NodeType.OBJECT ){
            throw new MyError.INVALID_FORMAT ("Unexpected element type %s", parent_node.type_name ()) ;
        }

        unowned Json.Object parent_obj = parent_node.get_object () ;
        foreach( unowned string month in parent_obj.get_members ()){
            if( month == _month.to_string ()){
                unowned Json.Node month_events = parent_obj.get_member (month) ;

                if( month_events.get_node_type () != Json.NodeType.ARRAY ){
                    throw new MyError.INVALID_FORMAT ("Unexpected element type %s", month_events.type_name ()) ;
                }
                unowned Json.Array month_events_array = month_events.get_array () ;
                foreach( unowned Json.Node single_event in month_events_array.get_elements ()){
                    if( single_event.get_node_type () != Json.NodeType.OBJECT ){
                        throw new MyError.INVALID_FORMAT ("Unexpected element type %s", single_event.type_name ()) ;
                    }
                    unowned Json.Object obj_item = single_event.get_object () ;
                    foreach( unowned string day in obj_item.get_members ()){
                        foreach( string item in obj_item.get_members ()){
                            if( item == _day.to_string ()){
                                current_event = obj_item.get_string_member (item) ;
                            }
                        }
                    }
                }
            }
        }
    }

    private void parse_json(string json_address) {
        Json.Parser parser = new Json.Parser () ;
        try {
            parser.load_from_file (json_address) ;
            Json.Node node = parser.get_root () ;
            process_events (node) ;
        } catch ( Error e ) {
            print ("Unable to parse the string: %s\n", e.message) ;
        }
    }

    public string get_persian_solar_events(int month, int day) {
        _month = month ;
        _day = day ;
        parse_json ("/usr/share/wingpanel-indicator-calendar/PersianSolar.json") ;
        return current_event ;
    }

    public string get_persian_lonar_events(int month, int day) {
        _month = month ;
        _day = day ;
        parse_json ("/usr/share/wingpanel-indicator-calendar/PersianLonar.json") ;
        return current_event ;
    }

    public string get_persian_national_events(int month, int day) {
        _month = month ;
        _day = day ;
        parse_json ("/usr/share/wingpanel-indicator-calendar/PersianNational.json") ;
        return current_event ;
    }

    public string get_persian_personage_events(int month, int day) {
        _month = month ;
        _day = day ;
        parse_json ("/usr/share/wingpanel-indicator-calendar/PersianPersonage.json") ;
        return current_event ;
    }

}
