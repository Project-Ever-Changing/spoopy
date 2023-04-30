package;

import massive.sys.util.PathUtil;
import utils.net.GitFileManager;
import lime.tools.HXProject;
import lime.tools.PlatformTarget;
import lime.tools.CommandHelper;
import lime.tools.CLICommand;
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

        if(projectCMDS.indexOf(args[0]) != -1) {
            if (args.length < 1) {
                Log.error("Incorrect number of arguments for command '" + args[0] + "'");
                return;
            }

            debug = (args.indexOf("-debug") > 1);
            processCWD();
        }

        HXProject._debug = debug;

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
                createCMD(args);
            case "test":
                testCMD(args);
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
            }
            else {
                Log.error("Could not find the spoopy alias script. You can try 'spoopy selfupdate' and run setup again.");
            }
        }
    }

    static inline function buildCMD(args:Array<String>):Void {
        var fileLocation:String = "scripts/";
        var have_API:String = "";
        var build_args:Array<String> = [];

        if(!FileSystem.exists(Sys.getCwd() + "ndll")) {
            FileSystem.createDirectory(Sys.getCwd() + "ndll");
        }

        if(!(args.indexOf("-no_vulkan") > 0) && !FileSys.isMac) {
            if(!FileSystem.exists(Sys.getCwd() + "ndll-vulkan")) {
                FileSystem.createDirectory(Sys.getCwd() + "ndll-vulkan");
            }

            have_API = "-DSPOOPY_VULKAN";
            build_args.push(have_API);
        }

        if(!(args.indexOf("-no_metal") > 0) && FileSys.isMac) {
            if(!FileSystem.exists(Sys.getCwd() + "ndll-metal")) {
                FileSystem.createDirectory(Sys.getCwd() + "ndll-metal");
            }

            have_API = "-DSPOOPY_METAL";
            build_args.push(have_API);
        }

        build_args.push(getXMLArgs(args, "-include_example"));

        buildScript(build_args);
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
            PathUtils.deleteDirRecursively(ndllPath);
        }
    }

    static inline function updateCMD(args:Array<String>):Void {
        Sys.command("haxelib", ["update", "spoopy"]);

        if(args.indexOf("-git") > 0) {
            Sys.command("git", ["submodule", "update", "--init", "--remote"]);
        }
        
        if(args.indexOf("-ndll") > 0) {
            destroyCMD(args);
            buildCMD(args);
        }
    }

    static inline function createCMD(args:Array<String>):Void {
        if(args.length <= 1) {
            Log.error("Incorrect number of arguments for command 'create'");
            return;
        }

        Sys.stdout().writeString("Project Directory: ");

        var projectPath:String = readLine();

        projectPath = projectPath
            .replace("'", "")
            .replace('"', "")
            .replace("\\", "")
            .trim();

        var project:SpoopyProject = new SpoopyProject();
        project.project.templatePaths.push("templates");
        project.copyAndCreateTemplate(args[1], projectPath);

        if(args[2] == "-debug") {
            Log.info("Project is located at: " + projectPath + "/" + args[1]);
        }
    }

    static inline function testCMD(args:Array<String>):Void {
        args.shift();
        args = ["build"].concat(args);

        if(Sys.command("lime", args) != 0) {
            return;
        }

        var host = getHost(args);

        if((host == "Linux64" || host == "Linux32") && args[1].toLowerCase() != "linux") {
            Log.error("Sorry, but Spoopy Engine is only available on desktop platforms at the current moment.");
            return;
        }

        var ndll_path:String = "/ndll/";

        var project:SpoopyProject = new SpoopyProject(false);
        project.xmlProject(Sys.getCwd());
        project.targetPlatform("test");

        if(project.project.defines.exists("spoopy-vulkan")) {
            ndll_path = "/ndll-vulkan/";
        }else if(project.project.defines.exists("spoopy-metal")) {
            ndll_path = "/ndll-metal/";
        }

        project.setupContentDirectory(host);
        project.setupShaders(host.toLowerCase(), haxeLibPath);
        project.replaceProjectNDLL(haxeLibPath + ndll_path + host, "lime.ndll");
        runApplication(project);
    }

    /*
    * Tools pretty much.
    */
    static inline function buildScript(have_API:Array<String>):Void {
        var cleanG_API:Array<String> = [];

        if(FileSystem.exists("project/obj")) {
            PathUtils.deleteDirRecursively("project/obj");
            FileSystem.deleteDirectory("project/obj");
        }

        for(i in 0...have_API.length) {
            cleanG_API.push(have_API[i].split("_")[1].toLowerCase());
        }

        for(api in cleanG_API) {
            if(!FileSystem.exists("ndll-" + api)) {
                cleanG_API.remove(api);
            }
        }

        for(api in cleanG_API) {
            var find:String = "";

            do {
                find = PathUtils.recursivelyFindFile("ndll-" + api, "lime.ndll.hash");

                if(find != "") {
                    FileSystem.deleteFile(find);
                }
            }while(find != "");
        }

        Sys.setCwd("project");
        Sys.command("haxelib", ["run", "hxcpp", "Build.xml.tpl"].concat(have_API));
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

    static inline function processCWD():Void {
        var arguments = Sys.args();

        if(arguments.length > 0) {
            var lastArgument:String = "";

            for(i in 0...arguments.length) {
                lastArgument = arguments.pop();

                if(lastArgument.length > 0) {
                    break;
                }
            }

            if(FileSystem.exists(lastArgument) && FileSystem.isDirectory(lastArgument)) {
                haxeLibPath = Sys.getCwd();

                lastArgument = new Path(lastArgument).toString();
                Sys.setCwd(lastArgument);
            }
        }
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

    static inline function getHost(args:Array<String>):String {
        var hostArchitecture:String = "";
        var hostPlatform:String = "";

        if(args.indexOf("-32") > 1) {
            hostArchitecture = "32";
        }else if(args.indexOf("-64") > 1) {
            hostArchitecture = "64";
        }

        switch(args[1]) {
            case "windows":
                hostPlatform = "Windows";
            case "linux":
                hostPlatform = "Linux";
            case "mac":
                hostPlatform = "Mac";
            default:
                hostPlatform = "";
        }

        if(hostArchitecture == "") {
            if(System.hostArchitecture == X64) {
                hostArchitecture = "64";
            }else {
                hostArchitecture = "32";
            }
        }

        if(hostPlatform == "") {
            if(FileSys.isWindows) {
                hostPlatform = "Windows";
            }else if(FileSys.isMac) {
                hostPlatform = "Mac";
            }else {
                hostPlatform = "Linux";
            }
        }

        return hostPlatform + hostArchitecture;
    }

    static inline function runApplication(project:SpoopyProject):Void {
        project.platform.run();
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