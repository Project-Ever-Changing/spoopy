package utils.net;

import sys.net.Socket;
import sys.net.Host;
import sys.FileSystem;

import lime.utils.Bytes as LimeBytes;

using StringTools;

class GitFileManager {
    public static inline function download(url:String, downloadPath:String):Void {
        trace(url);

        var host:Host = new Host(url.trim());
        var gitSocket:Socket = new Socket();

        gitSocket.bind(host, 9418);
    }
}