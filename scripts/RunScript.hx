package;

import lime.tools.HXProject;
import sys.io.File;
import sys.FileSystem;
import massive.sys.io.FileSys;
import utils.PathUtils;
import hxp.Haxelib;
import hxp.Log;

class RunScript {
    static var builtNDLL:Bool = false;

    public static function main() {
        var args = Sys.args();
        var cwd = args.pop();

        commands(args);

        Sys.setCwd(cwd);
		Sys.exit(1);
    }

    static inline function commands(args:Array<String>):Void {
        if(args.length == 0 || args[0] == "help") {
            if(FileSys.isWindows) {
                @:final var displayScript:String = "scripts/batch/display.bat";

                if(FileSystem.exists(Sys.getCwd() + displayScript)) {
                    Sys.command(Sys.getCwd() + displayScript);
                }else {
                    Log.error("Could not find script: " + Sys.getCwd() + displayScript);
                }
            }else {
                @:final var displayScript:String = "scripts/shell/display.sh";

                if(FileSystem.exists(Sys.getCwd() + displayScript)) {
                    Sys.command("sh", [Sys.getCwd() + displayScript]);
                }else {
                    Log.error("Could not find script: " + Sys.getCwd() + displayScript);
                }
            }

            return;
        }

        switch(args[0]) {
            case "setup":
                setupCMD(args);
            case "build":
                buildCMD(args);
            case "ls":
                lsCMD(args);
            case "destroy":
                destroyCMD(args);
            case "update":
                updateCMD(args);
            case "test":
                testCMD(args);
            default:
                Log.error("Invalid command: '" + args[0] + "'");
        }
    }

    static inline function readLine() {
        return Sys.stdin().readLine();
    }

    static function askYN(question:String):Bool {
        while (true) {
            Sys.println("");
            Sys.println(question + " [y/n]?");

            return switch (readLine()) {
                case "n", "No", "no": false;
                case "y", "Yes", "yes": true;
                case _: false;
            }
        }

        return null;
    }

    static inline function setupCMD(args:Array<String>):Void {
        if(args.length == 0) {
            return;
        }

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
                Log.error("Could not find the spoopy alias script. You can try 'spoopy selfupdate' and run setup again.");
            }
        }
    }

    static inline function buildCMD(args:Array<String>):Void {
        if(args.length <= 1) {
            Log.error("Incorrect number of arguments for command 'build'");
            return;
        }

        @:final var fileLocation:String = "scripts/";
        @:final var libraries:Map<String, String> = [
            "sdl" => "https://github.com/native-toolkit/libsdl",
            "hashlink" => "https://github.com/HaxeFoundation/hashlink.git"
        ];

        var scripts:Array<String> = [];

        if(FileSys.isWindows) {
            scripts = [
                "batch/build.bat"
            ];
        }else {
            scripts = [
                "shell/build.sh"
            ];
        }

        if(!FileSystem.exists(Sys.getCwd() + "ndll")) {
            FileSystem.createDirectory(Sys.getCwd() + "ndll");
        }

        Sys.command("git", ["submodule", "update", "--init", "--recursive"]);

        switch(args[1].toLowerCase()) {
            case "Windows" | "Windows64":
                for(i in 0...scripts.length) {
                    if(FileSystem.exists(Sys.getCwd() + fileLocation + scripts[i])) {
                        Sys.command(Sys.getCwd() + fileLocation + scripts[i]);
                        builtNDLL = true;
                    }else {
                        Log.error("Could not find script: " + Sys.getCwd() + fileLocation + scripts[i]);
                    }
                }
            default:
                for(i in 0...scripts.length) {
                    if(FileSystem.exists(Sys.getCwd() + fileLocation + scripts[i])) {
                        Sys.command("sh", [Sys.getCwd() + fileLocation + scripts[i]]);
                        builtNDLL = true;
                    }else {
                        Log.error("Could not find script: " + Sys.getCwd() + fileLocation + scripts[i]);
                    }
                }
        }
    }

    static inline function lsCMD(args:Array<String>):Void {
        if(args.length > 1) {
            Sys.command("ls", [Sys.getCwd() + args[1]]);
        }else {
            Sys.command("ls");
        }
    }

    static inline function destroyCMD(args:Array<String>):Void {
        if(args.length <= 1) {
            Log.error("Incorrect number of arguments for command 'destroy'");
            return;
        }

        @:final var fileLocation:String = "scripts/";

        var scripts:Array<String> = [];

        if(!FileSystem.exists(Sys.getCwd() + "ndll")) {
            return;
        }

        if(FileSys.isWindows) {
            scripts = [
                "batch/destroy.bat"
            ];
        }else {
            scripts = [
                "shell/destroy.sh"
            ];
        }

        switch(args[1].toLowerCase()) {
            case "Windows" | "Windows64":
                for(i in 0...scripts.length) {
                    if(FileSystem.exists(Sys.getCwd() + fileLocation + scripts[i])) {
                        Sys.command(Sys.getCwd() + fileLocation + scripts[i]);
                    }else {
                        Log.error("Could not find script: " + Sys.getCwd() + fileLocation + scripts[i]);
                    }
                }
            default:
                for(i in 0...scripts.length) {
                    if(FileSystem.exists(Sys.getCwd() + fileLocation + scripts[i])) {
                        Sys.command("sh", [Sys.getCwd() + fileLocation + scripts[i]]);
                    }else {
                        Log.error("Could not find script: " + Sys.getCwd() + fileLocation + scripts[i]);
                    }
                }
        }
    }

    static inline function updateCMD(args:Array<String>):Void {
        if(args.length <= 1) {
            Log.error("Incorrect number of arguments for command 'update'");
            return;
        }

        Sys.command("haxelib", ["update", "spoopy"]);
        
        destroyCMD(["", args[1]]);
        buildCMD(["", args[1]]);
    }

    @:access(CommandLineTools)
    static inline function testCMD(args:Array<String>):Void {
        if(args.length <= 1) {
            Log.error("Incorrect number of arguments for command 'test'");
            return;
        }

        if(!builtNDLL) {
            updateCMD(args);
        }

        var cmdTools:CommandLineTools = new CommandLineTools();
        var project:HXProject = cmdTools.initializeProject();

        cmdTools.buildProject(project);
    }

    /*
    static inline function compileGraphics():Void {
        @:final var binPath = if (FileSys.isMac) "/usr/local/bin" else "/usr/bin";
        binPath += "/glslc";

        var cacheDirectory:Array<String> = FileSystem.readDirectory("shaders/VKGL");

        for(i in 0...cacheDirectory.length) {
            var split:Array<String> = cacheDirectory[i].split(".");

            if(split[split.length - 1] == "spv") {
                FileSystem.deleteFile("shaders/VKGL/" + cacheDirectory[i]);
            }
        }

        for(i in 0...cacheDirectory.length) {
            Sys.command(binPath, ["shaders/VKGL/" + cacheDirectory[i], "-o", "shaders/VKGL/" + cacheDirectory[i] + ".spv"]);
        }
    }
    */
}