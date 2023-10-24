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
    RenderPass,
    Buffer,
    BufferView,
    Image,
    ImageView,
    Pipeline,
    PipelineLayout,
    Framebuffer,
    DescriptorSetLayout,
    Sampler,
    Semaphore,
    ShaderModule,
    Event,
    ResourceAllocation,
    DeviceMemoryAllocation,
    BufferSuballocation,
    AccelerationStructure,
    BindlessHandle,
};

#endif