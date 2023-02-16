package;

import lime.tools.HXProject;
import lime.tools.PlatformTarget;
import lime.tools.CommandHelper;
import lime.tools.CLICommand;

import sys.FileSystem;
import massive.sys.io.FileSys;
import hxp.*;

using StringTools;

class ProjectScript {
    private var haxeLibPath:String = "";
    private var debug:Bool = false;

    public static function main():Void {
        new ProjectScript();
    }

    public function new() {
        var args = Sys.args();
        var cwd = args.pop();

        commands(args);

        Sys.setCwd(cwd);
        Sys.exit(1);
    }

    private inline function commands(args:Array<String>):Void {
        if (args.length < 1) {
            Log.error("Incorrect number of arguments for command '" + args[0] + "'");
            return;
        }

        debug = (args.indexOf("-debug") > 1);
        processCWD();

        HXProject._debug = debug;

        switch(args[0]) {
            case "create":
                createCMD(args);
            case "test":
                testCMD(args);
            default:
                Log.error("Invalid command: '" + args[0] + "'");
        }
    }

    private inline function createCMD(args:Array<String>):Void {
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

    private inline function testCMD(args:Array<String>):Void {
        args.shift();
        args = ["build"].concat(args);

        Sys.command("lime", args);

        var ndll_path:String = "/ndll/";

        var project:SpoopyProject = new SpoopyProject();
        project.xmlProject(Sys.getCwd());
        project.targetPlatform("test");

        if(project.project.defines.exists("spoopy-vulkan")) {
            ndll_path = "/ndll-vulkan/";
        }else if(project.project.defines.exists("spoopy-metal")) {
            ndll_path = "/ndll-metal/";
        }

        if(project.project.define.exists("spoopy-custom")) {
            ndll_path = "/" + project.project.define.get("spoopy-custom") + "/";
        }

        project.replaceProjectNDLL(haxeLibPath + ndll_path + getHost(args), "lime.ndll");
        project.platform.run();
    }

    private inline function readLine() {
        return Sys.stdin().readLine();
    }

    private inline function getHost(args:Array<String>):String {
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

    private inline function processCWD():Void {
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
}