#!/bin/bash
HYNIX_EMCP_PROD_NAME_3D_64G="HCG8a4"
HYNIX_EMCP_PROD_NAME_2D_32G="HBG4a2"
HYNIX_EMCP_PROD_NAME_PROTECT_32G="hB8aP?"
SUMSUNG_EMCP_PROD_NAME_RH64MB="RH64MB"
SUMSUNG_EMCP_PROD_NAME_RH64AB="RH64AB"
SUMSUNG_EMCP_PROD_NAME_DH6DMB="DH6DMB"
SUMSUNG_EMCP_PROD_NAME_3H6CMB="3H6CMB"
SUMSUNG_EMCP_PROD_NAME_RD64MB="RD64MB"
SUMSUNG_EMCP_PROD_NAME_GD6BMB="GD6BMB"
SUMSUNG_EMCP_PROD_NAME_QE63MB="QE63MB"
SUMSUNG_EMCP_PROD_NAME_GE6BMB="GE6BMB"
SUMSUNG_EMCP_PROD_NAME_GX6BMB="GX6BMB"
SUMSUNG_EMCP_PROD_NAME_RX64MB="RX64MB"
SUMSUNG_EMCP_PROD_NAME_CKTM4R="CKTM4R"

MICRON_EMCP_PROD_NAME_3D_64G="S0J9F8"
fw_path=""
cmpresult=`cat /proc/devinfo/emmc | grep "${HYNIX_EMCP_PROD_NAME_3D_64G}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Hynix 3D nand emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/HYNIX-HCG8a4.bin_crc.bin";
fi
cmpresult=`cat /proc/devinfo/emmc | grep "${SUMSUNG_EMCP_PROD_NAME_RH64MB}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Sumsung 3D emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/SAMSUNG-RH64MB.bin_crc.bin";
fi
cmpresult=`cat /proc/devinfo/emmc | grep "${SUMSUNG_EMCP_PROD_NAME_RH64AB}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Sumsung 3D emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/SAMSUNG-RH64AB.bin_crc.bin";
fi
cmpresult=`cat /proc/devinfo/emmc | grep "${SUMSUNG_EMCP_PROD_NAME_DH6DMB}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Sumsung 3D emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/SAMSUNG-DH6DMB.bin_crc.bin";
fi
cmpresult=`cat /proc/devinfo/emmc | grep "${SUMSUNG_EMCP_PROD_NAME_3H6CMB}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Sumsung 3D emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/SAMSUNG-3H6CMB.bin_crc.bin";
fi
cmpresult=`cat /proc/devinfo/emmc | grep "${SUMSUNG_EMCP_PROD_NAME_RD64MB}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Sumsung 3D emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/SAMSUNG-RD64MB.bin_crc.bin";
fi
cmpresult=`cat /proc/devinfo/emmc | grep "${SUMSUNG_EMCP_PROD_NAME_GD6BMB}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Sumsung 3D emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/SAMSUNG-GD6BMB.bin_crc.bin";
fi
cmpresult=`cat /proc/devinfo/emmc | grep "${SUMSUNG_EMCP_PROD_NAME_QE63MB}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Sumsung 2D nand emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/SAMSUNG-QE63MB.bin_crc.bin";
fi
cmpresult=`cat /proc/devinfo/emmc | grep "${SUMSUNG_EMCP_PROD_NAME_GE6BMB}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Sumsung 2D nand emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/SAMSUNG-GE6BMB.bin_crc.bin";
fi
cmpresult=`cat /proc/devinfo/emmc | grep "${SUMSUNG_EMCP_PROD_NAME_GX6BMB}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Sumsung 2D nand emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/SAMSUNG-GX6BMB.bin_crc.bin";
fi
cmpresult=`cat /proc/devinfo/emmc | grep "${SUMSUNG_EMCP_PROD_NAME_RX64MB}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Sumsung 2D nand emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/SAMSUNG-RX64MB.bin_crc.bin";
fi
cmpresult=`cat /proc/devinfo/emmc | grep "${SUMSUNG_EMCP_PROD_NAME_CKTM4R}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Sumsung 2D nand emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/SAMSUNG-CKTM4R.bin_crc.bin";
fi
cmpresult=`cat /proc/devinfo/emmc | grep "${MICRON_EMCP_PROD_NAME_3D_64G}"`;
if [ "$cmpresult" != "" ]; then
	echo "cp Micron 3D nand emcp fw to reserve4 for upgrade";
	fw_path="/system/vendor/firmware/emmc/64GB_FFU_FW_HW_FW5.2.BIN_crc.bin";
fi
#reserve4 -> /dev/block/mmcblk0p7
if [ "$fw_path" != "" ]; then
	echo $fw_path;
	dd if="${fw_path}" of=/cache/src_fw_header bs=1 count=32;
	dd if=/dev/block/platform/bootdevice/by-name/reserve4 of=/cache/local_fw_header bs=1 count=32 skip=14680064;
	cmp -s /cache/src_fw_header /cache/local_fw_header;
	if [ $? -eq 1 ]; then
		echo "new fw found, copy to target partition";
		dd if="${fw_path}" of=/dev/block/platform/bootdevice/by-name/reserve4 bs=1 seek=14680064 skip=80;
	fi
fi
