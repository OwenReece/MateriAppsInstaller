#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/gromacs-$GROMACS_VERSION-$GROMACS_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/gromacs/gromacs-$GROMACS_VERSION-$GROMACS_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
mkdir -p $BUILD_DIR/gromacs-$GROMACS_VERSION-build
cd $BUILD_DIR/gromacs-$GROMACS_VERSION-build
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
if [ -n "$FFTW_ROOT" ]; then
  check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpicxx -DGMX_MPI=on -DFFTWF_INCLUDE_DIR="$FFTW_ROOT/include" -DFFTWF_LIBRARY="$FFTW_ROOT/lib/libfftw3f.so" $BUILD_DIR/gromacs-$GROMACS_VERSION | tee -a $LOG
else
  check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpicxx -DGMX_MPI=on $BUILD_DIR/gromacs-$GROMACS_VERSION | tee -a $LOG
fi
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_APPS make install | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/gromacsvars.sh
. $PREFIX_TOOL/env.sh
export GROMACS_ROOT=$PREFIX
export GROMACS_VERSION=$GROMACS_VERSION
export GROMACS_PATCH_VERSION=$GROMACS_PATCH_VERSION
export PATH=\$GROMACS_ROOT/bin:\$PATH
EOF
GROMACSVARS_SH=$PREFIX_APPS/gromacs/gromacsvars-$GROMACS_VERSION-$GROMACS_PATCH_VERSION.sh
$SUDO_APPS rm -f $GROMACSVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/gromacsvars.sh $GROMACSVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/gromacs