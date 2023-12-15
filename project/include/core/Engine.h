#pragma once

#include <system/Mutex.h>
#include <SDL_thread.h>
#include <spoopy.h>

namespace lime { namespace spoopy {
    class Engine {
        public:
            Engine();

            void Main(bool __cpuLimiterEnabled);
            void Apply(float updateFPS, float drawFPS, float timeScale);
            // static void Apply(float updateFPS, float drawFPS, float physicsFPS, float timeScale); --TODO: Implement physics
            void RequestExit();

            bool RanMain() { return ranMain; }

            static Engine *GetInstance() { return INSTANCE; }

            static bool ShouldQuit() { return requestingExit; }
            static bool IsCpuLimiterEnabled() { return cpuLimiterEnabled; }
        private:
            SDL_Thread* renderThread;
            Mutex engineMutex;
            bool ranMain;

            static Engine* INSTANCE;
            static bool cpuLimiterEnabled;
            static bool requestingExit;
    };
}}