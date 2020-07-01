#!/bin/bash

source ../ENVSETTINGS

umount -l -v $DATACONTAINERMNT
umount -l -v $INICONTAINERMNT


cryptsetup -q luksClose $DATACONTAINERLOOPDEV
cryptsetup -q luksClose $INICONTAINERLOOPDEV
