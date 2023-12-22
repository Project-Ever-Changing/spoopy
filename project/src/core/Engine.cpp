#include <core/Engine.h>
#include <core/Log.h>
#include <system/ScopeLock.h>
#include <utils/Time.h>

#include <hxcpp.h>

namespace lime { namespace spoopy {
    Engine* Engine::INSTANCE = new Engine();
    bool Engine::requestingExit = false;

    Engine::Engine()
    : ranMain(false)
    , threadData(nullptr)
    , thread(nullptr) {}

    Engine::~Engine() {
        if(threadData != nullptr) delete threadData;
        if(thread != nullptr) SDL_WaitThread(thread, nullptr);
    }

    int Engine::Run() {
        ScopeLock lock(renderMutex);
        Timer::OnBeforeRun();

        while(!Engine::ShouldQuit()) {
            if(Engine::IsCpuLimiterEnabled() && Timer::UpdateFPS > EPSILON) {
                double nextTick = Timer::GetNextTick();
                double inBetween = nextTick - Timer::GetTimeSeconds();

                if(inBetween > 0.002) {
                    SPOOPY_LOG_INFO("Sleep");
                    sleep(inBetween);
                }
            }

            if(Timer::UpdateTick.OnTickBegin(Timer::ReciprocalUpdateFPS, MAX_UPDATE_DELTA_TIME)) {
                threadData->updateCallback->Call();
            }
        }

        delete threadData;
        threadData = nullptr;

        return 0;
    }

    void Engine::BindCallbacks(value updateCallback, value drawCallback) {
        if(threadData != nullptr) return;
        threadData = new ThreadData(updateCallback, drawCallback);
    }

    void Engine::BindCallbacks(vclosure* updateCallback, vclosure* drawCallback) {
        if(threadData != nullptr) return;
        threadData = new ThreadData(updateCallback, drawCallback);
    }

    void Engine::Apply(bool __cpuLimiterEnabled, float updateFPS, float drawFPS, float timeScale) {
        engineMutex.Lock();

        Engine::cpuLimiterEnabled = __cpuLimiterEnabled;

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

        engineMutex.Unlock();
    }

    /*
     * ThreadData
     */
    Engine::ThreadData::ThreadData(value updateCallback, value drawCallback) {
        this->updateCallback = std::make_unique<ValuePointer>(updateCallback);
        this->drawCallback = std::make_unique<ValuePointer>(drawCallback);
    }

    Engine::ThreadData::ThreadData(vclosure* updateCallback, vclosure* drawCallback) {
        this->updateCallback = std::make_unique<ValuePointer>(updateCallback);
        this->drawCallback = std::make_unique<ValuePointer>(drawCallback);
    }

    Engine::ThreadData::~ThreadData() {
        if(this->updateCallback.get() != nullptr) this->updateCallback.reset();
        if(this->drawCallback.get() != nullptr) this->drawCallback.reset();
    }
}}