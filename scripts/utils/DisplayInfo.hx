package utils;

import hxp.*;

typedef CommandLine = {
    var name:String;
    var description:String;
}

class DisplayInfo {
    public function new(commands:Array<CommandLine>) {
        if (System.hostPlatform == WINDOWS) {
			Log.println("");
		}

        Log.println("\x1b[31m @@@@@@   @@@@@@@    @@@@@@    @@@@@@   @@@@@@@   @@@ @@@ \x1b[0m");
        Log.println("\x1b[31m@@@@@@@   @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@ @@@ \x1b[0m");
        Log.println("\x1b[31m!@@       @@!  @@@  @@!  @@@  @@!  @@@  @@!  @@@  @@! !@@ \x1b[0m");
        Log.println("\x1b[31m!@!       !@!  @!@  !@!  @!@  !@!  @!@  !@!  @!@  !@! @!! \x1b[0m");
        Log.println("\x1b[31m!!@@!!    @!@@!@!   @!@  !@!  @!@  !@!  @!@@!@!    !@!@!   \x1b[0m");
        Log.println("\x1b[31m !!@!!!   !!@!!!    !@!  !!!  !@!  !!!  !!@!!!      @!!!   \x1b[0m");
        Log.println("\x1b[31m     !:!  !!:       !!:  !!!  !!:  !!!  !!:         !!:    \x1b[0m");
        Log.println("\x1b[31m    !:!   :!:       :!:  !:!  :!:  !:!  :!:         :!:    \x1b[0m");
        Log.println("\x1b[31m:::: ::    ::       ::::: ::  ::::: ::   ::          ::    \x1b[0m");
        Log.println("\x1b[31m:: : :     :         : :  :    : :  :    :           :     \x1b[0m");

        Log.println("");
        Log.println("");
        Log.println("\x1b[1mSpoopy Engine Command-Line Tools \x1b[0m");
        Log.println("");
        Log.println("\x1b[31m\x1b[1m  Available commands:\x1b[0m");
        Log.println("");

        for(cmd in commands) {
            Log.println("    \x1b[1m" + cmd.name + "\x1b[0m -- " + cmd.description);
        }

        Log.println("");
    }
}