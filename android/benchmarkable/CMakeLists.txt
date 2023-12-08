cmake_minimum_required(VERSION 3.4.1)

# Ordner der C++-Implementation festlegen
include_directories(
        ../../measuring-lib/
)

# C++-Implementation mit Wrapper verknüpfen und als measuring-lib bereitstellen
add_library(
        measuring-lib
        SHARED
        src/main/cpp/measuringWrapper.cpp
        ../../measuring-lib/measuring.hpp
        ../../measuring-lib/measuring.cpp
)

# native logging-Bibliothek finden
find_library(
        log-lib
        log
)

# measuring mit logging verbinden
target_link_libraries(
        measuring-lib
        ${log-lib}
)