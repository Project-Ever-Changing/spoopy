#include <utils/Time.h>

#include <math.h>

namespace lime { namespace spoopy {
    float Timer::UpdateFPS = 60.0f;
    float Timer::DrawFPS = 60.0f;
    float Timer::TimeScale = 1.0f;

    double Timer::ReciprocalUpdateFPS = 1.0 / 60.0;
    double Timer::ReciprocalDrawFPS = 1.0 / 60.0;

    Timer::TickStruct Timer::UpdateTick;
    Timer::TickStruct Timer::DrawTick;


    double Timer::GetTimeSeconds() {
        return SDL_GetTicks64() * 0.001;
    }


    bool Timer::TickStruct::OnTickBegin(double reciprocalTargetFPS, float maxDeltaTime) {
        const double time = GetTimeSeconds();
        double deltaTime;

        if(time < NextBegin) return false;
        deltaTime = fmax((time - LastBegin), 0.0);

        if(deltaTime > maxDeltaTime) NextBegin = time;

        NextBegin += reciprocalTargetFPS * (time - NextBegin);
        LastBegin = time;

        return true;
    }

    void Timer::TickStruct::OnBeforeRun(double reciprocalTargetFPS, double currentTime) {
        LastLength = reciprocalTargetFPS;
        LastBegin = currentTime - LastLength;
        LastEnd = currentTime;
        NextBegin = LastBegin + reciprocalTargetFPS;
    }

    void Timer::OnBeforeRun() {
        const double time = GetTimeSeconds();

        UpdateTick.OnBeforeRun(ReciprocalUpdateFPS, time);
        DrawTick.OnBeforeRun(ReciprocalDrawFPS, time);
    }

    double Timer::GetNextTick() {
        double nextTick = MAX_DOUBLE;

        if (UpdateFPS > EPSILON && UpdateTick.NextBegin < nextTick) nextTick = UpdateTick.NextBegin;
        if (DrawFPS > EPSILON && DrawTick.NextBegin < nextTick) nextTick = DrawTick.NextBegin;
        if (nextTick == MAX_DOUBLE) nextTick = 0.0;

        return nextTick;
    }
}}