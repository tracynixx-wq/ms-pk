cmake_minimum_required(VERSION 3.24)

project(MessageDesktop VERSION 0.2.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(MessageDesktop
    WIN32
    src/main.cpp
)

qt_add_qml_module(MessageDesktop
    URI Message.Desktop
    VERSION 1.0
    QML_FILES
        qml/Main.qml
)

target_link_libraries(MessageDesktop
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
)

if(MSVC)
    target_compile_options(MessageDesktop PRIVATE /W4 /permissive-)
else()
    target_compile_options(MessageDesktop PRIVATE -Wall -Wextra -Wpedantic)
endif()

install(TARGETS MessageDesktop
    BUNDLE DESTINATION .
    RUNTIME DESTINATION bin
)
