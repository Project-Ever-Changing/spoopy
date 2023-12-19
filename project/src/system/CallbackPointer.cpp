#include <system/CallbackPointer.h>
#include <hxcpp.h>

namespace lime { namespace spoopy {
    void CallbackPointer::CallRaw() {
        if(IsCFFIValue()) {
            CallRaw((hx::Object*)this->Get());
        }else {
            // Empty
        }
    }

    void* CallbackPointer::CallRaw(hx::Object* arg1) {

        //hx::Throw(HX_NULL_FUNCTION_POINTER);
        return arg1->__run().GetPtr();
    }
}}