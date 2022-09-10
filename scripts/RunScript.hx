package;

import hxp.*;
import sys.FileSystem;

class RunScript {
    public static function main() {
        var args = Sys.args();
        var cwd = args.pop();

        var shellScripts:Array<String> = [
            "build.sh",
            "compile.sh"
        ];

        var fileLocation:String = "scripts/shell/";

        for(i in 0...shellScripts.length) {
            try {
                trace(Sys.getCwd() + shellScripts[i]);
                Sys.setCwd("sh " + Sys.getCwd() + fileLocation + shellScripts[i]);
            }catch(e:Dynamic) {
                Log.error("Could not find shellscript: " + fileLocation + shellScripts[i]);
            }
        }
    }
}