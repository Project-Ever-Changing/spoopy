<xml>
	<set name="PLATFORM" value="android-21" if="android" />

	<include name="${HXCPP}/build-tool/BuildCommon.xml" />

	<set name="HXCPP_CPP14" value="1" />

	<set name="ios" value="1" if="iphone" />
	<set name="tvos" value="1" if="appletv" />
    <set name="mac" value="1" if="macos" />

	<set name="SPOOPY_HASHLINK" value="1" if="hashlink" />
	<set name="SPOOPY_SDL" value="1" />
	<set name="SPOOPY_SPIRV_CROSS" value="1" />
	<set name="SPOOPY_SDL_SUPPORT_RENDERER" value="1" />
	<set name="SPOOPY_SDL_ANGLE" value="1" if="windows SPOOPY_SDL_ANGLE" unless="static_link" />
	<set name="SPOOPY_SDL_ANGLE" value="1" if="windows angle" unless="static_link" />
	<set name="SPOOPY_SDL_ANGLE" value="1" if="winrt" />
	<set name="NATIVE_TOOLKIT_PATH" value="../lime-project/lib" unless="NATIVE_TOOLKIT_PATH" />
	<set name="NATIVE_TOOLKIT_HAVE_SDL" value="1" if="SPOOPY_SDL" />

	<set name="NATIVE_TOOLKIT_SDL_STATIC" value="1" />
	<set name="NATIVE_TOOLKIT_SDL_ANGLE" value="1" if="SPOOPY_SDL_ANGLE" />

	<set name="INCLUDE_SDL" value="1" if="SPOOPY_SDL" />
	<set name="INCLUDE_MAC" value ="1" if="SPOOPY_MAC" />

	<set name="LIME_SOURCE_PATH" value="../lime-project/src" />
	<set name="LIME_INCLUDE_PATH" value="../lime-project/include" />

	<section if="mac">
		<setenv name="MACOSX_DEPLOYMENT_TARGET" value="10.9" if="HXCPP_CPP11 || HXCPP_CPP14" />
		<setenv name="MACOSX_DEPLOYMENT_TARGET" value="10.7" if="OBJC_ARC" unless="MACOSX_DEPLOYMENT_TARGET" />
		<setenv name="MACOSX_DEPLOYMENT_TARGET" value="10.6" unless="MACOSX_DEPLOYMENT_TARGET" />
	</section>

	<!-- Arguements (Meaing that they ARE included, but only through arguments) -->
	<!--<set name="SPOOPY_INCLUDE_EXAMPLE" value="1" />-->
	<!--<set name="SPOOPY_VULKAN" value="1" />-->
	<!--<set name="SPOOPY_METAL" value="1" />-->

	<set name="SPOOPY_VOLK" value="1" if="SPOOPY_VULKAN" />

	<section unless="OUTPUT_DIR">
		<set name="OUTPUT_DIR" value="../ndll-metal" if="SPOOPY_METAL" />
		<set name="OUTPUT_DIR" value="../ndll-vulkan" if="SPOOPY_VULKAN" />
		<set name="OUTPUT_DIR" value="../ndll" unless="SPOOPY_VULKAN || SPOOPY_METAL" />
	</section>

	<files id="lime-extra">

	</files>

	<files id="lime">
		<compilerflag value="-DLIME_DEBUG" if="SPOOPY_DEBUG" />

		<section if="SPOOPY_VOLK">
			<compilerflag value="-DSPOOPY_VOLK" />
			<compilerflag value="-DLIME_VOLK" />
			<compilerflag value="-DVK_NO_PROTOTYPES" />
			<compilerflag value="-Ilib/volk/" />
		</section>

		<section if="SPOOPY_SPIRV_CROSS">
			<compilerflag value="-DSPIRV_ONLY" />
			<compilerflag value="-DSPOOPY_SPIRV_CROSS" />
			<compilerflag value="-Ilib/spirv-cross/include/spirv_cross/" />
			<compilerflag value="-Ilib/spirv-cross/" />
		</section>

		<file name="src/SpoopyExternalInterface.cpp" />

		<compilerflag value="-I${LIME_INCLUDE_PATH}" />
		<compilerflag value="-I${LIME_SOURCE_PATH}/backend/sdl" />

		<compilerflag value="-DSPOOPY_SDL" if="SPOOPY_SDL" />
		<compilerflag value="-DSPOOPY_VULKAN" if="SPOOPY_VULKAN" />
		<compilerflag value="-DLIME_VULKAN" if="SPOOPY_VULKAN" />
		<compilerflag value="-DSPOOPY_INCLUDE_EXAMPLE" if="SPOOPY_INCLUDE_EXAMPLE" />
		<compilerflag value="-DNO_GLSLANG_INCLUDED" />

		<section if="SPOOPY_INCLUDE_EXAMPLE">
			<file name="src/examples/ExampleWindow.cpp" />
		</section>

		<section if="SPOOPY_VULKAN">
			<file name="src/device/Devices.cpp" />
			<file name="src/ui/vulkan/SpoopyWindowVulkan.cpp" />
			<file name="src/device/InstanceDevice.cpp" />
			<file name="src/device/PhysicalDevice.cpp" />
			<file name="src/device/LogicalDevice.cpp" />
			<file name="src/device/SurfaceDevice.cpp" />
			<file name="src/families/QueueFamilyIndices.cpp" />
		</section>

		<section if="SPOOPY_METAL">
			<file name="src/ui/metal/SpoopyWindowMetal.mm" />
			<compilerflag value="-DSPOOPY_METAL" />
		</section>

		<file name="src/shaders/CrossShader.cpp" />
		<file name="src/helpers/SpoopyHelpers.cpp" />
		<file name="src/math/SpoopyPoint.cpp" />
	</files>

	<include name="volk.xml.tpl" if="SPOOPY_VOLK" />
	<include name="spirv-cross.xml.tpl" if="SPOOPY_SPIRV_CROSS" />

	<target id="lime" output="${LIBPREFIX}lime${DEBUGEXTRA}${LIBSUFFIX}" tool="linker" toolid="${STD_MODULE_LINK}">
		<files id="spoopy-toolkit-volk" if="SPOOPY_VOLK" />
		<files id="spoopy-toolkit-spirv" if="SPOOPY_SPIRV_CROSS" />

		<section unless="static_link">
			<section if="mac">
				<vflag name="-framework" value="Metal" />
				<vflag name="-framework" value="MetalKit" />
				<vflag name="-framework" value="QuartzCore" />
			</section>

			<section if="ios">
				<vflag name="-framework" value="Metal" />
				<vflag name="-framework" value="MetalKit" />
				<vflag name="-framework" value="QuartzCore" />
			</section>
		</section>

	</target>

	<include name="../lime-project/Build.xml" />
</xml>