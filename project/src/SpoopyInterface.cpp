#ifndef INITIALIZED_SPOOPY_BACKEND
    #ifndef STATIC_LINK
    #define IMPLEMENT_API
    #endif

    #if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
    #define NEKO_COMPATIBLE
    #endif

    #define INITIALIZED_SPOOPY_BACKEND
#endif

