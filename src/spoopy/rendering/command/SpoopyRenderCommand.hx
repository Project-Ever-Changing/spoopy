package spoopy.rendering.command;

class SpoopyRenderCommand {
    public var globalOrder(get, never):Float;

    @:noCompletion var __globalOrder:Float = 0;

    private function new() {
        /* Empty */
    }

    @:noCompletion private function get_globalOrder():Float {
        return __globalOrder;
    }
}