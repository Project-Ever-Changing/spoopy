package;

import hxp.*;
import sys.io.File;
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
            if(FileSystem.exists(Sys.getCwd() + fileLocation + shellScripts[i])) {
                Sys.setCwd("sh " + Sys.getCwd() + fileLocation + shellScripts[i]);
            }else {
                Log.error("Could not find shellscript: " + Sys.getCwd() + fileLocation + shellScripts[i]);
            }
        }
    }
}