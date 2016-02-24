
include(TargetArch)

if("${ARCHITECTURE}" STREQUAL "X86_64")
  set(ARCH x64)
elseif(ARCHITECTURE STREQUAL "X86")
  set(ARCH ia32)
else()
  message(FATAL_ERROR "Unsupported architecture(${ARCHITECTURE}) cannot download winpty")
endif()

GetBinaryDep(TARGET winpty
  INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${DEPS_INSTALL_DIR}/bin
    COMMAND ${CMAKE_COMMAND} -DFROM_GLOB=${DEPS_BUILD_DIR}/src/winpty/${ARCH}/bin/* -DTO=${DEPS_INSTALL_DIR}/bin/ -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/CopyFilesGlob.cmake
    COMMAND ${CMAKE_COMMAND} -DFROM_GLOB=${DEPS_BUILD_DIR}/src/winpty/include/* -DTO=${DEPS_INSTALL_DIR}/include/ -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/CopyFilesGlob.cmake
    COMMAND ${CMAKE_COMMAND} -DFROM_GLOB=${DEPS_BUILD_DIR}/src/winpty/${ARCH}/lib/* -DTO=${DEPS_INSTALL_DIR}/lib/ -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/CopyFilesGlob.cmake)
