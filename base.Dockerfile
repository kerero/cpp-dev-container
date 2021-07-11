ARG OS=ubuntu
ARG TAG=hirsute

FROM ${OS}:${TAG} as base

# Install required packages
ARG CLANG_VER=12
ARG GCC_VER=11
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt update && apt install -y git htop sudo curl wget net-tools jq locales\
    build-essential cmake ninja-build valgrind gdb rr doxygen \
    clang-${CLANG_VER} clang-tidy-${CLANG_VER} clang-format-${CLANG_VER} clang-tools-${CLANG_VER} \
    gcc-${GCC_VER} g++-${GCC_VER} \
    python3 python3-pip \
    libbabeltrace-ctf-dev systemtap-sdt-dev libslang2-dev libelf-dev libunwind-dev libdw-dev libiberty-dev

# Set selected clang version as default
RUN ln -s /usr/bin/clang-${CLANG_VER} /usr/bin/clang \
    && ln -s /usr/bin/clang-tidy-${CLANG_VER} /usr/bin/clang-tidy \
    && ln -s /usr/bin/clang-format-${CLANG_VER} /usr/bin/clang-format \
    && ln -s /usr/bin/scan-build-${CLANG_VER} /usr/bin/scan-build \
    && ln -s /usr/bin/run-clang-tidy-${CLANG_VER} /usr/bin/run-clang-tidy \
    && ln -s /usr/bin/clang-apply-replacements-${CLANG_VER} /usr/bin/clang-apply-replacements

# Setup user and shell
ARG INSTALL_ZSH="false"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY scripts/setup.sh /tmp
RUN /tmp/setup.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "true" \
    && rm -f /tmp/setup.sh
#################################################################################################
FROM base as perf-builder

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt install -y --no-install-recommends gcc-8 g++-8 flex bison
RUN export CC=gcc-8 && export CXX=g++-8 \
    && git clone --branch linux-msft-wsl-5.10.y --depth=1 https://github.com/microsoft/WSL2-Linux-Kernel.git /tmp/wsl2-kernel \
    && cd /tmp/wsl2-kernel/tools/perf && make

#################################################################################################
FROM base as codechecker-builder

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt install -y python3-dev python3-venv nodejs npm
RUN git clone https://github.com/Ericsson/CodeChecker.git --depth 1 /codechecker
SHELL ["/bin/bash", "-c"]
ENV BUILD_LOGGER_64_BIT_ONLY=YES
RUN cd /codechecker \
    && npm install -g node-gyp \
    && make venv \
    && source $PWD/venv/bin/activate \
    && make package

#################################################################################################
FROM base
# Setup perf
COPY --from=perf-builder /tmp/wsl2-kernel/tools/perf/perf /usr/local/bin

# Setup CodeChecker
COPY --from=codechecker-builder /codechecker/build/CodeChecker /opt/codechecker
COPY --from=codechecker-builder /codechecker/analyzer/requirements.txt /opt/codechecker
RUN pip3 install -r /opt/codechecker/requirements.txt \
    && ln -s /opt/codechecker/bin/CodeChecker /usr/bin/CodeChecker

# Setup flame-graph
RUN git clone --depth=1 https://github.com/brendangregg/FlameGraph /opt/flame-graph

# Setup cmake utils
COPY scripts/.CodeCheckerIgnore scripts/utils.cmake /opt/cmake-utils/

#Setup profiling script
COPY scripts/cpu-profile.sh /opt
RUN ln -s /opt/cpu-profile.sh /usr/bin/cpu-profile

# Cleanup
RUN export DEBIAN_FRONTEND=noninteractive && apt autoremove -y