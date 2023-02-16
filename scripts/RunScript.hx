package;

import utils.net.GitFileManager;
import sys.io.File;
import sys.FileSystem;
import massive.sys.io.FileSys;
import utils.PathUtils;
import utils.DisplayInfo;
import utils.net.GitFileManager;
import hxp.*;

using StringTools;

class RunScript {
    private static var haxeLibPath:String = "";
    private static var projectCMDS:Array<String> = ["test"];
    private static var runFromHaxelib:Bool = false;
    private static var debug:Bool = false;

    private static var commandList:Array<CommandLine> = [
        {
            name: "build_ndll",
            description: "Build a dynamic link library for Spoopy Engine."
        },
        {
            name: "destroy_ndll",
            description: "Destroy a dynamic link library from Spoopy Engine."
        },
        {
            name: "import_ndll git",
            description: "Import a dynamic link library from git for Spoopy Engine as a module."
        },
        {
            name: "update",
            description: "Refresh and upgrade the components within Spoopy Engine."
        },
        {
            name: "setup",
            description: "Setup spoopy library."
        },
        {
            name: "create",
            description: "Create a new project."
        },
        {
            name: "test",
            description: "Build and run project."
        },
        {
            name: "ls",
            description: "List the files and directories in Spoopy Engine's source directory."
        }
    ];

    public static function main() {
        var args = Sys.args();
        var cwd = args.pop();

        commands(args);

        Sys.setCwd(cwd);
		Sys.exit(1);
    }

    static function commands(args:Array<String>):Void {
        if(args.length == 0 || args[0] == "help") {
            var displayInfo:DisplayInfo = new DisplayInfo(commandList);
            return;
        }

        switch(args[0]) {
            case "setup":
                setupCMD(args);
            case "build_ndll":
                buildCMD(args);
            case "ls":
                lsCMD(args);
            case "destroy_ndll":
                destroyCMD(args);
            case "update":
                updateCMD(args);
            case "create":
                nekoCompatible(args);
            case "test":
                nekoCompatible(args);
            case "import_ndll":
                importCMD(args);
            default:
                Log.error("Invalid command: '" + args[0] + "'");
        }
    }

    static inline function setupCMD(args:Array<String>):Void {
        if(args.length == 0) {
            return;
        }

        var limeDirectory:String = Haxelib.getPath(new Haxelib("lime"));

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
            }else {
                Log.error("Could not find the spoopy alias script. You can try 'spoopy selfupdate' and run setup again.");
            }
        }
    }

    static inline function nekoCompatible(args:Array<String>):Void {
        if(!FileSystem.exists("tools.n")) {
            Sys.command("haxe", ["tools.hxml"]);
        }

        Sys.command("neko", ["tools.n"].concat(args));
    }

    static inline function importCMD(args:Array<String>):Void {
        switch(args[1]) {
            case "git":
                args.shift();
                args.shift();

                subGitImport(args);
        }
    }

    static inline function subGitImport(args:Array<String>):Void {
        var build_args:Array<String> = buildArgs(args);

        var arg1:Bool = args.length >= 0;
        var arg2:Bool = args.length >= 1;

        var libName:String = "";
        var gitUrl:String = "";

        if(arg1) {
            libName = args[1];
        }else {
            Sys.stdout().writeString("Module Name: ");
            libName = readLine();
        }

        if(arg2) {
            gitUrl = args[2];
        }else {
            Sys.stdout().writeString("Git Path: ");
            gitUrl = readLine();
        }

        Sys.command("git", ["clone", "--recurse-submodules", gitUrl, "modules/" + libName]);
        Sys.command("haxelib", ["run", "hxcpp", "modules/" + libName + "/Build.xml"].concat(buildScript(build_args)));
    }

    static inline function buildCMD(args:Array<String>):Void {
        var fileLocation:String = "scripts/";
        var build_args:Array<String> = buildArgs(args);

        if(!FileSystem.exists(Sys.getCwd() + "ndll")) {
            FileSystem.createDirectory(Sys.getCwd() + "ndll");
        }

        Sys.setCwd("project");
        Sys.command("haxelib", ["run", "hxcpp", "Build.xml.tpl"].concat(buildScript(build_args)));
    }

    static inline function lsCMD(args:Array<String>):Void {
        if(args.length > 1) {
            Sys.command("ls", [Sys.getCwd() + args[1]]);
        }else {
            Sys.command("ls");
        }
    }

    static inline function destroyCMD(args:Array<String>):Void {
        var ndllPath:String = "ndll";

        if(!(args.indexOf("-no_vulkan") > 0) && !FileSys.isMac) {
            ndllPath = "ndll-vulkan";
        }

        if(!(args.indexOf("-no_metal") > 0) && FileSys.isMac) {
            ndllPath = "ndll-metal";
        }

        if(FileSystem.exists(ndllPath)) {
            FileSystem.deleteDirectory(ndllPath);
        }
    }

    static inline function updateCMD(args:Array<String>):Void {
        Sys.command("haxelib", ["update", "spoopy"]);

        if(args.indexOf("-git") > 0) {
            Sys.command("git", ["submodule", "update", "--init", "--recursive", "--remote"]);
        }
        
        if(args.indexOf("-ndll") > 0) {
            destroyCMD(args);
            buildCMD(args);
        }
    }

    /*
    * Tools pretty much.
    */
    static inline function buildScript(have_API:Array<String>):Array<String> {
        var cleanG_API:Array<String> = [];

        if(FileSystem.exists("project/obj")) {
            FileSystem.deleteDirectory("project/obj");
        }

        if(have_API.indexOf("-DSPOOPY_EMPTY") > -1) {
            have_API.remove("-DSPOOPY_EMPTY");
        }

        for(i in 0...have_API.length) {
            cleanG_API.push("-" + have_API[i].split("_")[1].toLowerCase());
        }

        if(FileSystem.exists("ndll")) {
            cleanG_API.push("");
        }

        for(api in cleanG_API) {
            if(!FileSystem.exists("ndll" + api)) {
                cleanG_API.remove(api);
            }
        }

        for(api in cleanG_API) {
            var find:String = "";

            do {
                find = PathUtils.recursivelyFindFile("ndll" + api, "lime.ndll.hash");

                if(find != "") {
                    FileSystem.deleteFile(find);
                }
            }while(find != "");
        }

        return have_API;
    }

    static inline function buildArgs(args:Array<String>):Array<String> {
        var build_args:Array<String> = [];
        var have_API:String = "";

        if(!(args.indexOf("-no_vulkan") > 0) && !FileSys.isMac) {
            have_API = "-DSPOOPY_VULKAN";
            build_args.push(have_API);
        }

        if(!(args.indexOf("-no_metal") > 0) && FileSys.isMac) {
            have_API = "-DSPOOPY_METAL";
            build_args.push(have_API);
        }

        build_args.push(getXMLArgs(args, "-include_example"));
        return build_args;
    }

    static inline function getXMLArgs(args:Array<String>, lookingFor:String):String {
        if(args.indexOf(lookingFor) > 0) {
            switch(lookingFor) {
                case "-include_example":
                    return "-DSPOOPY_INCLUDE_EXAMPLE";
                default:
                    return "-DSPOOPY_EMPTY";
            }
        }

        return "-DSPOOPY_EMPTY";
    }

    static inline function readLine() {
        return Sys.stdin().readLine();
    }

    static inline function runScript(path:String, file:String):Void {
        if(FileSys.isWindows) {
            @:final var script:String = path + "/batch/" + file + ".bat";
            Sys.command(Sys.getCwd() + script);
        }else {
            @:final var script:String = path + "/shell/" + file + ".sh";
            Sys.command("bash", [Sys.getCwd() + script]);
        }
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
}