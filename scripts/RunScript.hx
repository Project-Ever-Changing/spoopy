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

        if (args.length > 0 && args[0] == "build") {
            var limeDirectory = Haxelib.getPath(new Haxelib("lime"));

            if (limeDirectory == null || limeDirectory == "" || limeDirectory.indexOf("is not installed") > -1) {
                Sys.command("haxelib", ["install", "lime"]);
            }

            if(args.length > 1) {
                switch(args[1].toLowerCase()) {
                    case "Windows" | "Windows64":
                        for(i in 0...shellScripts.length) {
                            if(FileSystem.exists(Sys.getCwd() + fileLocation + shellScripts[i])) {
                                Sys.command(Sys.getCwd() + fileLocation + shellScripts[i]);
                            }else {
                                Log.error("Could not find shellscript: " + Sys.getCwd() + fileLocation + shellScripts[i]);
                            }
                        }
                    default:
                        for(i in 0...shellScripts.length) {
                            if(FileSystem.exists(Sys.getCwd() + fileLocation + shellScripts[i])) {
                                Sys.command("sudo", ["cp", Sys.getCwd() + fileLocation + shellScripts[i]]);
                            }else {
                                Log.error("Could not find shellscript: " + Sys.getCwd() + fileLocation + shellScripts[i]);
                            }
                        }
                }
            }
        }
    }
}