package spoopy.ui;

class SpoopyKeyboardAttributes {
    public static var altKey(get, never):Bool;
    public static var commandKey(get, never):Bool;
    public static var ctrlKey(get, never):Bool;
    public static var shiftKey(get, never):Bool;


    private static var __altKey:Bool = false;
    private static var __commandKey:Bool = false;
    private static var __ctrlKey:Bool = false;
    private static var __shiftKey:Bool = false;

    private static function get_altKey():Bool {
        return __altKey;
    }

    private static function get_commandKey():Bool {
        return __commandKey;
    }

    private static function get_ctrlKey():Bool {
        return __ctrlKey;
    }

    private static function get_shiftKey():Bool {
        return __shiftKey;
    }
}