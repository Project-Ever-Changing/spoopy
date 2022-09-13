package spoopy.backend;

class GraphicsPipline {
    @:noCompletion var __fragmentTaken:Bool = true;
    @:noCompletion var __vertexTaken:Bool = true;

    @:noCompletion var __fragmentSource:String;
    @:noCompletion var __vertexSource:String;

    public var fragmentSource(get, set):String;
    public var vertexSource(get, set):String;

    public function pushChanges():Void {
        if(!__fragmentTaken) {
            __fragmentTaken = true;
            //Init Fragment Shaders
        }

        if(!__vertexTaken) {
            __vertexTaken = true;
            //Init Vertex Shaders
        }
    }

    @:noCompletion function get_fragmentSource():String {
        return __fragmentSource;
    }

    @:noCompletion function get_vertexSource():String {
        return __vertexSource;
    }

    @:noCompletion function set_fragmentSource(value:String):String {
        if(value == __fragmentSource) {
            __fragmentTaken = true;
        }else {
            __fragmentTaken = false;
        }

        return __fragmentSource = value;
    }

    @:noCompletion function set_vertexSource(value:String):String {
        if(value == __vertexSource) {
            __vertexTaken = true;
        }else {
            __vertexTaken = false;
        }

        return __vertexSource = value;
    }
}