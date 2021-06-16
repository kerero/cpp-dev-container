FROM kerer/cpp-dev-container

# Install additional packages
# RUN export DEBIAN_FRONTEND=noninteractive && apt update \
#    && apt install -y <additional packages> \
#    && apt autoremove -y

RUN pip install conan

# install google test
RUN  git clone https://github.com/google/googletest.git /tmp/gtest \
  && cmake -S /tmp/gtest/ -B /tmp/gtest/build && cmake --build /tmp/gtest/build/ --target install

#install daw json link
RUN  git clone https://github.com/beached/daw_json_link /tmp/djl \
  && cmake -S /tmp/djl/ -B /tmp/djl/build && cmake --build /tmp/djl/build/ --target install
# Fix installation path for some of the cmake files 
RUN mv /usr/local/share/json_link/cmake\$/* /usr/local/share/json_link/cmake