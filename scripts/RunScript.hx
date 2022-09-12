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

            @:final var answer:Bool = askYN("Do you want to setup the command alias?");

            if(!answer) {
                return;
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
                
                var shellScript = Sys.getCwd();
                shellScript = PathUtils.combine(shellScript, "bin");
                shellScript = PathUtils.combine(shellScript, "spoopy.sh");

				if (FileSystem.exists(shellScript)) {
					Sys.command("sudo", ["cp", shellScript, binPath + "/spoopy"]);
					Sys.command("sudo", ["chmod", "+x", binPath + "/spoopy"]);
				}
				else {
					Log.error("Could not find the spoopy alias script. You can try 'haxelib selfupdate' and run setup again.");
				}
            }
        }else if(args.length > 1 && args[0] == "build") {
            @:final var fileLocation:String = "scripts/shell/";

            @:final var shellScripts:Array<String> = [
                "build.sh",
            ];

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

                    compileGraphics();
            }
        }else {
            if(FileSys.isWindows) {
                @:final var displayScript:String = "scripts/batch/display.bat";

                if(FileSystem.exists(Sys.getCwd() + displayScript)) {
                    Sys.command(Sys.getCwd() + displayScript);
                }else {
                    Log.error("Could not find shellscript: " + Sys.getCwd() + displayScript);
                }
            }else {
                @:final var displayScript:String = "scripts/shell/display.sh";

                if(FileSystem.exists(Sys.getCwd() + displayScript)) {
                    Sys.command("sh", [Sys.getCwd() + displayScript]);
                }else {
                    Log.error("Could not find shellscript: " + Sys.getCwd() + displayScript);
                }
            }
        }

        Sys.setCwd(cwd);
		Sys.exit(1);
    }

    static inline function readLine() {
        return Sys.stdin().readLine();
    }

    static function askYN(question:String):Bool
        {
            while (true)
            {
                Sys.println("");
                Sys.println(question + " [y/n]?");
    
                return switch (readLine())
                {
                    case "n", "No", "no": false;
                    case "y", "Yes", "yes": true;
                    case _: false;
                }
            }
    
            return null;
        }

    static inline function compileGraphics():Void {
        @:final var binPath = if (FileSys.isMac) "/usr/local/bin" else "/usr/bin";
        binPath += "/glslc";

        var cacheDirectory:Array<String> = FileSystem.readDirectory("shaders/VKGL");

        for(i in 0...cacheDirectory.length) {
            var split:Array<String> = cacheDirectory[i].split(".");

            if(split[split.length - 1].trim() == "spv") {
                FileSystem.deleteFile("shaders/VKGL/" + cacheDirectory[i]);
            }
        }

        for(i in 0...cacheDirectory.length) {
            Sys.command(binPath, ["shaders/VKGL/" + cacheDirectory[i], "-o", "shaders/VKGL/" + cacheDirectory[i] + ".spv"]);
        }
    }
}