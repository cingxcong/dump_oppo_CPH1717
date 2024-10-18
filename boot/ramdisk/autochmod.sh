#!/system/bin/sh

config="$1"


function junklogcat() {

    JUNKLOGPATH=/sdcard/oppo_log/junk_logs
    mkdir -p ${JUNKLOGPATH}

    system/bin/logcat -f ${JUNKLOGPATH}/junklogcat.txt -v threadtime *:V
}
function junkdmesg() {
    JUNKLOGPATH=/sdcard/oppo_log/junk_logs
    mkdir -p ${JUNKLOGPATH}
    system/bin/dmesg > ${JUNKLOGPATH}/junkdmesg.txt
}
function junksystrace_start() {
    JUNKLOGPATH=/sdcard/oppo_log/junk_logs
    mkdir -p ${JUNKLOGPATH}

    #setup
    setprop debug.atrace.tags.enableflags 0x86E
    # stop;start
    adb shell "echo 16384 > /sys/kernel/debug/tracing/buffer_size_kb"

    echo nop > /sys/kernel/debug/tracing/current_tracer
    echo 'sched_switch sched_wakeup sched_wakeup_new sched_migrate_task binder workqueue irq cpu_frequency mtk_events' > /sys/kernel/debug/tracing/set_event
#just in case tracing_enabled is disabled by user or other debugging tool
    echo 1 > /sys/kernel/debug/tracing/tracing_enabled >nul 2>&1
    echo 0 > /sys/kernel/debug/tracing/tracing_on
#erase previous recorded trace
    echo > /sys/kernel/debug/tracing/trace
    echo press any key to start capturing...
    echo 1 > /sys/kernel/debug/tracing/tracing_on
    echo "Start recordng ftrace data"
    echo s_start > sdcard/s_start2.txt
}
function junksystrace_stop() {
    JUNKLOGPATH=/sdcard/oppo_log/junk_logs
    mkdir -p ${JUNKLOGPATH}
    echo s_stop > sdcard/s_stop.txt
    echo 0 > /sys/kernel/debug/tracing/tracing_on
    echo "Recording stopped..."
    cp /sys/kernel/debug/tracing/trace ${JUNKLOGPATH}/junksystrace
    echo 1 > /sys/kernel/debug/tracing/tracing_on

}

#ifdef VENDOR_EDIT
#Fei.Mo@PSW.BSP.Sensor, 2017/09/01 ,Add for power monitor top info
function thermalTop(){
   top -m 3 -n 1 > /data/system/dropbox/thermalmonitor/top
   chown system:system /data/system/dropbox/thermalmonitor/top
}
#endif /*VENDOR_EDIT*/

function gettpinfo() {
    tplogflag=`getprop persist.sys.oppodebug.tpcatcher`
    # tplogflag=511
    # echo "$tplogflag"
    if [ "$tplogflag" == "" ]
    then
        echo "tplogflag == error"
    else
        kernellogpath=sdcard/mtklog/tp_debug_info/
        subcur=`date +%F-%H-%M-%S`
        subpath=$kernellogpath/$subcur.txt
        mkdir -p $kernellogpath
        echo $tplogflag
        # tplogflag=`echo $tplogflag | $XKIT awk '{print lshift($0, 1)}'`
        tpstate=0
        tpstate=`echo $tplogflag | $XKIT awk '{print and($1, 1)}'`
        echo "switch tpstate = $tpstate"
        if [ $tpstate == "0" ]
        then
            echo "switch tpstate off"
        else
            echo "switch tpstate on"
        fi
        # mFlagMainRegister = 1 << 1
        subflag=`echo | $XKIT awk '{print lshift(1, 1)}'`
        echo "1 << 1 subflag = $subflag"
        tpstate=`echo $tplogflag $subflag, | $XKIT awk '{print and($1, $2)}'`
        if [ $tpstate == "0" ]
        then
            echo "switch tpstate off mFlagMainRegister = 1 << 1 $tpstate"
        else
            echo "switch tpstate on mFlagMainRegister = 1 << 1 $tpstate"
            echo /proc/touchpanel/debug_info/main_register  >> $subpath
            cat /proc/touchpanel/debug_info/main_register  >> $subpath
        fi
        # mFlagSelfDelta = 1 << 2;
        subflag=`echo | $XKIT awk '{print lshift(1, 2)}'`
        echo " 1<<2 subflag = $subflag"
        tpstate=`echo $tplogflag $subflag, | $XKIT awk '{print and($1, $2)}'`
        if [ $tpstate == "0" ]
        then
            echo "switch tpstate off mFlagMainRegister = 1 << 2 $tpstate"
        else
            echo "switch tpstate on mFlagMainRegister = 1 << 2 $tpstate"
            echo /proc/touchpanel/debug_info/self_delta  >> $subpath
            cat /proc/touchpanel/debug_info/self_delta  >> $subpath
        fi
        # mFlagDetal = 1 << 3;
        subflag=`echo | $XKIT awk '{print lshift(1, 3)}'`
        echo "1 << 3 subflag = $subflag"
        tpstate=`echo $tplogflag $subflag, | $XKIT awk '{print and($1, $2)}'`
        if [ $tpstate == "0" ]
        then
            echo "switch tpstate off mFlagMainRegister = 1 << 3 $tpstate"
        else
            echo "switch tpstate on mFlagMainRegister = 1 << 3 $tpstate"
            echo /proc/touchpanel/debug_info/delta  >> $subpath
            cat /proc/touchpanel/debug_info/delta  >> $subpath
        fi
        # mFlatSelfRaw = 1 << 4;
        subflag=`echo | $XKIT awk '{print lshift(1, 4)}'`
        echo "1 << 4 subflag = $subflag"
        tpstate=`echo $tplogflag $subflag, | $XKIT awk '{print and($1, $2)}'`
        if [ $tpstate == "0" ]
        then
            echo "switch tpstate off mFlagMainRegister = 1 << 4 $tpstate"
        else
            echo "switch tpstate on mFlagMainRegister = 1 << 4 $tpstate"
            echo /proc/touchpanel/debug_info/self_raw  >> $subpath
            cat /proc/touchpanel/debug_info/self_raw  >> $subpath
        fi
        # mFlagBaseLine = 1 << 5;
        subflag=`echo | $XKIT awk '{print lshift(1, 5)}'`
        echo "1 << 5 subflag = $subflag"
        tpstate=`echo $tplogflag $subflag, | $XKIT awk '{print and($1, $2)}'`
        if [ $tpstate == "0" ]
        then
            echo "switch tpstate off mFlagMainRegister = 1 << 5 $tpstate"
        else
            echo "switch tpstate on mFlagMainRegister = 1 << 5 $tpstate"
            echo /proc/touchpanel/debug_info/baseline  >> $subpath
            cat /proc/touchpanel/debug_info/baseline  >> $subpath
        fi
        # mFlagDataLimit = 1 << 6;
        subflag=`echo | $XKIT awk '{print lshift(1, 6)}'`
        echo "1 << 6 subflag = $subflag"
        tpstate=`echo $tplogflag $subflag, | $XKIT awk '{print and($1, $2)}'`
        if [ $tpstate == "0" ]
        then
            echo "switch tpstate off mFlagMainRegister = 1 << 6 $tpstate"
        else
            echo "switch tpstate on mFlagMainRegister = 1 << 6 $tpstate"
            echo /proc/touchpanel/debug_info/data_limit  >> $subpath
            cat /proc/touchpanel/debug_info/data_limit  >> $subpath
        fi
        # mFlagReserve = 1 << 7;
        subflag=`echo | $XKIT awk '{print lshift(1, 7)}'`
        echo "1 << 7 subflag = $subflag"
        tpstate=`echo $tplogflag $subflag, | $XKIT awk '{print and($1, $2)}'`
        if [ $tpstate == "0" ]
        then
            echo "switch tpstate off mFlagMainRegister = 1 << 7 $tpstate"
        else
            echo "switch tpstate on mFlagMainRegister = 1 << 7 $tpstate"
            echo /proc/touchpanel/debug_info/reserve  >> $subpath
            cat /proc/touchpanel/debug_info/reserve  >> $subpath
        fi
        # mFlagTpinfo = 1 << 8;
        subflag=`echo | $XKIT awk '{print lshift(1, 8)}'`
        echo "1 << 8 subflag = $subflag"
        tpstate=`echo $tplogflag $subflag, | $XKIT awk '{print and($1, $2)}'`
        if [ $tpstate == "0" ]
        then
            echo "switch tpstate off mFlagMainRegister = 1 << 8 $tpstate"
        else
            echo "switch tpstate on mFlagMainRegister = 1 << 8 $tpstate"
        fi

        echo $tplogflag " end else"
    fi

}
function inittpdebug(){
    panicstate=`getprop persist.sys.assert.panic`
    tplogflag=`getprop persist.sys.oppodebug.tpcatcher`
    if [ "$panicstate" == "true" ]
    then
        tplogflag=`echo $tplogflag , | $XKIT awk '{print or($1, 1)}'`
    else
        tplogflag=`echo $tplogflag , | $XKIT awk '{print and($1, 510)}'`
    fi
    setprop persist.sys.oppodebug.tpcatcher $tplogflag
}
function settplevel(){
    tplevel=`getprop persist.sys.oppodebug.tplevel`
    if [ "$tplevel" == "0" ]
    then
        echo 0 > /proc/touchpanel/debug_level
    elif [ "$tplevel" == "1" ]
    then
        echo 1 > /proc/touchpanel/debug_level
    elif [ "$tplevel" == "2" ]
    then
        echo 2 > /proc/touchpanel/debug_level
    fi
}
case "$config" in

    "junklogcat")
        junklogcat
    ;;
    "junkdmesg")
        junkdmesg
    ;;
    "junkststart")
        junksystrace_start
    ;;
    "junkststop")
        junksystrace_stop
    ;;
    "gettpinfo")
        gettpinfo
    ;;
    "inittpdebug")
        inittpdebug
    ;;
    "settplevel")
        settplevel
    ;;
    #Fei.Mo@PSW.BSP.Sensor, 2017/09/01 ,Add for power monitor top info
    "thermal_top")
        thermalTop
    #end, Add for power monitor top info
    ;;
       *)

      ;;
esac
