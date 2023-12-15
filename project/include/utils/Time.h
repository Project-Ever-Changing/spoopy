#pragma once

#include <SDL.h>

#define EPSILON 1e-7f
#define MAX_DOUBLE 1.79769313486231570e+308
#define MAX_UPDATE_DELTA_TIME 0.1f

namespace lime { namespace spoopy {

    /*
     * https://learn.microsoft.com/en-us/dotnet/api/system.timespan.ticks?view=net-8.0
     * One singular tick is 100 nanoseconds. This might be useful for some things.
     *
     * Meaning:
     * 10,000 ticks = 1 millisecond
     * 10,000,000 ticks = 1 second
     * And so on.
     */
    namespace TickSpan {
        const uint64_t PerMillisecond = 10000;
        const uint64_t PerSecond = 10000000;
    }

    /*
     * The backend timer for the engine, handling FPS and ticks.
     */
    struct Timer {

        /*
         * Handle ticks for each individual subsystem, such as logic updates and draw updates.
         */
        struct TickStruct {
            double LastBegin;
            double LastEnd;
            double LastLength;
            double NextBegin;

            void OnBeforeRun(double reciprocalTargetFPS, double currentTime);
            bool OnTickBegin(double reciprocalTargetFPS, float maxDeltaTime);
        };

        static float TimeScale;

        static float UpdateFPS;
        static float DrawFPS;
        static double ReciprocalUpdateFPS;
        static double ReciprocalDrawFPS;

        static TickStruct UpdateTick;
        static TickStruct DrawTick;

        /*
         * Get the current time in seconds.
         */
        static inline double GetTimeSeconds();

        /*
         * Get the time of the upcoming tick.
         */
        static inline double GetNextTick();

        /*
         * Set up the timer before the engine starts running.
         */
        static inline void OnBeforeRun();
    };
}}