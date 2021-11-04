FROM ubuntu:18.04

MAINTAINER Many CADS

SHELL ["/bin/bash", "-c"] 

# Instalacion de Root
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install wget git python python3 cmake python3-dev python3-pip -y --no-install-recommends \
    && useradd -m neutrino \
    && cd /home/neutrino \
    && mkdir software

WORKDIR /home/neutrino/software

RUN wget https://root.cern.ch/download/root_v5.34.38.source.tar.gz \
    && tar -xzvf root_v5.34.38.source.tar.gz \
    && mv root root_v5.34.38 \
    && rm -f root_v5.34.38.source.tar.gz     

WORKDIR /home/neutrino/software/root_v5.34.38

RUN apt-get install -y\
    git dpkg-dev cmake g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev \
    libtiff5 \
    libgif7 \
    libtiff-dev \
    libgif-dev \
    gfortran libssl-dev libpcre3-dev xlibmesa-glu-dev libglew1.5-dev libftgl-dev \
    libmysqlclient-dev libfftw3-dev libcfitsio-dev graphviz-dev \
    libavahi-compat-libdnssd-dev libldap2-dev python-dev libxml2-dev libkrb5-dev \ 
    libgsl0-dev libqt4-dev \
    && rm -rf var/lib/apt/lists/* \
    && mkdir install

RUN cd install \
    && cmake -DPYTHON_EXECUTABLE=$(which python3) .. \
    && cmake --build .

#Instalacion Geant4
WORKDIR /home/neutrino/software

RUN wget http://cern.ch/geant4-data/releases/geant4.10.01.p03.tar.gz \
    && tar -xzvf geant4.10.01.p03.tar.gz \
    && apt-get install -y\
       expat \
       libclhep-dev \
       libxerces-c-dev \
       xorg-dev \
       libcoin80-dev \
       libmotif-dev \
    && cd geant4.10.01.p03 \
    && mkdir build \
    &&rm -f geant4.10.01.p03.tar.gz

WORKDIR /home/neutrino/software/geant4.10.01.p03/build 

RUN cmake -DGEANT4_USE_GDML=ON -DGEANT4_BUILD_MULTITHREADED=ON \
    -DGEANT4_USE_OPENGL_X11=ON -DGEANT4_USE_XM=ON -DGEANT4_USE_QT=ON \
    -DGEANT4_BUILD_CXXSTD=c++11 -DCMAKE_CXX_FLAGS=-std=c++11 \
    -DGEANT4_INSTALL_DATADIR=../data \
    -DGEANT4_INSTALL_DATA=ON \
    -DCMAKE_INSTALL_PREFIX=../install .. \ 
    && make -j4 && make install

# Compilacion para correr un ejemplo
RUN cd /home/neutrino/software \
    && cp -r geant4.10.01.p03/examples/basic/B1 geant4-B1-source \
    && mkdir geant4-B1-build 
    
WORKDIR /home/neutrino/software/geant4-B1-build
   
RUN cmake -DGeant4_DIR=/home/neutrino/software/geant4.10.01.p03/install/lib/Geant4-10.1.3 /home/neutrino/software/geant4-B1-source \
    && cmake -DCMAKE_PREFIX_PATH=/home/neutrino/software/geant4.10.01.p03/install /home/neutrino/software/geant4-B1-source \
    && make -j4 

ENV SOFTWARE=/home/neutrino/software

RUN source $SOFTWARE/geant4.10.01.p03/install/bin/geant4.sh \
    && source $SOFTWARE/geant4.10.01.p03/install/share/Geant4-10.1.3/geant4make/geant4make.sh \
    && source $SOFTWARE/root_v5.34.38/install/bin/thisroot.sh 

ENV GEANT4_BASE_DIR=$SOFTWARE/geant4.10.01.p03/install
ENV G4WORKDIR=$PWD 

# WCSim
WORKDIR /home/neutrino/software

RUN apt-get install -y\
    libcanberra-gtk-module libcanberra-gtk3-module \
    libpth-dev \
    && mkdir WCSim

# Copiamos la carpeta WCSim de nuestro HOST al contenedor
COPY WCSim /home/neutrino/software/WCSim
COPY run.sh /home/neutrino/software

RUN mkdir $SOFTWARE/WCSim_build && chmod +x /home/neutrino/software/run.sh

WORKDIR $SOFTWARE/WCSim_build

RUN source $SOFTWARE/root_v5.34.38/install/bin/thisroot.sh \
    && cp $SOFTWARE/WCSim/macros/mPMT_nuPrism1.mac $SOFTWARE/WCSim/macros/mPMT.mac \
    && cmake -DGeant4_DIR=/home/neutrino/software/geant4.10.01.p03/install/lib/Geant4-10.1.3 ../WCSim \
    && make -j4 \
    && cp ../WCSim/*.mac . \
    && cp -rf ../WCSim/mPMT-configfiles . \
    && cp -rf ../WCSim/macros .