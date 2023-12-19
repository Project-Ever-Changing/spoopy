#pragma once

#include <system/CFFI.h>
#include <system/ValuePointer.h>
#include <system/ConcurrentQueue.h>
#include <system/Mutex.h>
#include <SDL_thread.h>
#include <spoopy.h>

namespace lime { namespace spoopy {

    /*
     * There is no need to make a class for this, as it is only used in one place.
     */
    struct ThreadData {
        std::shared_ptr<ValuePointer> updateCallback;
        std::shared_ptr<ValuePointer> drawCallback;
    };

    class Engine {
        public:
            Engine();

            void Main(bool __cpuLimiterEnabled, value updateCallback, value drawCallback);
            void Main(bool __cpuLimiterEnabled, vclosure* updateCallback, vclosure* drawCallback);
            void Apply(float updateFPS, float drawFPS, float timeScale);
            void DequeueAll();
            // static void Apply(float updateFPS, float drawFPS, float physicsFPS, float timeScale); --TODO: Implement physics
            void RequestExit();

            bool RanMain() { return ranMain; }

            ConcurrentQueue<std::shared_ptr<ValuePointer>> tasks;

        public:
            static Engine *GetInstance() { return INSTANCE; }

            static bool ShouldQuit() { return requestingExit; }
            static bool IsCpuLimiterEnabled() { return cpuLimiterEnabled; }

        private:
            SDL_Thread* renderThread;

            bool ranMain;
            Mutex engineMutex;
            Mutex taskMutex;

            static Engine* INSTANCE;
            static bool cpuLimiterEnabled;
            static bool requestingExit;
    };
}}