#pragma once

#include <concurrentqueue.h>
#include <type_traits>

namespace lime { namespace spoopy {
    template<typename T, typename Traits = moodycamel::ConcurrentQueueDefaultTraits>
    class ConcurrentQueue: public moodycamel::ConcurrentQueue<T, Traits> {
        public:
            static_assert(std::is_base_of<moodycamel::ConcurrentQueueDefaultTraits, Traits>::value,
                "Settings must be a derived class of moodycamel::ConcurrentQueueDefaultTraits");

            typedef moodycamel::ConcurrentQueue<T, Traits> Base;
    };
}}