#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/platform/mtk-msdc.0/11230000.msdc0/by-name/recovery:16490064:0e4d99f008216226646e38cc93be7ce082f053a6; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/mtk-msdc.0/11230000.msdc0/by-name/boot:11013712:f86cbec75e10a8b696e44b517eaa64a49485eaf3 EMMC:/dev/block/platform/mtk-msdc.0/11230000.msdc0/by-name/recovery 0e4d99f008216226646e38cc93be7ce082f053a6 16490064 f86cbec75e10a8b696e44b517eaa64a49485eaf3:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
