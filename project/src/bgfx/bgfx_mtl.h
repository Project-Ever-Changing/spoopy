#pragma once

#ifdef HX_MACOS
#import <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#endif

#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
#import <MetalKit/MetalKit.h>

#define MTL_CLASS(name)                                   \
	class name                                            \
	{                                                     \
	public:                                               \
		name(id <MTL##name> _obj = nil) : m_obj(_obj) {}  \
		operator id <MTL##name>() const { return m_obj; } \
		id <MTL##name> m_obj;

#define MTL_CLASS_END };

typedef MTLRenderPipelineDescriptor* RenderPipelineDescriptor;
typedef id<MTLRenderPipelineState> RenderPipelineState;

MTL_CLASS(Library)
    id <MTLFunction> newFunctionWithName(const char* _functionName)
    {
        return [m_obj newFunctionWithName:@(_functionName)];
    }
MTL_CLASS_END

struct ShaderMtl
{
    ShaderMtl()
            : m_function(NULL)
    {
    }

    void create(const Memory* _mem);
    void destroy()
    {
        MTL_RELEASE(m_function);

    }

    Function m_function;
    uint32_t m_hash;
    uint16_t m_numThreads[3];
};

struct PipelineStateMtl;

struct ProgramMtl
{
    ProgramMtl()
            : m_vsh(NULL)
            , m_fsh(NULL)
            , m_computePS(NULL)
    {
    }

    void create(const ShaderMtl* _vsh, const ShaderMtl* _fsh);
    void destroy();

    uint8_t  m_used[Attrib::Count+1]; // dense
    uint32_t m_attributes[Attrib::Count]; // sparse
    uint32_t m_instanceData[BGFX_CONFIG_MAX_INSTANCE_DATA_COUNT+1];

    const ShaderMtl* m_vsh;
    const ShaderMtl* m_fsh;

    PipelineStateMtl* m_computePS;
};

struct PipelineStateMtl
{
    PipelineStateMtl()
            : m_vshConstantBuffer(NULL)
            , m_fshConstantBuffer(NULL)
            , m_vshConstantBufferSize(0)
            , m_vshConstantBufferAlignment(0)
            , m_fshConstantBufferSize(0)
            , m_fshConstantBufferAlignment(0)
            , m_numPredefined(0)
            , m_rps(NULL)
            , m_cps(NULL)
    {
        m_numThreads[0] = 1;
        m_numThreads[1] = 1;
        m_numThreads[2] = 1;
        for(uint32_t i=0; i<BGFX_CONFIG_MAX_TEXTURE_SAMPLERS; ++i)
            m_bindingTypes[i] = 0;
    }

    ~PipelineStateMtl()
    {
        if (NULL != m_vshConstantBuffer)
        {
            UniformBuffer::destroy(m_vshConstantBuffer);
            m_vshConstantBuffer = NULL;
        }

        if (NULL != m_fshConstantBuffer)
        {
            UniformBuffer::destroy(m_fshConstantBuffer);
            m_fshConstantBuffer = NULL;
        }

        release(m_rps);
        release(m_cps);
    }

    UniformBuffer* m_vshConstantBuffer;
    UniformBuffer* m_fshConstantBuffer;

    uint32_t m_vshConstantBufferSize;
    uint32_t m_vshConstantBufferAlignment;
    uint32_t m_fshConstantBufferSize;
    uint32_t m_fshConstantBufferAlignment;

    enum
    {
        BindToVertexShader   = 1 << 0,
        BindToFragmentShader = 1 << 1,
    };
    uint8_t m_bindingTypes[BGFX_CONFIG_MAX_TEXTURE_SAMPLERS];

    uint16_t 	m_numThreads[3];

    PredefinedUniform m_predefined[PredefinedUniform::Count*2];
    uint8_t m_numPredefined;

    RenderPipelineState m_rps;
    ComputePipelineState m_cps;
};