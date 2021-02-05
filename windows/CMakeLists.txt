cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "flutter_jscore")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "${PROJECT_NAME}_plugin")

add_library(${PLUGIN_NAME} SHARED
  "${PLUGIN_NAME}.cpp"
)
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_compile_definitions(${PLUGIN_NAME} PRIVATE _SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)

# List of absolute paths to libraries that should be bundled with the plugin
set(flutter_jscore_bundled_libraries
  "${CMAKE_CURRENT_SOURCE_DIR}/dll/ASL.dll"
  "${CMAKE_CURRENT_SOURCE_DIR}/dll/CoreFoundation.dll"
  "${CMAKE_CURRENT_SOURCE_DIR}/dll/icudt62.dll"
  "${CMAKE_CURRENT_SOURCE_DIR}/dll/JavaScriptCore.dll"
  "${CMAKE_CURRENT_SOURCE_DIR}/dll/libdispatch.dll"
  "${CMAKE_CURRENT_SOURCE_DIR}/dll/libicuin.dll"
  "${CMAKE_CURRENT_SOURCE_DIR}/dll/libicuuc.dll"
  "${CMAKE_CURRENT_SOURCE_DIR}/dll/objc.dll"
  "${CMAKE_CURRENT_SOURCE_DIR}/dll/WTF.dll"
  PARENT_SCOPE
)
