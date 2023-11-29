#include <system/ScopeLock.h>

namespace lime { namespace spoopy {
    ScopeLock::ScopeLock() {
        mutex->Lock();
    }

    ScopeLock::~ScopeLock() {
        mutex->Unlock();
    }
}}