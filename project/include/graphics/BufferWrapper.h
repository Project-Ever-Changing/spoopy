#pragma once

/*
 * Very simple at the moment.
 */

namespace lime { namespace spoopy {
    class LogicalDevice;

    template<typename T> class BufferWrapper {
        public:
            BufferWrapper(const LogicalDevice& device): device(device) {};

            operator const T &() const { return handle; }
            const T &GetHandle() const { return handle; }
        protected:
            const LogicalDevice& device;

            T handle = 0;
    };
}}