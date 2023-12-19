#include <core/Engine.h>
#include <core/Log.h>
#include <system/ScopeLock.h>
#include <utils/Time.h>

namespace lime { namespace spoopy {
    Engine* Engine::INSTANCE = new Engine();

    bool Engine::cpuLimiterEnabled = true;
    bool Engine::requestingExit = false;

    Mutex renderMutex;

    static int Run(void* data) {
        ScopeLock lock(renderMutex);

        ThreadData* threadData = static_cast<ThreadData*>(data);
        Timer::OnBeforeRun();

        while(!Engine::ShouldQuit()) {
            if(Engine::IsCpuLimiterEnabled() && Timer::UpdateFPS > EPSILON) {
                double nextTick = Timer::GetNextTick();
                double inBetween = nextTick - Timer::GetTimeSeconds();

                if(inBetween > 0.002) sleep(inBetween);
            }

            if(Timer::UpdateTick.OnTickBegin(Timer::ReciprocalUpdateFPS, MAX_UPDATE_DELTA_TIME)) {
                // Updater

                Engine::GetInstance()->tasks.enqueue(threadData->updateCallback);
            }
        }

        threadData->updateCallback.reset();
        threadData->drawCallback.reset();
        delete threadData;

        return 0;
    }

    Engine::Engine(): ranMain(false) {}

    void Engine::Main(bool __cpuLimiterEnabled, value updateCallback, value drawCallback) {
        if(ranMain) return;

        cpuLimiterEnabled = __cpuLimiterEnabled;
        requestingExit = false;

        ThreadData* data = new ThreadData();
        data->updateCallback = std::make_shared<ValuePointer>(updateCallback);
        data->drawCallback = std::make_shared<ValuePointer>(drawCallback);

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
        data->updateCallback = std::make_shared<ValuePointer>(updateCallback);
        data->drawCallback = std::make_shared<ValuePointer>(drawCallback);

        renderThread = SDL_CreateThread(Run, "RenderThread", data);
        ranMain = true;
    }

    void Engine::Apply(float updateFPS, float drawFPS, float timeScale) {
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

    void Engine::DequeueAll() {
        SPOOPY_LOG_INFO("Dequeueing all tasks");

        std::shared_ptr<ValuePointer> task;
        while(tasks.try_dequeue(task)) {
            if(task.get() == nullptr) continue;
            task->Call();
        }
    }
}}