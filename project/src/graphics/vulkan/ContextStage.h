#pragma once

namespace lime { namespace spoopy {
    class ContextStage {
        public:
            ContextStage();
            ~ContextStage();

            virtual void Update() = 0;

        private:
            RenderAreaVulkan renderArea;
    };
}}
