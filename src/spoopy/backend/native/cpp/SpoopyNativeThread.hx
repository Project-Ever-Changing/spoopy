package spoopy.backend.native.cpp;

#if windows
@:native("DWORD WINAPI")
#else
@:native("void*")
#end
@:unreflective
extern class ThreadFunctionType {}