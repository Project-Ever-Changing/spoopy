#pragma once

#include <system/Mutex.h>

namespace lime { namespace spoopy {
    class ScopeLock {
        public:
            ScopeLock(const Mutex& mutex);
            ~ScopeLock();

            ScopeLock(const ScopeLock&) = delete;
            ScopeLock& operator=(const ScopeLock&) = delete;

        private:
            const Mutex* mutex;
    };
}}