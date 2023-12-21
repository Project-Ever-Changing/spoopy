#pragma once

enum class PrimTopologyType {
    Unknown = 0,
    PointList = 1,
    LineList = 2,
    TriangleList = 3,
    PatchList = 4
};

#ifdef SPOOPY_VULKAN

enum class BackendType {
    Pipeline = 0,
    GPUSemaphore = 1,
};

#endif