#!/bin/bash

git apply $(dirname $0)/keepradiochannel.diff
echo "CONFIG_PATA_ATIIXP=y" >> $(dirname $0)/openwrt/target/linux/x86/generic/config-default


