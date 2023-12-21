package spoopy.backend.native;

#if windows
@:native("DWORD WINAPI")
#else
@:native("void*")
#end
@:unreflective
extern class ThreadFunctionType {}