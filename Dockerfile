FROM kerer/cpp-dev-container

# Install additional packages
# RUN export DEBIAN_FRONTEND=noninteractive && apt update \
#    && apt install -y <additional packages> \
#    && apt autoremove -y

RUN pip install conan

# install google test
RUN  git clone https://github.com/google/googletest.git /tmp/gtest \
  && cmake -S /tmp/gtest/ -B /tmp/gtest/build && cmake --build /tmp/gtest/build/ --target install