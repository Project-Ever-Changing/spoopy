package;

import massive.sys.io.FileSys;
import lime.tools.HXProject;
import hxp.Log;

@:access(lime.tools.HXProject)
class SpoopyProject {
    public var project(default, null):HXProject;

    public function new() {
        project = new HXProject();
        project.architectures = [];
    }
}