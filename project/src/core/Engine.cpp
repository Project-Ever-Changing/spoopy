#include <core/Engine.h>
#include <utils/Time.h>

namespace lime { namespace spoopy {
    inline void Engine::Main(bool __cpuLimiterEnabled) {
        cpuLimiterEnabled = __cpuLimiterEnabled;
        requestingExit = false;

        renderThread = SDL_CreateThread(Run, "RenderThread", nullptr);
    }

    inline int Engine::Run(void* data) {
        Timer::OnBeforeRun();

        while(!ShouldQuit()) {
            if(cpuLimiterEnabled && Timer::UpdateFPS > EPSILON) {
                double nextTick = Timer::GetNextTick();
                double inBetween = nextTick - Timer::GetTimeSeconds();

                if(inBetween > 0.002) sleep(inBetween);
            }

            if(Timer::UpdateTick.OnTickBegin(Timer::ReciprocalUpdateFPS, MAX_UPDATE_DELTA_TIME)) {
                // Updater
            }
        }

        return 0;
    }

    inline void Engine::Apply(float updateFPS, float drawFPS, float timeScale) {
        engineMutex.Lock();

        Timer::TimeScale = timeScale;
        Timer::UpdateFPS = updateFPS;
        Timer::DrawFPS = drawFPS;

        Timer::ReciprocalUpdateFPS = updateFPS > EPSILON ? 1.0f / updateFPS : 0.0f;
        Timer::ReciprocalDrawFPS = drawFPS > EPSILON ? 1.0f / drawFPS : 0.0f;

        engineMutex.Unlock();
    }

    void Engine::RequestExit() {
        if(requestingExit) return;

        engineMutex.Lock();

        requestingExit = true;
        SDL_WaitThread(renderThread, nullptr);

        engineMutex.Unlock();
    }

    inline bool Engine::ShouldQuit() {
        return requestingExit;
    }
}}