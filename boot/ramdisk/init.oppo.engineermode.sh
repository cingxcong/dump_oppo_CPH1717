#!/system/bin/sh

#################################
if [ -f /data/engineermode/engineermode_masterclear_flag ]; then
    setprop persist.sys.allcommode true
    setprop persist.allcommode true
    setprop persist.sys.oppo.usbactive true
    setprop persist.sys.adb.engineermode 0
    setprop sys.usb.config mtp,mass_storage,adb
    setprop persist.sys.usb.config mtp,mass_storage,adb
    rm /data/engineermode/engineermode_masterclear_flag
fi
##################################


