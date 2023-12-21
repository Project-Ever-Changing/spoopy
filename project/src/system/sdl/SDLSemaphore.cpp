#include <system/Semaphore.h>
#include "SDLScopeLockRaw.h"

namespace lime { namespace spoopy {
    Semaphore::Semaphore() {
        __mutex = SDL_CreateMutex();
        __cond = SDL_CreateCond();
        __set = false;
        __valid = true;
    }

    Semaphore::~Semaphore() {
        Destroy();
    }

    void Semaphore::Set() {
        ScopeLock lock(__mutex);

        if(!__set) {
            __set = true;
            SDL_CondSignal(__cond);
        }
    }

    void Semaphore::Wait() {
        ScopeLock lock(__mutex);

        while(!__set) {
            SDL_CondWait(__cond, __mutex);
        }

        __set = false;
    }

    void Semaphore::Destroy() {
        if(__destroyed) return;
        __destroyed = true;

        SDL_DestroyMutex(__mutex);

        if (__valid) {
            __valid = false;
            SDL_DestroyCond(__cond);
        }
    }
}}