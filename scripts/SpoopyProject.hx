package;

#if lime

import lime.tools.PlatformTarget;
import lime.tools.ProjectHelper;
import lime.tools.HXProject;
import lime.tools.Asset;
import lime.tools.AssetType;
import lime.tools.AssetHelper;

import massive.sys.io.FileSys;
import sys.FileSystem;
import sys.io.File;
import hxp.System;
import hxp.Path;
import hxp.Log;

import utils.EnhancedXMLProject;
import utils.PathUtils;

import haxe.io.Bytes;

using StringTools;

@:access(lime.tools.HXProject)
class SpoopyProject {
    public var project(default, null):HXProject;
    public var platform(default, null):PlatformTarget;
    public var shaders(default, null):Array<Asset>;
    public var contentDirectory(default, null):String;

    public function new(createProject:Bool = true) {
        if(createProject) {
            project = new HXProject();
            project.architectures = [];
        }
    }

    public function addTemplate(arg:String):Void {
        project.templatePaths.push(arg);
    }

    public function copyAndCreateTemplate(name:String, destination:String):Void {

        /*
        * Check to see if anything is wrong
        */
        if((name == null || name == "") || (destination == null || destination == "")) {
            return;
        }

        /*
        * Placeholder Info
        */
        var id = ["com", "example", name.replace(" ", "").toLowerCase()];
        var alphaNumeric = new EReg("[a-zA-Z0-9]", "g");

        /*
        * Project Info
        */
        var title = "";
        var packageName = id.join(".").toLowerCase();
        var version = "1.0.0";
        var company = "Company Name";
        var file = name.replace(" ", "");

        /*
        * Initialize Info
        */
        var capitalizeNext = true;

        for (i in 0...name.length)
        {
            if (alphaNumeric.match(name.charAt(i)))
            {
                if (capitalizeNext)
                {
                    title += name.charAt(i).toUpperCase();
                }
                else
                {
                    title += name.charAt(i);
                }

                capitalizeNext = false;
            }
            else
            {
                capitalizeNext = true;
            }
        }

        project.meta.title = title;
        project.meta.packageName = packageName;
        project.meta.version = version;
        project.meta.company = company;
        project.app.file = file;

        var context:Dynamic = {};

        context.title = title;
        context.packageName = packageName;
        context.version = version;
        context.company = company;
        context.file = file;

        ProjectHelper.recursiveSmartCopyTemplate(project, "project", destination + "/" + name, context);
    }

    public function xmlProject(path:String):Void {
        var projectFile:String = path + "/project.xml";

        var userDefines:Map<String, Dynamic> = new Map<String, Dynamic>();
        var includePaths :Array<String> = new Array<String>();

        if(!FileSystem.exists(projectFile)) {
            projectFile = path + "/Project.xml";
        }

        if(!FileSystem.exists(projectFile)) {
            Log.error("Could not find \"project.xml\", must have a project xml in your project");
        }

        if(Path.extension(projectFile) == "lime" || Path.extension(projectFile) == "nmml" || Path.extension(projectFile) == "xml") {
            var xmlProject:EnhancedXMLProject = new EnhancedXMLProject(Path.withoutDirectory(projectFile), userDefines, includePaths);
            project = xmlProject;

            shaders = xmlProject.shaders;
        }else {
            Log.error("Could not process \"" + projectFile + "\"");
        }
    }

    public function replaceProjectNDLL(path:String, dep:String):Void {
        var location:String = platform.targetDirectory + "/bin/" + dep;

        if(!FileSystem.exists(path + "/" + dep)) {
            Log.error("Couldn't not find \"" + dep + "\", please use 'spoopy build_ndll <platform>' to initialize NDLL: (" + path + "/" + dep + ")");
        }

        var replacing:String = PathUtils.recursivelyFindFile(platform.targetDirectory + "/bin", dep);

        if(replacing == "") {
            return;
        }

        FileSystem.deleteFile(replacing);
        System.copyFile(path + "/" + dep, replacing);
    }

    public function targetPlatform(command:String):Void {
        var targetFlags = new Map<String, String>();

        switch (project.target) {
            case ANDROID:
                platform = new AndroidPlatform(command, project, targetFlags);

            case IOS:
                platform = new IOSPlatform(command, project, targetFlags);

            case WINDOWS:
                platform = new WindowsPlatform(command, project, targetFlags);

            case MAC:
                platform = new MacPlatform(command, project, targetFlags);

            case LINUX:
                platform = new LinuxPlatform(command, project, targetFlags);

            case FLASH:
                platform = new FlashPlatform(command, project, targetFlags);

            case HTML5:
                platform = new HTML5Platform(command, project, targetFlags);

            case EMSCRIPTEN:
                platform = new EmscriptenPlatform(command, project, targetFlags);

            case TVOS:
                platform = new TVOSPlatform(command, project, targetFlags);

            case AIR:
                platform = new AIRPlatform(command, project, targetFlags);

            default:
        }
    }

    public function setupContentDirectory(host:String):Void {
        if(host.toLowerCase().startsWith("mac")) {
            contentDirectory = platform.targetDirectory + "/bin/" + platform.project.app.file + ".app/" + "/Contents/Resources";
        }

        if(host.toLowerCase().startsWith("windows") || host.toLowerCase().startsWith("linux")) {
            contentDirectory = platform.targetDirectory + "/bin/";
        }
    }

    public function setupShaders(host:String, haxeLibPath:String):Void {
        var objCached = platform.targetDirectory + "/obj/cached/";

        for(shader in shaders) {
            if (shader.embed != true) {
                var cachedPath = Path.combine(objCached, shader.targetPath);
                var shaderSPV = contentDirectory + "/" + shader.targetPath.split(".")[0] + ".spv";

                System.mkdir(Path.directory(Path.combine(contentDirectory, shader.targetPath)));
                System.mkdir(Path.directory(cachedPath));

                if(FileSystem.exists(objCached + shader.targetPath)) {
                    if(compareFiles(objCached, "", shader.targetPath, shader.sourcePath) && FileSystem.exists(shaderSPV)) {
                        continue;
                    }
                }

                if(FileSystem.isDirectory(shader.sourcePath)) {
                    continue;   
                }

                if(FileSystem.exists(objCached + shader.targetPath)) {
                    FileSystem.deleteFile(objCached + shader.targetPath);
                }

                if(FileSystem.exists(shaderSPV)) {
                    FileSystem.deleteFile(shaderSPV);
                }

                if(FileSys.isWindows) {
                    //Sys.command('"' + haxeLibPath +  "./dependencies/glslang/" + getSlangHost(host) + "/glslangValidator.exe" + '"', ["-V", '"' + ]);
                }else {
                    Sys.command(haxeLibPath + "dependencies/glslang/" + getSlangHost(host) + "/glslangValidator", ["-V", shader.sourcePath, "-o", shaderSPV]);
                }

                AssetHelper.copyAsset(shader, cachedPath);
            }
        }
    }

    private function getSlangHost(host:String):String {
        switch(host) {
            case "windows" | "windows64" | "windows32":
                return "windows";
            case "mac" | "mac32" :
                return "mac";
            case "mac64":
                return "mac64";
            default:
                return "linux";
        }
    }

    private function compareFiles(path1:String, path2:String, file1:String, file2:String):Bool {
        if(FileSystem.isDirectory(path1 + file1) || FileSystem.isDirectory(path2 + file2)) {
            return false;
        }

        var content1 = File.getBytes(path1 + file1);
        var content2 = File.getBytes(path2 + file2);

        if (content1.compare(content2) != 0) {
            return false;
        }

        return true;
    }
}

#end