# C++ Development Container
[![Docker Publish](https://github.com/OriKerer/cpp-dev-container/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/OriKerer/cpp-dev-container/actions/workflows/docker-publish.yml)

A modern development environment for cmake based C++ projects\
Pre-configured with the latest tools and vs code extensions

## Integrating within a project
From the root of the project
```
git submodule add https://github.com/OriKerer/cpp-dev-container.git .devcontainer
```
And simply launch the container from the [remote-container extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) with `Remote-Containers: Reopen in container`

## Using lint & static analysis
include the cmake script in your `CMakeLists.txt`
```cmake
include(/opt/cmake-utils/utils.cmake)
```
and use one of the targets:
- `tidy` / `tidy-fix`
- `format` / `format-fix`
- `static-analysis`

## Using perf and flame-graph script
```bash
cpu-profile <command> <output-path>
```
or use perf and flame graph (/opt/flame-graph) manually 

## Package List
### build tools
* gcc-11
* clang-14
* cmake
* ninja
### Debug & Profiling
* valgrind
* gdb
* rr
* perf
* flame-graph
### Code Quality tools
* clang-[format/tidy/static-analysis]
* CodeChecker
### Documentation
- Doxygen
