#!/bin/bash

HERE=$PWD

HDF_DIR="HDF5"
HDF_VERSION="1.14.6"

NC_C_DIR="NetCDF-C"
NC_C_VERSION="4.9.3"

NC_F_DIR="NetCDF-F"
NC_F_VERSION="4.6.2"

INSTALL="${HOME}/FortranLib"


export FC=ifort
export F77=${FC}
export F90=ifort
export FCFLAGS=" -O3 -assume byterecl -convert little_endian"
export CC=icc
export CFLAGS=" -O3"


function INSTALL_HDF5(){
    cd ${HERE}

    echo "mkdir ${HDF_DIR}"
    mkdir ${HDF_DIR}
    TAR="hdf5-${HDF_VERSION}.tar.gz"

    cd ${HDF_DIR}

    if [ ! -e ${TAR} ]
    then
        echo "wget https://github.com/HDFGroup/hdf5/releases/download/hdf5_${HDF_VERSION}/${TAR}"
        wget "https://github.com/HDFGroup/hdf5/releases/download/hdf5_${HDF_VERSION}/${TAR}"
    else
        echo "${TAR} Already Exist"
    fi

    echo "tar -zxf ${TAR}"
    tar -zxf ${TAR}

    echo "cd hdf5-${HDF_VERSION}"
    cd "hdf5-${HDF_VERSION}"

    echo "./configure --prefix=${INSTALL} --enable-fortran > ${HERE}/log/log_configure_hdf5.txt 2>&1"
    ./configure --prefix=${INSTALL} --enable-fortran > ${HERE}/log/log_configure_hdf5.txt 2>&1

    echo "make > ${HERE}/log/log_make_hdf5.txt 2>&1"
    make > ${HERE}/log/log_make_hdf5.txt 2>&1

    echo "make check > ${HERE}/log/log_check_hdf5.txt 2>&1"
    make check > ${HERE}/log/log_check_hdf5.txt 2>&1

    echo "make install > ${HERE}/log/log_install_hdf5.txt 2>&1"
    make install > ${HERE}/log/log_install_hdf5.txt 2>&1
}


function INSTALL_NC_C(){
    cd ${HERE}

    export CPPFLAGS="-I${INSTALL}/include"
    export LDFLAGS="-L${INSTALL}/lib"

    TAR="v${NC_C_VERSION}.tar.gz"

    echo "mkdir ${NC_C_DIR}"
    mkdir ${NC_C_DIR}

    echo "cd ${NC_C_DIR}"
    cd ${NC_C_DIR}

    if [ ! -e ${TAR} ]
    then
        echo "wget https://github.com/Unidata/netcdf-c/archive/refs/tags/${TAR}"
        wget https://github.com/Unidata/netcdf-c/archive/refs/tags/${TAR}
    else
        echo "${TAR} Already Exist"
    fi

    echo "tar -zxf ${TAR}"
    tar -zxf ${TAR}

    echo "cd netcdf-c-${NC_C_VERSION}"
    cd "netcdf-c-${NC_C_VERSION}"

    echo "./configure --prefix=${INSTALL} --enable-netcdf-4 > ${HERE}/log/log_configure_ncc.txt 2>&1"
    ./configure --prefix=${INSTALL} --enable-netcdf-4 > ${HERE}/log/log_configure_ncc.txt 2>&1

    echo "make > ${HERE}/log/log_make_ncc.txt 2>&1"
    make > ${HERE}/log/log_make_ncc.txt 2>&1

    echo "make check > ${HERE}/log/log_check_ncc.txt 2>&1"
    make check > ${HERE}/log/log_check_ncc.txt 2>&1

    echo "make install > ${HERE}/log/log_install_ncc.txt 2>&1"
    make install > ${HERE}/log/log_install_ncc.txt 2>&1
}


function INSTALL_NC_F(){
    cd ${HERE}

    export CPPFLAGS="-I${INSTALL}/include"
    export LDFLAGS="-L${INSTALL}/lib"
    export LD_LIBRARY_PATH=${INSTALL}/lib:${LD_LIBRARY_PATH}

    TAR="netcdf-fortran-${NC_F_VERSION}.tar.gz"

    echo "mkdir ${NC_F_DIR}"
    mkdir ${NC_F_DIR}

    echo "cd ${NC_F_DIR}"
    cd ${NC_F_DIR}

    if [ ! -e ${TAR} ]
    then
        echo "wget https://downloads.unidata.ucar.edu/netcdf-fortran/${NC_F_VERSION}/${TAR}"
        wget https://downloads.unidata.ucar.edu/netcdf-fortran/${NC_F_VERSION}/${TAR}
    else
        echo "${TAR} Alreaady Exist"
    fi

    echo "tar -zxf ${TAR}"
    tar -zxf ${TAR}

    echo "cd netcdf-fortran-${NC_F_VERSION}"
    cd "netcdf-fortran-${NC_F_VERSION}"

    echo "./configure --prefix=${INSTALL} > ${HERE}/log/log_configure_ncf.txt 2>&1"
    ./configure --prefix=${INSTALL} > ${HERE}/log/log_configure_ncf.txt 2>&1

    echo "make > ${HERE}/log/log_make_ncf.txt 2>&1"
    make > ${HERE}/log/log_make_ncf.txt 2>&1

    echo "make check > ${HERE}/log/log_check_ncf.txt 2>&1"
    make check > ${HERE}/log/log_check_ncf.txt 2>&1

    echo "make install > ${HERE}/log/log_install_ncf.txt 2>&1"
    make install > ${HERE}/log/log_install_ncf.txt 2>&1
}



function clean(){
    rm -rfv ./log/
    rm -rfv ./include/
    rm -rfv ./lib/
    rm -rfv ./bin/
    rm -rfv ./share/
    rm -rfv ./${HDF_DIR}
    rm -rfv ./${NC_C_DIR}
    rm -rfv ./${NC_F_DIR}
    rm -rfv ./hdf5/
}


case "$1" in
    clean|--clean)
        echo clean
        clean
        ;;
    all|--all)
        clean
        echo "Cleaned"
        echo "mkdir log/"
        mkdir log/
        echo all
        INSTALL_HDF5
        echo
        INSTALL_NC_C
        echo
        INSTALL_NC_F
        ;;
    hdf5|--hdf5)
        echo "mkdir log/"
        mkdir log/
        echo HDF5
        INSTALL_HDF5
        ;;
    ncc|--ncc)
        echo "mkdir log/"
        mkdir log/
        echo NETCDF-C
        INSTALL_NC_C
        ;;
    ncf|--ncf)
        echo "mkdir log/"
        mkdir log/
        echo NETCDF-F
        INSTALL_NC_F
        ;;
    *)
        echo "Invalid option : $1"
        echo "--clean, --all, --hdf5, --ncc, or --ncf"
esac

