#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

FERAMVARS_SH=$PREFIX_APPS/feram/feramvars-$FERAM_VERSION-$FERAM_MA_REVISION.sh
$SUDO_APPS rm -f $PREFIX_APPS/feram/feramvars.sh
$SUDO_APPS ln -s $FERAMVARS_SH $PREFIX_APPS/feram/feramvars.sh
