package;

import haxe.Serializer;
import haxe.Unserializer;
import haxe.rtti.Meta;
import hxp.*;
import lime.system.CFFI;
import lime.tools.*;
import sys.io.File;
import sys.io.Process;
import sys.FileSystem;
import utils.publish.*;
import utils.CreateTemplate;
import utils.JavaExternGenerator;
import utils.PlatformSetup;

/*
* Directly copied from
* https://github.com/openfl/lime/blob/develop/tools/CommandLineTools.hx
*/

class LimeTools {
    private var targetFlags:Map<String, String>;

    public function new() {
        targetFlags = new Map<String, String>();
    }

    public function initializeProject(project:HXProject = null, targetName:String = ""):HXProject {
        Log.info("", Log.accentColor + "Initializing project..." + Log.resetColor);

		var projectFile = "";

		if (project == null) {
			if (words.length == 2) {
				if (FileSystem.exists(words[0])) {
					if (FileSystem.isDirectory(words[0])) {
						projectFile = findProjectFile(words[0]);
					}else {
						projectFile = words[0];
					}
				}

				if (targetName == "") {
					targetName = words[1].toLowerCase();
				}
			}else {
				projectFile = findProjectFile(Sys.getCwd());

				if (targetName == "") {
					targetName = words[0].toLowerCase();
				}
			}

			if (projectFile == "") {
				Log.error("You must have a \"project.xml\" file or specify another valid project file when using the '" + command + "' command");
				return null;
			}else {
				Log.info("", Log.accentColor + "Using project file: " + projectFile + Log.resetColor);
			}
		}

		if (runFromHaxelib && !targetFlags.exists("nolocalrepocheck")) {
			try {
				var forceGlobal = (overrides.haxeflags.indexOf("--global") > -1);
				var projectDirectory = Path.directory(projectFile);
				var localRepository = Path.combine(projectDirectory, ".haxelib");

				if (!forceGlobal && FileSystem.exists(localRepository) && FileSystem.isDirectory(localRepository)) {
					var overrideExists = Haxelib.pathOverrides.exists("lime");
					var cacheOverride = Haxelib.pathOverrides.get("lime");
					Haxelib.pathOverrides.remove("lime");

					var workingDirectory = Sys.getCwd();
					Sys.setCwd(projectDirectory);

					var limePath = Haxelib.getPath(new Haxelib("lime"), true, true);
					var toolsPath = Haxelib.getPath(new Haxelib("lime-tools"));

					Sys.setCwd(workingDirectory);

					if (!StringTools.startsWith(toolsPath, limePath)) {
						Log.info("", Log.accentColor + "Requesting alternate tools from .haxelib repository...\x1b[0m\n\n");

						var args = Sys.args();
						args.pop();

						Sys.setCwd(limePath);

						args = [Path.combine(limePath, "run.n")].concat(args);
						args.push("--haxelib-lime=" + limePath);
						args.push("-nolocalrepocheck");
						args.push(workingDirectory);

						Sys.exit(Sys.command("neko", args));
						return null;
					}

					if (overrideExists) {
						Haxelib.pathOverrides.set("lime", cacheOverride);
					}
				}
			}
			catch (e:Dynamic) {}
		}

		if (targetFlags.exists("air")) {
			switch (targetName) {
				case "android":
					targetName = "air";
					targetFlags.set("android", "");

				case "ios":
					targetName = "air";
					targetFlags.set("ios", "");

				case "windows":
					targetName = "air";
					targetFlags.set("windows", "");

				case "mac", "macos":
					targetName = "air";
					targetFlags.set("mac", "");
			}
		}

		var target:Platform = null;

		switch (targetName) {
			case "cpp":
				target = cast System.hostPlatform;
				targetFlags.set("cpp", "");

			case "neko":
				target = cast System.hostPlatform;
				targetFlags.set("neko", "");

			case "hl", "hashlink":
				target = cast System.hostPlatform;
				targetFlags.set("hl", "");

			case "cppia":
				target = cast System.hostPlatform;
				targetFlags.set("cppia", "");

			case "java":
				target = cast System.hostPlatform;
				targetFlags.set("java", "");

			case "nodejs":
				target = cast System.hostPlatform;
				targetFlags.set("nodejs", "");

			case "cs":
				target = cast System.hostPlatform;
				targetFlags.set("cs", "");

			case "iphone", "iphoneos":
				target = Platform.IOS;

			case "iphonesim":
				target = Platform.IOS;
				targetFlags.set("simulator", "");

			case "electron":
				target = Platform.HTML5;
				targetFlags.set("electron", "");

			case "firefox", "firefoxos":
				target = Platform.FIREFOX;
				overrides.haxedefs.set("firefoxos", "");

			case "mac", "macos":
				target = Platform.MAC;
				overrides.haxedefs.set("macos", "");

			case "rpi", "raspberrypi":
				target = Platform.LINUX;
				targetFlags.set("rpi", "");

			case "webassembly", "wasm":
				target = Platform.EMSCRIPTEN;
				targetFlags.set("webassembly", "");

			case "winjs", "uwp":
				target = Platform.WINDOWS;
				targetFlags.set("uwp", "");
				targetFlags.set("winjs", "");

			case "winrt":
				target = Platform.WINDOWS;
				targetFlags.set("winrt", "");

			default:
				target = cast targetName.toLowerCase();
		}

		HXProject._command = command;
		HXProject._debug = debug;
		HXProject._environment = environment;
		HXProject._target = target;
		HXProject._targetFlags = targetFlags;
		HXProject._userDefines = userDefines;

		var config = ConfigHelper.getConfig();

		if (config != null) {
			for (define in config.defines.keys()) {
				if (define == define.toUpperCase()) {
					var value = config.defines.get(define);

					switch (define) {
						case "ANT_HOME":
							if (value == "/usr") {
								value = "/usr/share/ant";
							}

							if (FileSystem.exists(value)) {
								Sys.putEnv(define, value);
							}

						case "JAVA_HOME":
							if (FileSystem.exists(value)) {
								Sys.putEnv(define, value);
							}

						default:
							Sys.putEnv(define, value);
					}
				}
			}
		}

		if (System.hostPlatform == WINDOWS) {
			if (environment.get("JAVA_HOME") != null) {
				var javaPath = Path.combine(environment.get("JAVA_HOME"), "bin");
				var value;

				if (System.hostPlatform == WINDOWS) {
					value = javaPath + ";" + Sys.getEnv("PATH");
				}else {
					value = javaPath + ":" + Sys.getEnv("PATH");
				}

				environment.set("PATH", value);
				Sys.putEnv("PATH", value);
			}
		}

		try {
			var process = new Process("haxe", ["-version"]);
			var haxeVersion = StringTools.trim(process.stderr.readAll().toString());

			if (haxeVersion == "") {
				haxeVersion = StringTools.trim(process.stdout.readAll().toString());
			}

			process.close();

			environment.set("haxe", haxeVersion);
			environment.set("haxe_ver", haxeVersion);

			environment.set("haxe" + haxeVersion.split(".")[0], "1");
		}catch (e:Dynamic) {}

		if (!environment.exists("HAXE_STD_PATH")) {
			if (System.hostPlatform == WINDOWS) {
				environment.set("HAXE_STD_PATH", "C:\\HaxeToolkit\\haxe\\std\\");
			}else {
				if (FileSystem.exists("/usr/lib/haxe")) {
					environment.set("HAXE_STD_PATH", "/usr/lib/haxe/std");
				}else if (FileSystem.exists("/usr/share/haxe")) {
					environment.set("HAXE_STD_PATH", "/usr/share/haxe/std");
				}else {
					environment.set("HAXE_STD_PATH", "/usr/local/lib/haxe/std");
				}
			}
		}

		if (project == null) {
			HXProject._command = command;
			HXProject._debug = debug;
			HXProject._environment = environment;
			HXProject._target = target;
			HXProject._targetFlags = targetFlags;
			HXProject._userDefines = userDefines;

			try {
				Sys.setCwd(Path.directory(projectFile));
			}
			catch (e:Dynamic) {}

			if (Path.extension(projectFile) == "lime" || Path.extension(projectFile) == "nmml" || Path.extension(projectFile) == "xml") {
				project = new ProjectXMLParser(Path.withoutDirectory(projectFile), userDefines, includePaths);
			}else if (Path.extension(projectFile) == "hxp") {
				project = HXProject.fromFile(projectFile, userDefines, includePaths);

				if (project != null) {
					project.command = command;
					project.debug = debug;
					project.target = target;
					project.targetFlags = targetFlags;
				}else {
					Log.error("Could not process \"" + projectFile + "\"");
					return null;
				}
			}
		}

		if (project != null && project.needRerun && !project.targetFlags.exists("norerun")) {
			Haxelib.pathOverrides.remove("lime");
			var workingDirectory = Sys.getCwd();
			var limePath = Haxelib.getPath(new Haxelib("lime"), true, true);
			Sys.setCwd(workingDirectory);

			Log.info("", Log.accentColor + "Requesting alternate tools from custom haxelib path...\x1b[0m\n\n");

			var args = Sys.args();
			args.pop();

			Sys.setCwd(limePath);

			args = [Path.combine(limePath, "run.n")].concat(args);
			args.push("--haxelib-lime=" + limePath);
			args.push("-norerun");
			args.push(workingDirectory);

			Sys.exit(Sys.command("neko", args));
			return null;
		}

		if (project == null || (command != "rebuild" && project.sources.length == 0 && !FileSystem.exists(project.app.main + ".hx"))) {
			Log.error("You must have a \"project.xml\" file or specify another valid project file when using the '" + command + "' command");
			return null;
		}

		if (config != null) {
			config.merge(project);
			project = config;
		}

		project.haxedefs.set("tools", version);

		project.merge(overrides);

		for (haxelib in project.haxelibs) {
			if (haxelib.name == "lime" && haxelib.version != null && haxelib.version != "" && haxelib.version != "dev" && !haxelib.versionMatches(version)) {
				if (!project.targetFlags.exists("notoolscheck")) {
					if (targetFlags.exists("openfl")) {
						for (haxelib in project.haxelibs) {
							if (haxelib.name == "openfl") {
								Haxelib.setOverridePath(haxelib, Haxelib.getPath(haxelib));
							}
						}
					}

					Log.info("", Log.accentColor + "Requesting tools version " + getToolsVersion(haxelib.version) + "...\x1b[0m\n\n");

					Haxelib.pathOverrides.remove("lime");
					var path = Haxelib.getPath(haxelib);

					var args = Sys.args();
					var workingDirectory = args.pop();

					for (haxelib in project.haxelibs) {
						args.push("--haxelib-" + haxelib.name + "=" + Haxelib.getPath(haxelib));
					}

					args.push("-notoolscheck");

					Sys.setCwd(path);
					var args = [Path.combine(path, "run.n")].concat(args);
					args.push(workingDirectory);

					Sys.exit(Sys.command("neko", args));
					return null;

					// var args = [ "run", "lime:" + haxelib.version ].concat (args);
					// Sys.exit (Sys.command ("haxelib", args));
				}else {
					if (Std.string(version) != Std.string(Haxelib.getVersion(haxelib))) {
						Log.warn("", Log.accentColor + "Could not switch to requested tools version\x1b[0m");
					}
				}
			}
		}

		if (overrides.architectures.length > 0) {
			project.architectures = overrides.architectures;
		}

		for (key in projectDefines.keys()) {
			var components = key.split("-");
			var field = components.shift().toLowerCase();
			var attribute = "";

			if (components.length > 0) {
				for (i in 1...components.length) {
					components[i] = components[i].substr(0, 1).toUpperCase() + components[i].substr(1).toLowerCase();
				}

				attribute = components.join("");
			}

			if (field == "template" && attribute == "path") {
				project.templatePaths.push(projectDefines.get(key));
			}
			else if (field == "config") {
				project.config.set(attribute, projectDefines.get(key));
			}else {
				if (Reflect.hasField(project, field)) {
					var fieldValue = Reflect.field(project, field);
					var typeValue:Dynamic = switch (field) {
						case "app": ApplicationData.expectedFields;
						case "meta": MetaData.expectedFields;
						case "window": WindowData.expectedFields;
						default: fieldValue;
					};

					if (Reflect.hasField(typeValue, attribute)) {
						if ((Reflect.field(typeValue, attribute) is String)) {
							Reflect.setField(fieldValue, attribute, projectDefines.get(key));
						}
						else if ((Reflect.field(typeValue, attribute) is Float)) {
							Reflect.setField(fieldValue, attribute, Std.parseFloat(projectDefines.get(key)));
						}
						else if ((Reflect.field(typeValue, attribute) is Bool)) {
							Reflect.setField(fieldValue, attribute, (projectDefines.get(key).toLowerCase() == "true"
								|| projectDefines.get(key) == "1"));
						}
					}
				}else {
					project.targetFlags.set(key, projectDefines.get(key));
					targetFlags.set(key, projectDefines.get(key));
				}
			}
		}

		MapTools.copyKeysDynamic(userDefines, project.haxedefs);

		getBuildNumber(project, (project.command == "build" || project.command == "test"));

		return project;
    }

    private function getBuildNumber(project:HXProject, increment:Bool = true):Void {
        var buildNumber = project.meta.buildNumber;

        if (buildNumber == null || StringTools.startsWith(buildNumber, "git")) {
            buildNumber = getBuildNumber_GIT(project, increment);
        }

        if (buildNumber == null || StringTools.startsWith(buildNumber, "svn")) {
            buildNumber = getBuildNumber_SVN(project, increment);
        }

        if (buildNumber == null || buildNumber == ".build") {
            var versionFile = Path.combine(project.app.path, ".build");
            var version = 1;

            try {
                if (FileSystem.exists(versionFile)) {
                    var previousVersion = Std.parseInt(File.getBytes(versionFile).toString());

                    if (previousVersion != null) {
                        version = previousVersion;

                        if (increment) {
                            version++;
                        }
                    }
                }
            }
            catch (e:Dynamic) {}

            project.meta.buildNumber = Std.string(version);

            if (increment) {
                try {
                    System.mkdir(project.app.path);

                    var output = File.write(versionFile, false);
                    output.writeString(Std.string(version));
                    output.close();
                }
                catch (e:Dynamic) {}
            }
        }
    }

    private function getBuildNumber_GIT(project:HXProject, increment:Bool = true):String {
        var cache = Log.mute;
        Log.mute = true;

        var output = System.runProcess("", "git", ["rev-list", "HEAD", "--count"], true, true, true);

        Log.mute = cache;

        if (output != null) {
            var value = Std.parseInt(output);

            if (value != null) {
                var buildNumber = project.meta.buildNumber;

                if (buildNumber != null && buildNumber.indexOf("+") > -1) {
                    var modifier = Std.parseInt(buildNumber.substr(buildNumber.indexOf("+") + 1));

                    if (modifier != null) {
                        value += modifier;
                    }
                }

                return project.meta.buildNumber = Std.string(value);
            }
        }

        return null;
    }

    private function getBuildNumber_SVN(project:HXProject, increment:Bool = true):String {
        var cache = Log.mute;
        Log.mute = true;

        var output = System.runProcess("", "svn", ["info"], true, true, true);

        Log.mute = cache;

        if (output != null) {
            var searchString = "Revision: ";
            var index = output.indexOf(searchString);

            if (index > -1) {
                var value = Std.parseInt(output.substring(index + searchString.length, output.indexOf("\n", index)));

                if (value != null) {
                    var buildNumber = project.meta.buildNumber;

                    if (buildNumber != null && buildNumber.indexOf("+") > -1) {
                        var modifier = Std.parseInt(buildNumber.substr(buildNumber.indexOf("+") + 1));

                        if (modifier != null) {
                            value += modifier;
                        }
                    }

                    return project.meta.buildNumber = Std.string(value);
                }
            }
        }

        return null;
    }
}