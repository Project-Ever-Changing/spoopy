#pragma once

#include <SDL_thread.h>

namespace lime { namespace spoopy {
    class Semaphore {
        public:
            Semaphore();
            ~Semaphore();

            void Set();
            void Wait();
        private:
            SDL_cond* __cond;
            SDL_mutex* __mutex;
            bool __set;
            bool __valid;
    };
}}