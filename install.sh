#!/bash/bin


export FC=ifort
export F77=${FC}
export F90=ifort
export FFLAGS=" -O3 -assume byterecl -convert little_endian"
export CC=icc

HDF_DIR="HDF5"
HDF_VERSION="1.14.6"

function INSTALL_HDF5(){
    echo "mkdir ${HDF_DIR}"
    mkdir ${HDF_DIR}

    cd ${HDF_DIR}

    echo "wget https://github.com/HDFGroup/hdf5/releases/download/hdf5_${HDF_VERSION}/hdf5-${HDF_VERSION}.tar.gz"
    wget "https://github.com/HDFGroup/hdf5/releases/download/hdf5_${HDF_VERSION}/hdf5-${HDF_VERSION}.tar.gz"

    echo "tar -zxvf hdf5-${HDF_VERSION}.tar.gz"
    tar -zxvf "hdf5-${HDF_VERSION}.tar.gz"

    echo "cd hdf5-${HDF_VERSION}"
    cd "hdf5-${HDF_VERSION}"

    echo "./configure --prefix=${HOME}/FortranLib/build/netcdf/HDF5 --enable-fortran > ../log_configure.txt 2>&1"
    ./configure --prefix=${HOME}/FortranLib/build/netcdf/HDF5 --enable-fortran > ../log_configure.txt 2>&1

    echo "make > ../log_make.txt 2>&1"
    make > ../log_make.txt 2>&1

    echo "make check > ../log_check.txt 2>&1"
    make check > ../log_check.txt 2>&1

    echo "make install > ../log_install.txt 2>&1"
    make install > ../log_install.txt 2>&1
}


INSTALL_HDF5

