#!/bin/sh
echo 0 > /sys/block/zram0/disksize
/system/bin/mkswap /dev/block/zram0
# ifndef VENDOR_EDIT //yixue.ge@bsp.drv modify for zram
# /system/bin/swapon /dev/block/zram0
# else
/system/bin/swapon /dev/block/zram0 -p 32758
echo 180 > /proc/sys/vm/swappiness
echo 60 > /proc/sys/vm/direct_swappiness
echo 0 > /proc/sys/vm/page-cluster
# endif
