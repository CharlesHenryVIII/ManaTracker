workspace "ManaTracker"
    configurations { "Debug", "Profile", "Release" }
    platforms { "x64" }
    staticruntime "On"
    runtime "Debug"

project "ManaTracker"
    --symbolspath '$(OutDir)$(TargetName).pdb'
    kind "WindowedApp" --WindowedApp --ConsoleApp
    language "C++"
    cppdialect "C++latest"
    targetdir "build/%{cfg.platform}/%{cfg.buildcfg}"
    objdir "build/obj/%{cfg.platform}/%{cfg.buildcfg}"
    editandcontinue "Off"
    entrypoint "mainCRTStartup"
    --characterset "ASCII"
    links {
        --"SDL2",
        --"SDL2main",
        --"d3d11.lib",
        --"dxgi.lib",
        --"dxguid.lib",
        --"d3d12.lib",
        "OpenGL32",
    }

    libdirs {
        --"contrib/SDL2/lib/%{cfg.platform}/",
        "contrib/imgui",
        --"contrib/tracy-master",
        --"contrib/**",
    }
    includedirs {
        "contrib",
        "contrib/imgui",
        --"contrib/SDL2/include",
        "contrib/glfw/include",
        --"contrib/tracy-master/public/tracy",
        --"contrib/DirectX-Headers/**"
        "Contrib/Glew/include",
        "Contrib/Glew/include/GL",
    }
    flags {
        "MultiProcessorCompile",
        "FatalWarnings",
        "NoPCH",
    }
    defines {
        "_CRT_SECURE_NO_WARNINGS",
        "GLEW_STATIC",
        "_GLFW_WIN32",
        --"CAMERA", --DO WE NEED THIS?
    }
    files {
        "Source/**",
        "contrib/Glew/src/glew.c",
        --"contrib/tracy-master/public/TracyClient.cpp",
        "contrib/imgui/*.cpp",
        "contrib/imgui/*.h",
        --"contrib/ImGui/backends/imgui_impl_opengl3.*",
        "contrib/imgui/backends/*glfw.*",
        "contrib/imgui/backends/*opengl3.*",
        "contrib/glfw/src/*.h",
        "contrib/glfw/src/*.c",
        "contrib/glfw/src/*.m",
        --"contrib/ImGui/backends/imgui_impl_dx12.*",
        --"contrib/ImGui/backends/imgui_impl_opengl3.h",
        --"contrib/ImGui/backends/imgui_impl_opengl3.cpp",
        --"contrib/ImGui/backends/imgui_impl_sdl.h",
        --"contrib/ImGui/backends/imgui_impl_sdl.cpp",
    }


    --postbuildcommands
    --{
        --"{COPY} contrib/SDL2/lib/%{cfg.platform}/SDL2.dll %{cfg.targetdir}",
        --"{COPY} contrib/d3dcompiler_47.dll %{cfg.targetdir}",
    --}


    filter "configurations:Debug"
        defines { "_DEBUG" , "TRACY_ENABLE", "NOMINMAX"}
        editandcontinue "off"
        symbols  "Full"
        optimize "Off"

    filter "configurations:Profile"
        defines { "NDEBUG" , "TRACY_ENABLE", "NOMINMAX"}
        editandcontinue "off"
        runtime "Release"
        symbols  "Full"
        --floatingpoint "fast"
        optimize "Speed"

    filter "configurations:Release"
        defines { "NDEBUG", "NOMINMAX" }
        editandcontinue "off"
        runtime "Release"
        symbols  "Full"
        --floatingpoint "fast"
        optimize "Speed"

    filter("files:**.hlsl")
        flags("ExcludeFromBuild")
