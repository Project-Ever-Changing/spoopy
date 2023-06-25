#include "ContextStage.h"

namespace lime { namespace spoopy {
    ContextStage::~ContextStage() {

    }

    void ContextStage::Update() {
        auto prevRenderArea = renderArea;

        renderArea.SetOffset(viewport.offset);
        renderArea.SetExtent(viewport.extent);

        renderArea.UpdateAspectRatio();
        renderArea.SetExtent(renderArea.GetExtent() + renderArea.GetOffset());

        isDirty = prevRenderArea != renderArea;
    }
}}