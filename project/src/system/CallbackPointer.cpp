#include <system/CallbackPointer.h>

namespace lime { namespace spoopy {
    CallbackPointer::~CallbackPointer() {
        ~ValuePointer();
    }

    void CallbackPointer::CallRaw() {
        if(valuePointer->hlValue != NULL) {
            Call((hx::Object*)valuePointer->Get());
        }else {
            // Empty
        }
    }

    void* CallbackPointer::CallRaw(hx::Object* arg1) {
        SPOOPY_LOG_INFO("Run Thingy");

        //hx::Throw(HX_NULL_FUNCTION_POINTER);
        return arg1->__run().GetPtr();
    }
}}