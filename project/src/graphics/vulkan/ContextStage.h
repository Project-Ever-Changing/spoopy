#pragma once

#include <math/Rectangle.h>
#include <graphics/Viewport.h>

#include "RenderAreaVulkan.h"

namespace lime { namespace spoopy {
    class ContextStage {
        public:
            ContextStage(const Viewport &viewport): viewport(viewport) {}
            ~ContextStage();

            virtual void Update() = 0;

        private:
            Viewport viewport;
            RenderAreaVulkan renderArea;

            bool isDirty = false;
    };
}}