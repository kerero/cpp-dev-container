FROM kerer/cpp-dev-container

# Install additional packages
# RUN export DEBIAN_FRONTEND=noninteractive && apt update \
#    && apt install -y <additional packages> \
#    && apt autoremove -y