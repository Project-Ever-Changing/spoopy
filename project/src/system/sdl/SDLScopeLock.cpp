#include <system/ScopeLock.h>

namespace lime { namespace spoopy {
    ScopeLock::ScopeLock(const Mutex& mutex) : mutex(&mutex) {
        mutex->Lock();
    }

    ScopeLock::~ScopeLock() {
        mutex->Unlock();
    }
}}