#ifdef VENDOR_EDIT
#Tongxing.Guo@Prd6.System.OppoDebug.LogKit, 2016/10/13, Add for Alarm log and Power log

config="$1"

function dumpAlarmAndPowerLogStart(){
#       dumpsys alarm log on
        dumpsys power log power 1
}


function dumpAlarmAndPowerLogEnd(){
#       dumpsys alarm log off
        dumpsys power log power 0
}

function dumpBugReportLogEnd(){
}
#end

case "$config" in
        "Log_on")
                dumpAlarmAndPowerLogStart
                ;;

        "Log_off")
                dumpAlarmAndPowerLogEnd
                ;;
esac

#endif /* VENDOR_EDIT */
