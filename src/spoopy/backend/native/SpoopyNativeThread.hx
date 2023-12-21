package spoopy.backend.native;

#if windows
@:native("DWORD WINAPI")
#else
@:native("void*")
#end
@:headerCode("#include <hx/Thread.h>")
@:unreflective
extern class ThreadFunctionType {}