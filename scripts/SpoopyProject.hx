package;

import lime.tools.ProjectHelper;
import massive.sys.io.FileSys;
import lime.tools.HXProject;
import hxp.Log;

using StringTools;

@:access(lime.tools.HXProject)
class SpoopyProject {
    public var project(default, null):HXProject;

    public function new() {
        project = new HXProject();
        project.architectures = [];
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
}