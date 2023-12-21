package spoopy.backend.native;

@:unreflective

#if windows
@:native("DWORD WINAPI")
#else
@:native("void*")
#end
extern class ThreadFunctionType {}