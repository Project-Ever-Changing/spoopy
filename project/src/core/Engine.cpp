#include <core/Engine.h>
#include <core/Log.h>
#include <system/ScopeLock.h>
#include <utils/Time.h>

namespace lime { namespace spoopy {
    Engine* Engine::INSTANCE = new Engine();

    bool Engine::cpuLimiterEnabled = true;
    bool Engine::requestingExit = false;

    Mutex Engine::engineMutex;

    static int Run(void* data) {
        Mutex runMutex;
        ScopeLock lock(runMutex);

        ThreadData* threadData = static_cast<ThreadData*>(data);
        //Timer::OnBeforeRun();

        /*
        while(!Engine::ShouldQuit()) {
            if(Engine::IsCpuLimiterEnabled() && Timer::UpdateFPS > EPSILON) {
                double nextTick = Timer::GetNextTick();
                double inBetween = nextTick - Timer::GetTimeSeconds();

                if(inBetween > 0.002) sleep(inBetween);
            }

            if(Timer::UpdateTick.OnTickBegin(Timer::ReciprocalUpdateFPS, MAX_UPDATE_DELTA_TIME)) {
                // Updater

                Engine::engineMutex.Lock();

                SPOOPY_LOG_INFO("Updater");
                threadData->updateCallback->Call();

                Engine::engineMutex.Unlock();
            }
        }
         */

        threadData->updateCallback->Call();

        delete threadData->updateCallback;
        delete threadData->drawCallback;
        delete threadData;

        return 0;
    }

    Engine::Engine(): ranMain(false) {}

    void Engine::Main(bool __cpuLimiterEnabled, value updateCallback, value drawCallback) {
        if(ranMain) return;

        cpuLimiterEnabled = __cpuLimiterEnabled;
        requestingExit = false;

        ThreadData* data = new ThreadData();
        data->updateCallback = new ValuePointer(updateCallback);
        data->drawCallback = new ValuePointer(drawCallback);

        renderThread = SDL_CreateThread(Run, "RenderThread", data);
        ranMain = true;
    }

    /*
     * I got lazy
     */
    void Engine::Main(bool __cpuLimiterEnabled, vclosure* updateCallback, vclosure* drawCallback) {
        if(ranMain) return;

        cpuLimiterEnabled = __cpuLimiterEnabled;
        requestingExit = false;

        ThreadData* data = new ThreadData();
        data->updateCallback = new ValuePointer(updateCallback);
        data->drawCallback = new ValuePointer(updateCallback);

        renderThread = SDL_CreateThread(Run, "RenderThread", data);
        ranMain = true;
    }

    void Engine::Apply(float updateFPS, float drawFPS, float timeScale) {
        Engine::engineMutex.Lock();

        Timer::TimeScale = timeScale;
        Timer::UpdateFPS = updateFPS;
        Timer::DrawFPS = drawFPS;

        Timer::ReciprocalUpdateFPS = updateFPS > EPSILON ? 1.0f / updateFPS : 0.0f;
        Timer::ReciprocalDrawFPS = drawFPS > EPSILON ? 1.0f / drawFPS : 0.0f;

        Engine::engineMutex.Unlock();
    }

    void Engine::RequestExit() {
        if(requestingExit) return;

        Engine::engineMutex.Lock();

        requestingExit = true;
        SDL_WaitThread(renderThread, nullptr);

        Engine::engineMutex.Unlock();
    }
}}