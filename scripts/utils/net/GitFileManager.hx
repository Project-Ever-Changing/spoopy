package utils.net;

import sys.net.Socket;
import sys.net.Host;
import sys.FileSystem;

import lime.utils.Bytes as LimeBytes;

using StringTools;

class GitFileManager {
    public static inline function download(url:String, downloadPath:String):Void {
        var url = "https://github.com";
        var host = new Host(url);
        trace("Hostname: " + host.host); // Output: "github.com"
    }
}