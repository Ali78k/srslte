# BSD 2-Clause License

# Copyright (c) 2020, Supreeth Herle
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

FROM ubuntu:bionic

# Install updates and dependencies
RUN apt-get update && \
    apt-get -y install cmake libfftw3-dev libmbedtls-dev libboost-program-options-dev libconfig++-dev libsctp-dev git \
    libzmq3-dev libboost-system-dev libboost-test-dev libboost-thread-dev libqwt-qt5-dev qtbase5-dev \
    software-properties-common g++ make pkg-config libpython-dev python-numpy swig libi2c-dev \
    libboost-program-options-dev libconfig++-dev

# Install dependencies to build SoapySDR and Lime Suite
RUN add-apt-repository -y ppa:myriadrf/drivers && \
    apt update && \
    apt -y install libi2c-dev libusb-1.0-0-dev git g++ cmake libsqlite3-dev libwxgtk3.0-dev freeglut3-dev \
    python3-distutils gnuplot libfltk1.3-dev liboctave-dev

# Install SoapySDR from Source
RUN git clone https://github.com/pothosware/SoapySDR.git && \
    cd SoapySDR && \
    git checkout tags/soapy-sdr-0.7.2 -b soapy-sdr-0.7.2 && \
    mkdir build && cd build && cmake .. && \
    make && make install && ldconfig

# Install LimeSuite
RUN git clone https://github.com/myriadrf/LimeSuite.git && \
    cd LimeSuite && \
    git checkout tags/v20.07.1 -b v20.07.1 && \
    mkdir builddir && cd builddir && cmake .. && \
    make && make install && ldconfig && \
    cd ../udev-rules && sh ./install.sh

# Get srsGUI, compile and install
RUN git clone https://github.com/srsLTE/srsGUI && \
    cd srsGUI/ && \
    mkdir build && cd build && \
    cmake ../ && make && make install && ldconfig

# Get srsLTE, compile and install
RUN git clone https://github.com/srsLTE/srsLTE.git && \
    cd srsLTE && \
    git checkout tags/release_19_12 && \
    mkdir build && cd build && \
    cmake ../ && make && make install && \
    ldconfig && srslte_install_configs.sh service

CMD /mnt/srslte/enb_init.sh && \
    /usr/local/bin/srsenb