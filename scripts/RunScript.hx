package;

import hxp.*;
import sys.FileSystem;

class RunScript {
    public static function main() {
        var args = Sys.args();
        var cwd = args.pop();

        var shellScripts:Array<String> = [
            "/shell/build.sh",
            "/shell/compile.sh"
        ];

        for(i in 0...shellScripts.length) {
            try {
                trace(Sys.getCwd() + shellscript[i]);
                Sys.setCwd("sh " + Sys.getCwd() + shellScripts[i]);
            }catch(e:Dynamic) {
                Log.error("Could not find shellscript: " + Sys.getCwd() + shellScripts[i]);
            }
        }
    }
}