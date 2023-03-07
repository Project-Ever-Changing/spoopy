package utils;

import haxe.Json;
import massive.sys.io.File as MassiveFile;
import massive.sys.io.FileSys;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

using StringTools;

class PathUtils {
	/**
	 * Get the path of a Haxelib on the current system
	 * @param  name String of the Haxelib to scan for
	 * @return	  String path of the Haxelib or "" if none found
	 */
	public static function getHaxelibPath(name:String):String
	{
		final proc = new Process("haxelib", ["path", name]);
		var result = "";

		try {
			var previous = "";
			while (true) {
				final line:String = proc.stdout.readLine();
				if (line.startsWith('-D $name')) {
					result = previous;
					break;
				}
				previous = line;
			}
		}
		catch (e:Dynamic) {}
		proc.close();

		return result;
	}

	/**
	 * Shortcut to join paths that is platform safe
	 */
	public static function combine(firstPath:String, secondPath:String):String {
		if (firstPath == null || firstPath == "") {
			return secondPath;
		}else if (secondPath != null && secondPath != "") {
			if (FileSys.isWindows) {
				if (secondPath.indexOf(":") == 1) {
					return secondPath;
				}
			}else if (secondPath.substr(0, 1) == "/") {
				return secondPath;
			}

			final firstSlash:Bool = (firstPath.substr(-1) == "/" || firstPath.substr(-1) == "\\");
			final secondSlash:Bool = (secondPath.substr(0, 1) == "/" || secondPath.substr(0, 1) == "\\");

			if (firstSlash && secondSlash) {
				return firstPath + secondPath.substr(1);
			}else if (!firstSlash && !secondSlash) {
				return firstPath + "/" + secondPath;
			}else {
				return firstPath + secondPath;
			}
		}

		return firstPath;
	}

	/**
	 * Search through every sub directory to find file
	 */
	public static function recursivelyFindFile(path:String, file:String):String {
		var folderIn:String = path;
		var listOfFiles:Array<String> = FileSystem.readDirectory(path);

		for(fileInFolder in listOfFiles) {
			if(!FileSystem.isDirectory(path + "/" + fileInFolder)) {
				if(fileInFolder == file) {
					return folderIn + "/" + file;
				}
			}
		}

		for(fileInFolder in listOfFiles) {
			if(FileSystem.isDirectory(path + "/" + fileInFolder)) {
				folderIn = recursivelyFindFile(path + "/" + fileInFolder, file);

				if(folderIn == null || folderIn == "") {
                    folderIn = path;
                }else {
                    return folderIn;
                }
			}
		}

		return "";
	}

	public static function deleteDirRecursively(path:String):Void {
		if(FileSystem.exists(path) && FileSystem.isDirectory(path)) {
			var entries = FileSystem.readDirectory(path);

			for(entry in entries) {
				if(FileSystem.isDirectory(path + '/' + entry)) {
					deleteDirRecursively(path + '/' + entry);
					FileSystem.deleteDirectory(path + '/' + entry);
				}else {
					FileSystem.deleteFile(path + '/' + entry);
				}
			}
		}
	}
}