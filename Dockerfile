FROM kerer/cpp-dev-container

# Install additional packages
# RUN export DEBIAN_FRONTEND=noninteractive && apt update \
#    && apt install -y <additional packages> \
#    && apt autoremove -y

RUN pip install conan

# install google test
RUN  git clone https://github.com/google/googletest.git --depth 1 /tmp/3rd_party/gtest \
  && cmake -S /tmp/3rd_party/gtest/ -B /tmp/3rd_party/gtest/build \
  && cmake --build /tmp/3rd_party/gtest/build/ --target install 

#install daw json link
RUN  git clone https://github.com/beached/daw_json_link --depth 1 /tmp/3rd_party/djl \
  && cmake --config Release -S /tmp/3rd_party/djl/ -B /tmp/3rd_party/djl/build  \
  && cmake --build /tmp/3rd_party/djl/build/ --target install --config Release
# Fix installation path for some of the cmake files 
RUN mv /usr/local/share/json_link/cmake\$/* /usr/local/share/json_link/cmake

#install google benchmark 
RUN  git clone https://github.com/google/benchmark.git --depth 1 /tmp/3rd_party/gbench \
  && cmake -S /tmp/3rd_party/gbench/ -B /tmp/3rd_party/gbench/build -DBENCHMARK_ENABLE_GTEST_TESTS=OFF -DCMAKE_BUILD_TYPE=Release \
  && cmake --build /tmp/3rd_party/gbench/build/ --target install --config Release

# Install  nlohmann/json 
RUN  git clone --branch master https://github.com/nlohmann/json.git --depth 1 /tmp/3rd_party/json \
  && cmake -S /tmp/3rd_party/json/ -B /tmp/3rd_party/json/build -DJSON_BuildTests=Off\
  && cmake --build /tmp/3rd_party/json/build/ --target install --config Release

# Install magic_enum
RUN  git clone https://github.com/Neargye/magic_enum.git --depth 1 /tmp/3rd_party/me \
  && cmake -S /tmp/3rd_party/me/ -B /tmp/3rd_party/me/build -DMAGIC_ENUM_OPT_BUILD_TESTS=Off  \
  && cmake --build /tmp/3rd_party/me/build/ --target install --config Release

# Cleanup tmp
RUN rm -rf /tmp/3rd_party