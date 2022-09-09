package;

import hxp.*;
import sys.FileSystem;

class RunScript {
    public static function main() {
        var args = Sys.args();
        var cwd = args.pop();

        var shellScripts:Array<String> = ["build.sh", "compile.sh"];

        for(i in 0...shellScripts.length) {
            try {
                trace("hehe");
                Sys.setCwd("sh " + shellScripts[i]);
            }catch(e:Dynamic) {
                Log.error("Could not find shellscript: " + shellScripts[i]);
            }
        }
    }
}