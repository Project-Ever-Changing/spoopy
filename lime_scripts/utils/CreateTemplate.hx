package utils;

import hxp.*;
import lime.tools.HXProject;
import lime.tools.ProjectHelper;
import utils.SpoopyLibInfo;
import sys.FileSystem;

/*
* Slighty modified version of:
* https://github.com/openfl/lime/blob/master/tools/utils/CreateTemplate.hx
*/
@:access(lime.tools.HXProject)
class CreateTemplate {
	public static function createProject(words:Array<String>, userDefines:Map<String, Dynamic>, overrides:HXProject):Void
	{
		var colonIndex = words[0].indexOf(":");

		var projectName = null;
		var sampleName = null;
		var outputName = "SampleProject";

		if (colonIndex == -1)
		{
			projectName = words[0];

			if (words.length > 1)
			{
				sampleName = words[1];
			}

			if (words.length > 2)
			{
				outputName = words[2];
			}
		}
		else
		{
			projectName = words[0].substring(0, colonIndex);
			sampleName = words[0].substr(colonIndex + 1);

			if (words.length > 1)
			{
				outputName = words[1];
			}
		}

		if (projectName == "project")
		{
			projectName = SpoopyLibInfo.defaultLibrary;

			if (sampleName != null)
			{
				outputName = sampleName;
			}
		}

		if (projectName == null || projectName == "")
		{
			projectName = SpoopyLibInfo.defaultLibrary;
		}

		if (projectName != null && projectName != "")
		{
			var defines = new Map<String, Dynamic>();
			var project = HXProject.fromHaxelib(new Haxelib(projectName), defines);

			if(project.templatePaths.length == 0) {
				project.templatePaths = [Sys.getCwd() + "templates"];
			}

			if (project != null)
			{
				var company = "Company Name";

				/*if (words.length > 2) {

					company = words[2];

				}*/

				var context:Dynamic = {};

				var name = outputName;
				// var name = words[1].split (".").pop ();
				var alphaNumeric = new EReg("[a-zA-Z0-9]", "g");
				var title = "";
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

				var file = StringTools.replace(title, " ", "");

				var id = ["com", "sample", file.toLowerCase()];

				/*if (colonIndex != -1 && words.length > 1 || ) {

					var name = words[1];
					name = new EReg ("[^a-zA-Z0-9.]", "g").replace (name, "");
					id = name.split (".");

					if (id.length < 3) {

						id = [ "com", "example" ].concat (id);

					}

				}*/

				var packageName = id.join(".").toLowerCase();
				var version = "1.0.0";

				if (overrides != null)
				{
					if (Reflect.hasField(overrides.meta, "packageName"))
					{
						packageName = overrides.meta.packageName;
					}

					if (Reflect.hasField(overrides.meta, "title"))
					{
						title = overrides.meta.title;
					}

					if (Reflect.hasField(overrides.meta, "version"))
					{
						version = overrides.meta.version;
					}

					if (Reflect.hasField(overrides.meta, "company"))
					{
						company = overrides.meta.company;
					}

					if (Reflect.hasField(overrides.app, "file"))
					{
						file = overrides.app.file;
					}
				}

				project.meta.title = title;
				project.meta.packageName = packageName;
				project.meta.version = version;
				project.meta.company = company;
				project.app.file = file;

				context.title = title;
				context.packageName = packageName;
				context.version = version;
				context.company = company;
				context.file = file;

				for (define in userDefines.keys())
				{
					Reflect.setField(context, define, userDefines.get(define));
				}

				var folder = name;

				if (colonIndex > -1)
				{
					if (words.length > 1)
					{
						folder = Path.tryFullPath(words[1]);
					}
				}
				else
				{
					if (words.length > 2)
					{
						folder = Path.tryFullPath(words[2]);
					}
				}

				/*if (words.length > 2) {

					folder = Path.tryFullPath (words[2]);

				}*/
				
				System.mkdir(folder);
				ProjectHelper.recursiveSmartCopyTemplate(project, "project", "hehe", context);

				return;
			}
		}

		Log.error("Could not find project \"" + projectName + "\"");
	}

	public static function createSample(words:Array<String>, userDefines:Map<String, Dynamic>)
	{
		var colonIndex = words[0].indexOf(":");

		var projectName = null;
		var sampleName = null;
		var outputPath = null;

		if (colonIndex == -1 && words.length > 1)
		{
			projectName = words[0];
			sampleName = words[1];

			if (words.length > 2)
			{
				outputPath = words[2];
			}
		}
		else
		{
			projectName = words[0].substring(0, colonIndex);
			sampleName = words[0].substr(colonIndex + 1);

			if (words.length > 1)
			{
				outputPath = words[1];
			}
		}

		if (projectName == null || projectName == "")
		{
			projectName = SpoopyLibInfo.defaultLibrary;
		}

		if (sampleName == null || sampleName == "")
		{
			Log.error("You must specify a sample name to copy when using \"" + SpoopyLibInfo.commandName + " create\"");
			return;
		}

		var defines = new Map<String, Dynamic>();
		defines.set("create", 1);
		var project = HXProject.fromHaxelib(new Haxelib(projectName), defines);

		if (project == null && outputPath == null)
		{
			outputPath = sampleName;
			sampleName = projectName;
			projectName = SpoopyLibInfo.defaultLibrary;
			project = HXProject.fromHaxelib(new Haxelib(projectName), defines);
		}

		if (project != null)
		{
			if (outputPath == null)
			{
				outputPath = sampleName;
			}

			var samplePaths = project.samplePaths.copy();
			samplePaths.reverse();

			for (samplePath in samplePaths)
			{
				var sourcePath = Path.combine(samplePath, sampleName);

				if (FileSystem.exists(sourcePath))
				{
					System.mkdir(outputPath);
					System.recursiveCopy(sourcePath, Path.tryFullPath(outputPath));
					return;
				}
			}
		}

		Log.error("Could not find sample \"" + sampleName + "\" in project \"" + projectName + "\"");
	}

	public static function listSamples(projectName:String, userDefines:Map<String, Dynamic>)
	{
		var templates = [];

		if (projectName != null && projectName != "")
		{
			var defines = new Map<String, Dynamic>();
			defines.set("create", 1);
			var project = HXProject.fromHaxelib(new Haxelib(projectName), defines);

			if (project != null)
			{
				var samplePaths = project.samplePaths.copy();

				if (samplePaths.length > 0)
				{
					samplePaths.reverse();

					for (samplePath in samplePaths)
					{
						var path = Path.tryFullPath(samplePath);
						if (!FileSystem.exists(path)) continue;

						for (name in FileSystem.readDirectory(path))
						{
							if (!StringTools.startsWith(name, ".") && FileSystem.isDirectory(path + "/" + name))
							{
								templates.push(name);
							}
						}
					}
				}

				/*templates.push ("extension");

					var projectTemplate = System.findTemplate (project.templatePaths, "project", false);

					if (projectTemplate != null) {

						templates.push ("project");

				}*/
			}
		}

		if (templates.length == 0)
		{
			projectName = SpoopyLibInfo.defaultLibrary;
		}

		Log.println("\x1b[1mYou must specify a template when using the 'create' command.\x1b[0m");
		Log.println("");

		if (projectName == SpoopyLibInfo.commandName)
		{
			Log.println(" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + SpoopyLibInfo.commandName + "\x1b[0m create project (directory)");
			Log.println(" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + SpoopyLibInfo.commandName + "\x1b[0m create extension (directory)");
		}

		Log.println(" "
			+ Log.accentColor
			+ "Usage:\x1b[0m \x1b[1m"
			+ SpoopyLibInfo.commandName
			+ "\x1b[0m create "
			+ (projectName != SpoopyLibInfo.commandName ? projectName + " " : "")
			+ "<sample> (directory)");

		if (templates.length > 0)
		{
			Log.println("");
			Log.println(" " + Log.accentColor + "Available samples:\x1b[0m");
			Log.println("");

			for (template in templates)
			{
				Sys.println("  * " + template);
			}
		}

		Sys.println("");
	}
}