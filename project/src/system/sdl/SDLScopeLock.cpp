#include <system/ScopeLock.h>

namespace lime { namespace spoopy {
    ScopeLock::ScopeLock(const Mutex& mutex) : __mutex(&mutex) {
        __mutex->Lock();
    }

    ScopeLock::~ScopeLock() {
        __mutex->Unlock();
    }
}}