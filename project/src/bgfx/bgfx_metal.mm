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