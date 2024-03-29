#pragma once

#include <system/CFFI.h>
#include <system/ValuePointer.h>
#include <system/ConcurrentQueue.h>
#include <system/Mutex.h>
#include <SDL_thread.h>
#include <spoopy.h>

namespace lime { namespace spoopy {
    class Engine {
        public:
            Engine();
            ~Engine();

            int Run();
            void BindCallbacks(value updateCallback, value drawCallback, value syncGC);
            void BindCallbacks(vclosure* updateCallback, vclosure* drawCallback, vclosure* syncGC);
            void Apply(bool __cpuLimiterEnabled, float updateFPS, float drawFPS, float timeScale);
            // static void Apply(float updateFPS, float drawFPS, float physicsFPS, float timeScale); --TODO: Implement physics
            void RequestExit();

            bool RanMain() { return ranMain; }
            bool IsCpuLimiterEnabled() { return cpuLimiterEnabled; }

            SDL_Thread* thread;
        public:
            static Engine *GetInstance() { return INSTANCE; }
            static bool ShouldQuit() { return requestingExit; }

        private:
            class ThreadData {
                public:
                    ThreadData(value updateCallback, value drawCallback, value syncGC);
                    ThreadData(vclosure* updateCallback, vclosure* drawCallback, vclosure* syncGC);
                    ~ThreadData();

                private:
                    friend class Engine;

                    ValuePointer* updateCallback;
                    ValuePointer* drawCallback;
		    ValuePointer* syncGC;
            };

        private:
            ThreadData* threadData;

            bool ranMain;
            bool cpuLimiterEnabled;
            Mutex engineMutex;

            static Engine* INSTANCE;
            static bool requestingExit;
    };
}}
