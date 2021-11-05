#!/bin/bash 
export SOFTWARE=/home/neutrino/software
source $SOFTWARE/root_v5.34.38/install/bin/thisroot.sh
export GEANT4_BASE_DIR=$SOFTWARE/geant4.10.01.p03/install
export G4WORKDIR=$PWD

#Para correr WCSim
cd $SOFTWARE/WCSim_build

source $SOFTWARE/geant4.10.01.p03/install/bin/geant4.sh
source $SOFTWARE/geant4.10.01.p03/install/share/Geant4-10.1.3/geant4make/geant4make.sh
export WCSIMDIR=$PWD
export G4WORKDIR=$PWD
