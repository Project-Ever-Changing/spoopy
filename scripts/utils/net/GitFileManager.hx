package utils.net;

import sys.net.Socket;
import sys.net.Host;
import sys.FileSystem;

import lime.utils.Bytes as LimeBytes;

class GitFileManager {
    public static inline function download(url:String, downloadPath:String):Void {
        var host:Host = new Host(url);
        var gitSocket:Socket = new Socket();

        gitSocket.bind(host, 9418);
    }
}