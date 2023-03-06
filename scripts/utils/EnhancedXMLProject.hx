package utils;

import hxp.*;
import lime.tools.ProjectXMLParser;

#if (haxe_ver >= 4)
import haxe.xml.Access;
#else
import haxe.xml.Fast as Access;
#end

class EnhancedXMLProject extends ProjectXMLParser {
    public var shaders(default, null):Array<String> = [];
    public var extensionPath(default, null):String = "";

    @:noCompletion var __dirtyShader:Bool = false;

    public function new(path:String = "", defines:Map<String, Dynamic> = null, includePaths:Array<String> = null, useExtensionPath:Bool = false) {
        super(path, defines, includePaths, useExtensionPath);
    }

    public function parseShaderElements(element:Access, basePath:String = ""):Void {
        var path = "";
        var targetPath = "";
        var type = null;

        if (element.has.path) {
            path = Path.combine(basePath, substitute(element.att.path));
        }

        if (element.has.rename) {
            targetPath = substitute(element.att.rename);
        }else if (element.has.path) {
            targetPath = substitute(element.att.path);
        }

        trace("path: " + path);
        trace("targetPath: " + targetPath);
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
            shaders.push(path);

            __dirtyShader = true;
            parseShaderElements(element, extensionPath);
        }

        return isElement;
    }
}