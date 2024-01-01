#pragma once

/*
 * Very simple at the moment.
 */

namespace lime { namespace spoopy {
    class LogicalDevice;

    template<typename T, typename Device = const LogicalDevice> class GPUResource {
        public:
            GPUResource(Device& device): device(device) {}

            operator const T &() const { return handle; }
            const T &GetHandle() const { return handle; }

            virtual void Destroy() {}
        protected:
            Device &device;

            T handle = 0;
    };
}}