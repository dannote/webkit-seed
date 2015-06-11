PROJECT(webkit-seed C)

CMAKE_MINIMUM_REQUIRED(VERSION 3.0)
CMAKE_POLICY(VERSION 3.0)

# Includes
LIST(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
INCLUDE(FindVala)
INCLUDE(ValaPrecompile)

# Find packages
FIND_PACKAGE(PkgConfig REQUIRED)
FIND_PACKAGE(Vala REQUIRED)
PKG_CHECK_MODULES(DEPS REQUIRED glib-2.0>=2.38 gtk+-3.0 webkit2gtk-4.0 seed)

# Find resource compiler
FIND_PROGRAM(GLIB_COMPILE_RESOURCES NAMES glib-compile-resources)
IF(NOT GLIB_COMPILE_RESOURCES)
MESSAGE(FATAL "Could not find glib-compile-resources")
ENDIF()

# Definitions
ADD_DEFINITIONS(${DEPS_CFLAGS} ${DEPS_CFLAGS_OTHER})
LINK_LIBRARIES(${DEPS_LIBRARIES})
LINK_DIRECTORIES(${DEPS_LIBRARY_DIRS})

# Precompile Vala
VALA_PRECOMPILE(VALA_C ${PROJECT_NAME}
    src/webkit-seed.vala
PACKAGES
    posix
    libnotify
    gtk+-3.0
    glib-2.0
    webkit2gtk-4.0
OPTIONS
    --target-glib=2.38
)

# Create executable
ADD_EXECUTABLE(${PROJECT_NAME}
    ${VALA_C}
)

# Create extension library
ADD_LIBRARY(${PROJECT_NAME}-extension
SHARED
    src/webkit-seed-extension.c
)