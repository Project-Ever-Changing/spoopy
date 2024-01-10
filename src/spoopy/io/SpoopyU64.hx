package spoopy.io;

#if (!cpp || cppia)
typedef SpoopyU64 = haxe.Int64;
#else
@:native("uint64_t")
extern class SpoopyU64 {}
#end