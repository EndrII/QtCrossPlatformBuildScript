#!/bin/bash

base_host="Linux-static"

if [[ "$#" -eq "0" || "$base_host" != *$1*  ]]
 then
    echo "Usage: $0 host-platform-triplet [flags]" 
    echo
    echo "   host-platform-triplet: "
    echo "   * Linux-static          for   Linux static build"

    exit 1 
fi



QT_VERSION=5.10
QT_UPDATE_VERSION=0
QT=qtbase-everywhere-src-$QT_VERSION.$QT_UPDATE_VERSION

QT_TAR="$QT.tar.xz"
DONWLOAD_PATH=http://download.qt.io/official_releases/qt/$QT_VERSION/$QT_VERSION.$QT_UPDATE_VERSION/submodules/$QT_TAR
STATIC_SOURCE_DIR=QtSource

MAIN_DIR=$PWD

HOST=$1
shift

if !(test -f "$QT_TAR"); 
then
 	wget $DONWLOAD_PATH
fi

mkdir $STATIC_SOURCE_DIR

HOST_DIR=$STATIC_SOURCE_DIR/"$QT-$HOST"

 
if !(test -d "$HOST_DIR");
then	
	mkdir $MAIN_DIR/$HOST_DIR
	tar xf $QT_TAR -C $HOST_DIR --strip-components=1

	cd $HOST_DIR

	./configure -static -release -opensource -confirm-license

	make -j$(nproc)

	cd $MAIN_DIR

fi

PATH=$MAIN_DIR/$HOST_DIR/bin:$PATH

export PATH
qmake -config release $@
make -j$(nproc)


exit 0

