#pragma once

#include <math/Vector2T.h>

namespace lime { namespace spoopy {
    class RenderAreaVulkan {
        public:
            explicit RenderAreaVulkan(const Vector2T_u32 &extent = {}, const Vector2T_32 &offset = {}):
                extent(extent), offset(offset) {};

            bool operator==(const RenderArea &rhs) const {
                return extent == rhs.extent && offset == rhs.offset;
            }

            bool operator!=(const RenderArea &rhs) const {
                return !operator==(rhs);
            }

            const Vector2T_u32 &GetExtent() const { return extent; }
            const Vector2T_32 &GetOffset() const { return offset; }

            void SetExtent(const Vector2T_u32 &extent) { this->extent = extent; }
            void SetOffset(const Vector2T_32 &offset) { this->offset = offset; }

            void UpdateAspectRatio() { aspectRatio = static_cast<float>(extent.x / extent.y) }

            float GetAspectRatio() const { return aspectRatio; }

        private:
            Vector2T_u32 extent;
            Vector2T_32 offset;

            float aspectRatio = 1.0f;
    };
}}