#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

FFTWVARS_SH=$PREFIX_TOOL/fftw/fftwvars-$FFTW_VERSION-$FFTW_MA_REVISION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/fftwvars.sh
$SUDO_TOOL ln -s $FFTWVARS_SH $PREFIX_TOOL/env.d/fftwvars.sh
