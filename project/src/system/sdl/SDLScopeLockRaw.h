#pragma once

namespace lime { namespace spoopy {
    class ScopeLock {
        public:
            explicit ScopeLock(SDL_mutex* mutex) : __mutex(mutex) {
                SDL_LockMutex(__mutex);
            }

            ~ScopeLock() {
                SDL_UnlockMutex(__mutex);
            }

            ScopeLock(const ScopeLock&) = delete;
            ScopeLock& operator=(const ScopeLock&) = delete;

        private:
            SDL_mutex* __mutex;
    };
}}
