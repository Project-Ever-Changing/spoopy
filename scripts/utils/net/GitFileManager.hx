package utils.net;

import haxe.net.WebSocket;
import haxe.io.BytesInput;
import haxe.io.BytesBuffer;
import haxe.io.Output;
import haxe.zip.Reader;
import haxe.zip.Entry;

import sys.FileSystem;

import lime.utils.Bytes as LimeBytes;

class GitFileManager {
    public static inline function download(url:String, downloadPath:String):Void {
        var ws:WebSocket = WebSocket.create(url);

        ws.onopen = function() {
            ws.sendString("download_git_project");
        };

        ws.onmessageBytes = function(message) {
            var reader = new Reader(new BytesInput(message));
            var entryList:List<Entry> = reader.read();

            for(entry in entryList) {
                trace(entry.fileName);
            }
        }

        #if sys
        while (true) {
            ws.process();
            Sys.sleep(0.1);
        }
        #end
    }
}