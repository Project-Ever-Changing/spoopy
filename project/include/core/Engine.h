#pragma once

#include <system/Mutex.h>
#include <SDL_thread.h>
#include <spoopy.h>

namespace lime { namespace spoopy {
    class Engine {
        public:
            static inline void Main(bool __cpuLimiterEnabled);
            static inline void Apply(float updateFPS, float drawFPS, float timeScale);
            // static void Apply(float updateFPS, float drawFPS, float physicsFPS, float timeScale); --TODO: Implement physics

            static inline void RequestExit();

            static inline bool ShouldQuit();

        private:
            static inline int Run(void* data);

            static SDL_Thread* renderThread;

            static Mutex engineMutex;
            static bool cpuLimiterEnabled;
            static bool requestingExit;
    };
}}