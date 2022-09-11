package;

import sys.io.File;
import sys.FileSystem;
import massive.sys.io.FileSys;
import utils.PathUtils;
import hxp.Haxelib;
import hxp.Log;

class RunScript {
    public static function main() {
        var args = Sys.args();
        var cwd = args.pop();

        if (args.length > 0 && args[0] == "setup") {
            var limeDirectory = Haxelib.getPath(new Haxelib("lime"));

            if (limeDirectory == null || limeDirectory == "" || limeDirectory.indexOf("is not installed") > -1) {
                Sys.command("haxelib", ["install", "lime"]);
            }

            if(FileSys.isWindows) {
                var haxePath:String = Sys.getEnv("HAXEPATH");

				if (haxePath == null || haxePath == "") {
					haxePath = "C:\\HaxeToolkit\\haxe\\";
                }

                @:final var batchFile:String = "spoopy.bat";

                var scriptSourcePath = Sys.getCwd();
                scriptSourcePath = PathUtils.combine(scriptSourcePath, "bin");
				scriptSourcePath = PathUtils.combine(scriptSourcePath, batchFile);

                if(FileSystem.exists(scriptSourcePath)) {
                    File.copy(scriptSourcePath, haxePath + "\\" + batchFile);
                }else {
                    Log.error("Could not find the spoopy alias script. You can try 'haxelib selfupdate' and run setup again.");
                }
            }else {
                @:final var binPath = if (FileSys.isMac) "/usr/local/bin" else "/usr/bin";
                @:final var shellScript = PathUtils.getHaxelibPath("spoopy") + "bin/spoopy.sh";

				if (FileSystem.exists(shellScript)) {
					Sys.command("sudo", ["cp", shellScript, binPath + "/spoopy"]);
					Sys.command("sudo", ["chmod", "+x", binPath + "/spoopy"]);
				}
				else {
					Log.error("Could not find the spoopy alias script. You can try 'haxelib selfupdate' and run setup again.");
				}
            }
        }else if(args.length > 1 && args[0] == "build") {
            @:final var shellScripts:Array<String> = [
                "build.sh",
                "compile.sh"
            ];

            @:final var fileLocation:String = "scripts/shell/";

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
                            Sys.command("sh", [Sys.getCwd() + fileLocation + shellScripts[i]]);
                        }else {
                            Log.error("Could not find shellscript: " + Sys.getCwd() + fileLocation + shellScripts[i]);
                        }
                    }
            }
        }else {
            Sys.setCwd(cwd);
		    Sys.exit(Sys.command("haxelib", ["run", "lime"].concat(args)));
        }

        Sys.setCwd(cwd);
		Sys.exit(1);
    }
}