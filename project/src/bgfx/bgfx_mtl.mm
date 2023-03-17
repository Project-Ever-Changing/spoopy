#include "bgfx_mtl.h"

void ShaderMtl::create(const Memory* _mem)
{
    bx::MemoryReader reader(_mem->data, _mem->size);

    bx::ErrorAssert err;

    uint32_t magic;
    bx::read(&reader, magic, &err);

    uint32_t hashIn;
    bx::read(&reader, hashIn, &err);

    uint32_t hashOut;

    if (isShaderVerLess(magic, 6) )
    {
        hashOut = hashIn;
    }
    else
    {
        bx::read(&reader, hashOut, &err);
    }

    uint16_t count;
    bx::read(&reader, count, &err);

    BX_TRACE("%s Shader consts %d"
            , getShaderTypeName(magic)
            , count
    );

    for (uint32_t ii = 0; ii < count; ++ii)
    {
        uint8_t nameSize;
        bx::read(&reader, nameSize, &err);

        char name[256];
        bx::read(&reader, &name, nameSize, &err);
        name[nameSize] = '\0';

        uint8_t type;
        bx::read(&reader, type, &err);

        uint8_t num;
        bx::read(&reader, num, &err);

        uint16_t regIndex;
        bx::read(&reader, regIndex, &err);

        uint16_t regCount;
        bx::read(&reader, regCount, &err);

        if (!isShaderVerLess(magic, 8) )
        {
            uint16_t texInfo = 0;
            bx::read(&reader, texInfo, &err);
        }

        if (!isShaderVerLess(magic, 10) )
        {
            uint16_t texFormat = 0;
            bx::read(&reader, texFormat, &err);
        }
    }

    if (isShaderType(magic, 'C') )
    {
        for (uint32_t ii = 0; ii < 3; ++ii)
        {
            bx::read(&reader, m_numThreads[ii], &err);
        }
    }

    uint32_t shaderSize;
    bx::read(&reader, shaderSize, &err);

    const char* code = (const char*)reader.getDataPtr();
    bx::skip(&reader, shaderSize+1);

    Library lib = s_renderMtl->m_device.newLibraryWithSource(code);

    if (NULL != lib)
    {
        m_function = lib.newFunctionWithName(SHADER_FUNCTION_NAME);
        release(lib);
    }

    BGFX_FATAL(NULL != m_function
            , bgfx::Fatal::InvalidShader
            , "Failed to create %s shader."
            , getShaderTypeName(magic)
    );

    bx::HashMurmur2A murmur;
    murmur.begin();
    murmur.add(hashIn);
    murmur.add(hashOut);
    murmur.add(code, shaderSize);
//		murmur.add(numAttrs);
//		murmur.add(m_attrMask, numAttrs);
    m_hash = murmur.end();
}

void ProgramMtl::create(const ShaderMtl* _vsh, const ShaderMtl* _fsh)
{
    BX_ASSERT(NULL != _vsh->m_function.m_obj, "Vertex shader doesn't exist.");
    m_vsh = _vsh;
    m_fsh = _fsh;

    // get attributes
    bx::memSet(m_attributes, 0xff, sizeof(m_attributes) );
    uint32_t used = 0;
    uint32_t instUsed = 0;
    if (NULL != _vsh->m_function.m_obj)
    {
        for (MTLVertexAttribute* attrib in _vsh->m_function.m_obj.vertexAttributes)
        {
            if (attrib.active)
            {
                const char* name = utf8String(attrib.name);
                uint32_t loc = (uint32_t)attrib.attributeIndex;
                BX_TRACE("attr %s: %d", name, loc);

                for (uint8_t ii = 0; ii < Attrib::Count; ++ii)
                {
                    if (0 == bx::strCmp(s_attribName[ii],name) )
                    {
                        m_attributes[ii] = loc;
                        m_used[used++] = ii;
                        break;
                    }
                }

                for (uint32_t ii = 0; ii < BX_COUNTOF(s_instanceDataName); ++ii)
                {
                    if (0 == bx::strCmp(s_instanceDataName[ii],name) )
                    {
                        m_instanceData[instUsed++] = loc;
                    }
                }

            }
        }
    }

    m_used[used] = Attrib::Count;
    m_instanceData[instUsed] = UINT16_MAX;
}

void ProgramMtl::destroy()
{
    m_vsh = NULL;
    m_fsh = NULL;
    if (NULL != m_computePS)
    {
        BX_DELETE(g_allocator, m_computePS);
        m_computePS = NULL;
    }
}