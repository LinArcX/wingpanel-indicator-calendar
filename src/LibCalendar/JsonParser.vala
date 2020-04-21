public errordomain MyError {
    INVALID_FORMAT
}

public class LibCalendar.JsonParser : GLib.Object {
    construct {

    }

    string current_event = "" ;
    int _month = 0 ;
    int _day = 0 ;

    public void process_events(Json.Node node) throws Error {
        if( node.get_node_type () != Json.NodeType.OBJECT ){
            throw new MyError.INVALID_FORMAT ("Unexpected element type %s", node.type_name ()) ;
        }

        unowned Json.Object obj = node.get_object () ;

        foreach( unowned string name in obj.get_members ()){
            if( name == _month.to_string ()){
                unowned Json.Node item = obj.get_member (name) ;

                if( item.get_node_type () != Json.NodeType.ARRAY ){
                    throw new MyError.INVALID_FORMAT ("Unexpected element type %s", item.type_name ()) ;
                }

                unowned Json.Array array = item.get_array () ;
                int i = 1 ;

                foreach( unowned Json.Node arr_item in array.get_elements ()){
                    if( arr_item.get_node_type () != Json.NodeType.OBJECT ){
                        throw new MyError.INVALID_FORMAT ("Unexpected element type %s", arr_item.type_name ()) ;
                    }

                    // TODO, type check ...
                    unowned Json.Object obj_item = arr_item.get_object () ;

                    foreach( unowned string name_event in obj_item.get_members ()){
                        if( name_event == _day.to_string ()){
                            // unowned Json.Node item = obj_item.get_member (name_event) ;
                            // if( item.get_node_type () != Json.NodeType.VALUE ){
                            // throw new MyError.INVALID_FORMAT ("Unexpected element type %s", item.type_name ()) ;
                            // }
                            current_event = obj_item.get_string_member (name_event) ;
                        }
                    }
                    i++ ;
                }

            } else {
                throw new MyError.INVALID_FORMAT ("Unexpected element '%s'", name) ;
            }
        }

    }

    public string get_persian_national_events(int month, int day) {
        string wholeText = "" ;
        _month = month ;
        _day = day ;

        File file = File.new_for_path ("/usr/share/wingpanel-indicator-calendar/PersianNational.json") ;
        try {
            FileInputStream fis = file.read () ;
            DataInputStream dis = new DataInputStream (fis) ;
            string line ;

            while((line = dis.read_line ()) != null ){
                wholeText += line ;
            }
        } catch ( Error e ) {
            print ("Error: %s\n", e.message) ;
        }

        Json.Parser parser = new Json.Parser () ;
        try {
            parser.load_from_data (wholeText) ;
            Json.Node node = parser.get_root () ;
            process_events (node) ;
        } catch ( Error e ) {
            print ("Unable to parse the string: %s\n", e.message) ;
        }
        return current_event ;
    }

}
