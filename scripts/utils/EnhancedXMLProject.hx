package utils;

import lime.utils.AssetType;
import hxp.*;
import lime.tools.ProjectXMLParser;
import lime.tools.Asset;
import lime.tools.AssetType;

import sys.FileSystem;

#if (haxe_ver >= 4)
import haxe.xml.Access;
#else
import haxe.xml.Fast as Access;
#end

class EnhancedXMLProject extends ProjectXMLParser {
    public var shaders(default, null):Array<Asset> = [];
    public var extensionPath(default, null):String = "";

    @:noCompletion var __dirtyShader:Bool = false;

    public function new(path:String = "", defines:Map<String, Dynamic> = null, includePaths:Array<String> = null, useExtensionPath:Bool = false) {
        super(path, defines, includePaths, useExtensionPath);
    }

    public function parseShaderElements(element:Access, basePath:String = ""):Void {
        var path = "";
        var targetPath = "";
        var embed:Null<Bool> = null;
        var library = null;

        if (element.has.path) {
            path = Path.combine(basePath, substitute(element.att.path));
        }

        if (element.has.library) {
            library = substitute(element.att.library);
        }

        if (element.has.embed) {
            embed = parseBool(element.att.embed);
        }

        if (element.has.rename) {
            targetPath = substitute(element.att.rename);
        }else if (element.has.path) {
            targetPath = substitute(element.att.path);
        }

        if (path == "" && (element.has.include || element.has.exclude)) {
            Log.error("In order to use 'include' or 'exclude' on <shader /> nodes, you must specify also specify a 'path' attribute");
            return;
        }else if(!element.elements.hasNext()) {
            if (path == "") {
                return;
            }

            if (!FileSystem.exists(path)) {
                Log.error("Could not find shader path \"" + path + "\"");
                return;
            }

            if (!FileSystem.isDirectory(path)) {
                var asset = new Asset(path, targetPath, AssetType.TEXT, embed);
                asset.library = library;

                if (element.has.id) {
                    asset.id = substitute(element.att.id);
                }

                shaders.push(asset);
            }else {
                var exclude = ".*|cvs|thumbs.db|desktop.ini|*.fla|*.hash";
				var include = "*.glsl";

                if (element.has.exclude) {
                    exclude += "|" + substitute(element.att.exclude);
                }

                if (element.has.include) {
                    include = substitute(element.att.include);
                }else {
                    include = "*";
                }

                parseShaderElementsDirectory(path, targetPath, include, exclude, AssetType.TEXT, embed, library, true);
            }
        }
    }

    public function parseShaderElementsDirectory(path:String, targetPath:String, include:String, exclude:String, type:AssetType, embed:Null<Bool>,
        library:String, recursive:Bool):Void {
        var files = FileSystem.readDirectory(path);

        if (targetPath != "") {
            targetPath += "/";
        }

        for(file in files) {
            if(FileSystem.isDirectory(path + "/" + file)) {
                if(recursive) {
                    if(filter(file, ["*"], exclude.split("|"))) {
                        parseShaderElementsDirectory(path + "/" + file, targetPath + file, include, exclude, type, embed, library, true);
                    }
                }
            }else {
                if(filter(file, include.split("|"), exclude.split("|"))) {
                    var asset = new Asset(path + "/" + file, targetPath + file, type, embed);
					asset.library = library;

                    shaders.push(asset);
                }
            }
        }
    }

    
    /*
    * This is so scuffed, too bad, it works.
    */

    override function parseXML(xml:Access, section:String, extensionPath:String = ""):Void {
        this.extensionPath = extensionPath;
        super.parseXML(xml, section, extensionPath);
    }

    override function isValidElement(element:Access, section:String):Bool {
        var isElement:Bool = super.isValidElement(element, section);
        var name = element.name;

        if(name == "shader" && isElement) {
            var path = Path.combine(extensionPath, substitute(element.att.path));

            __dirtyShader = true;
            parseShaderElements(element, extensionPath);
        }

        return isElement;
    }
}