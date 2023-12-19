#pragma once

#include <system/ValuePointer.h>
#include <core/Log.h>
#include <hxcpp.h>

namespace lime { namespace spoopy {
    class CallbackPointer: public ValuePointer {
        public:
            CallbackPointer(value handle): ValuePointer(handle) {};
            CallbackPointer(vobj* handle): ValuePointer(handle) {};
            CallbackPointer(vdynamic* handle): ValuePointer(handle) {};
            CallbackPointer(vclosure* handle): ValuePointer(handle) {};
            ~CallbackPointer();

            void CallRaw();

        private:
            void* CallRaw(hx::Object* arg1);
    };

    };
}}