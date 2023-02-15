package utils.net;

import sys.net.Socket;
import sys.net.Host;
import sys.FileSystem;
import hxp.Log;

import lime.utils.Bytes as LimeBytes;

using StringTools;

class GitFileManager {
    public static inline function download(url:String, downloadPath:String):Void {
        var host = new Host("github.com");
        
        var gitSocket:Socket = new Socket();
        gitSocket.connect(host, 443);
        gitSocket.waitForRead();

        Log.info(gitSocket.read());
    }
}