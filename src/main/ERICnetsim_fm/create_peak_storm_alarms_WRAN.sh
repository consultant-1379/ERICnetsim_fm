#!/bin/bash

if [ -r /netsim/netsim_cfg ] ; then
    . /netsim/netsim_cfg
else
   echo "netsim_cfg missing - please rectify this is needed for FM load"
fi

###############################SHIPMENT#########################################
## This script no longer needs shipment.cfg or project.cfg, all included here ##
################################################################################

WDIR=`dirname $0`
SCRIPT=`basename $0`

#### 1. NETSIM #############

PIPE=/netsim/inst/netsim_pipe

##### 2. Get Server##########

get_server_for_RNC() {
  RESULT=""
  THE_RNC=$1
  for SERVER in ${SERVERS} ; do
        RNC_LIST=`eval echo \\$${SERVER}_list`

        echo "${RNC_LIST}" | grep ${THE_RNC} > /dev/null
        if [ $? -eq 0 ] ; then
                RESULT=${SERVER}
                break
        fi
  done
  if [ "${RESULT}" = "" ]; then
    echo "Did not find $1 in the lists check your config file is correct if turning on CMS Network Load or FM"
#    exit
  fi
}

############# 3. FM #######

FM_AVERAGE_LTE_LIST="LTE01 LTE02 LTE03 LTE04 LTE05 LTE06 LTE07 LTE08"
FM_AVERAGE_RNC_LIST="RNC01 RNC03 RNC04 RNC05 RNC06 RNC07 RNC08 RNC09"
# LIST1=FMX=8NODES 40%
# LIST2=FM NODESYNCHTPINITIALPHASE NODES 10%
# LIST3=NOT SHORT LIVED UTRANCELL 2 NODES
# LIST4=SHORT LIVED UTRANCELL 5 NODES
# LIST5=ALMDEVICE NOT SHORT LIVED DIFFERENT CELLS
# LIST6=ALMDEVICE SHORT LIVED DIFFERENT CELLS
# LIST7=ALMDEVICE

# THE FOLLOWING IS THE LISTS OF DIFFERENT  ALARM TYPES TO BE USED IN ALARM GENERATION
FM_ALMDEVICE_LONG_START=01 # LIST1 ALMDEVICE LONG LIVED
FM_ALMDEVICE_LONG_END=05
FM_ALMDEVICE_SHORT_START=06 #LIST2 ALMDEVICE SHORT LIVED
FM_ALMDEVICE_SHORT_END=57
FM_NBAP_LONG_START=58      # LIST3  UTRAN NBAP MESSAGE FAILED SHORT LIVED
FM_NBAP_LONG_END=63
FM_NBAP_SHORT_START=64    # LIST4 UTRAN NBAP MESSAGE FAILED LONG LIVED
FM_NBAP_SHORT_END=124

FM_PEAKLTE=LTE06
FM_PEAKRNC=RNC06
FM_FMX_PEAK_LIST_START=01
FM_FMX_PEAK_LIST_END=08
FM_PEAK_LIST_START=09
FM_PEAK_LIST_END=10
FM_PEAK_UTRANCELL_START=11   #LIST3
FM_PEAK_UTRANCELL_END=11
FM_PEAK_UTRANCELL_SHORTLIVED_START=12   #LIST4
FM_PEAK_UTRANCELL_SHORTLIVED_END=13
FM_PEAK_ALMDEVICE_DIFFSETTINGS_START=14   #LIST5
FM_PEAK_ALMDEVICE_DIFFSETTINGS_END=19

FM_STORMLTE=LTE09
FM_STORMRNC=RNC09
FM_FMX_STORM_LIST_START=1
FM_FMX_STORM_LIST_END=8
FM_STORM_LIST_START=9
FM_STORM_LIST_END=10
FM_STORM_UTRANCELL_START=11   #LIST3
FM_STORM_UTRANCELL_END=11
FM_STORM_UTRANCELL_SHORTLIVED_START=12   #LIST4
FM_STORM_UTRANCELL_SHORTLIVED_END=13
FM_STORM_ALMDEVICE_DIFFSETTINGS_START=14   #LIST5
FM_STORM_ALMDEVICE_DIFFSETTINGS_END=19
get_server_for_RNC $FM_PEAKRNC
FM_PEAK_SERVER=$RESULT
get_server_for_RNC $FM_STORMRNC
FM_STORM_SERVER=$RESULT

################## FM LOAD ############################################

makeRbsList() 
{
    MY_RNC=$1
    MY_START_NUM=$2
    MY_END_NUM=$3

    MY_LIST=""
    let RBS_ID=${MY_START_NUM}   
    while [ ${RBS_ID} -le ${MY_END_NUM} ] ; do
	RBS=`printf "%sRBS%02d" $MY_RNC $RBS_ID`
	MY_LIST="${MY_LIST} ${RBS}"
	let RBS_ID=${RBS_ID}+1
    done
    
    echo "${MY_LIST}"
}

average()
{
    echo "Going to do average alarms"
    let CURR_ID=100
    for RNC in $LIST; do     
        for FMRNC in $FM_AVERAGE_RNC_LIST; do  
            if [ "$RNC" = "$FMRNC" ]; then
		LIST1=`makeRbsList $RNC 1 50`
		LIST2=`makeRbsList $RNC 51 56`
		LIST3=`makeRbsList $RNC 57 73`
		LIST4=`makeRbsList $RNC 73 75`
		LIST5=`makeRbsList $RNC 73 75`
		LIST6=`makeRbsList $RNC 59 75`
		LIST7=`makeRbsList $RNC 42 58 ` 
		LIST8=`makeRbsList $RNC 31 41`

                
                # burst RNC ID CEASE_AFTER RNCRATE NUM_ALARMS LOOP RBSRATE
                burst $RNC $CURR_ID 180 0.42 60 true 0.015               
                # Explanation of setting rate in average burst:
                # RBSRATE is the alarms/sec/RBSnode, for Average multiply this by 8*45=360 nodes to get the Average Rate per RBS per sec.
                # RNCRATE is the alarms/sec/RNCnode, for Average multiply this by 8 RNC's to get the Average Rate per RBC per sec.
                # Add the RBSRATE and the RNCRATE togather to get the overall continuous RNC+RBS rate.
                # In this example "burst $RNC $CURR_ID 180 0.42 60 true 0.0111"
                # 0.007 * 992 =6.944  is the overall RBS average rate
                # 0.011573 * 600 =6.944 is the overall RBS average rate for 12.2
                # 0.42 * 8 = 3.36 is the overall RNC average rate
                # Therefore Average Rate is 10.8 + 3.36 = 14.16
                # LOOP is set to true for average so the NUM_ALARMS value is irrelevant.
                # If you change the RBSRATE, then you DO NOT need to change the NUM_ALARMS for average
                # Another example: "burst $RNC $CURR_ID 180 0.45 60 true 0.009"
                # 0.0099 * 992 = 9.82 is the overall RBS average rate
		# 0.45 * 8 = 3.6 is the overall RNC average rate
                # Therefore Average Rate is 9.82 + 3.6 = 13.42
                
		let CURR_ID=${CURR_ID}+1
                break
            fi
        done
    done    
}

peak()
{
    echo "#Creating peak alarm rate"
    echo "#peak rate is 30 alarm or alarm ceasing per second for a duration of 300 seconds"


    LIST1=`makeRbsList $FM_PEAKRNC 01 09`
    LIST2=`makeRbsList $FM_PEAKRNC 10 10`
    LIST3=`makeRbsList $FM_PEAKRNC 11 12`
    LIST4=`makeRbsList $FM_PEAKRNC 13 13 ` 
    LIST5=`makeRbsList $FM_PEAKRNC 14 14`
    LIST6=`makeRbsList $FM_PEAKRNC 15 16`
    LIST7=`makeRbsList $FM_PEAKRNC 17 18`
    LIST8=`makeRbsList $FM_PEAKRNC 19 20`
    
    # burst RNC ID CEASE_AFTER RNCRATRE NUM_ALARMS LOOP RBSRATE
    burst $FM_PEAKRNC 110 1 0 270 false 0.9
    
    # Explanation of setting rate in peak burst:
    # RBSRATE is the alarms/sec/node, for Peak multiply this by 20 nodes to get the Peak Rate per sec.
    # LOOP is set to false for peak so when the NUM_ALARMS sent per node at the RBSRATE, the burst will stop which is correct as it should only last for 5 minute.
    # If you change the RBSRATE, then you MUST change the NUM_ALARMS
    # For Peak in this example "burst $FM_PEAKRNC 110 1 0 270 false 0.9"
    # 0.9 (alarms per/sec/node) * 60 (sec) * 5 (min peak length) = 270
    # 0.9 (alarms per/sec/node) * 20 (nodes) = 18 alarms/sec
    # For Peak in another example "burst $FM_PEAKRNC 110 1 0 330 false 1.1"
    # 1.1 (alarms per/sec/node) * 60 (sec) * 5 (min peak length) = 330 
    # 1.1 (alarms per/sec/node) * 20 (nodes) = 22 alarms/sec
    
}

storm()
{
    echo "#Creating storm alarm rate"
    echo "#storm rate is 200 alarm/alarm ceasing per second for a duration of 60 seconds"


    LIST1=`makeRbsList $FM_STORMRNC 21 31`
    LIST2=`makeRbsList $FM_STORMRNC 32 32`
    LIST3=`makeRbsList $FM_STORMRNC 33 35`
    LIST4=`makeRbsList $FM_STORMRNC 36 37`
    LIST5=`makeRbsList $FM_STORMRNC 37 38`
    LIST6=`makeRbsList $FM_STORMRNC 39 41`
    LIST7=`makeRbsList $FM_STORMRNC 42 46`
    LIST8=`makeRbsList $FM_STORMRNC 47 49`
    
    # burst RNC ID CEASE_AFTER RNCRATRE NUM_ALARMS LOOP RBSRATE
    burst $FM_STORMRNC 110 1 0 400 false 6.667
    
    # Explanation of setting rate in storm burst:
    # RBSRATE is the alarms/sec/node, for Storm multiply this by 30 nodes to get the Storm Rate per sec.
    # LOOP is set to false for storm so when the NUM_ALARMS sent per node at the RBSRATE, the burst will stop which is correct as it should only last for 1 minute.
    # If you change the RBSRATE, then you MUST change the NUM_ALARMS
    # For Storm in this example "burst $FM_STORMRNC 110 1 0 400 false 6.667"
    # 6.667 (alarms per/sec/node) * 60 (sec) * 1 (min storm length) = 400
    # 6.667 (alarms per/sec/node) * 30 (nodes) = 200 alarms/sec
    # For Storm in another example "burst $FM_STORMRNC 110 1 0 420 false 7"
    # 7 (alarms per/sec/node) * 60 (sec) * 1 (min storm length) = 420    
    # 7 (alarms per/sec/node) * 30 (nodes) = 210 alarms/sec
    # !! If you change from 30 Nodes above then you'll need to recalculate !!
}

burst() 
{
    MY_RNC=$1
    MY_ID=$2
    MY_CEASE_AFTER=$3
    MY_RNC_RATE=$4
    MY_NUM_ALARMS=$5
    MY_LOOP=$6
    MY_RBS_FREQ=$7

    #netsim download page, nsperf program, print amount ofalarms per second
    SIM=`ls /netsim/netsimdir | grep ${MY_RNC} | grep -v zip`

    cat <<EOF
.open $SIM
.select ${MY_RNC}

alarmburst:freq=${MY_RNC_RATE},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,RncFunction=1,IubLink=%unique{100}",system_dn="%mibprefix",cause=1, severity=4, problem="AuxPlugInUnit_PiuConnectionLost",text="Air Conditioner Failure",type = ET_COMMUNICATIONS_ALARM, cease_after=1, clear_after_burst=true,id=${MY_ID};

.select ${LIST1}
alarmburst:freq=${MY_RBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{10}", system_dn="%mibprefix", cause=1, severity=4, problem="NodeSynchTp_ConnectionLost",text="Smoke Detected",type = ET_COMMUNICATIONS_ALARM, cease_after=1, clear_after_burst=true,id=${MY_ID};

.select ${LIST2}
alarmburst:freq=${MY_RBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{10}", system_dn="%mibprefix", cause=1, severity=4, problem="NodeSynchTp_ConnectionLost",text="Mains Alarm",type = ET_COMMUNICATIONS_ALARM, cease_after=${MY_CEASE_AFTER},clear_after_burst=true,id=${MY_ID};

.select ${LIST3}
alarmburst:freq=${MY_RBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{10}", system_dn="%mbprefix", cause=1, severity=3, problem="AlmDevice_ExternalAlarm",text="High Temperature",type = ET_COMMUNICATIONS_ALARM, cease_after=1, clear_after_burst=true,id=${MY_ID};

.select ${LIST4}
alarmburst:freq=${MY_RBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{10}", system_dn="%mibprefix", cause=1, severity=2, problem="AlmDevice_ExternalAlarm",text="Aircraft Light Faulty",type = ET_COMMUNICATIONS_ALARM, cease_after=${MY_CEASE_AFTER},clear_after_burst=true,id=${MY_ID};


.select ${LIST5}
alarmburst:freq=${MY_RBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{10}", system_dn="%mibprefix", cause=1, severity=2, problem="AlmDevice_ExternalAlarm",text="Long Lived",type = ET_COMMUNICATIONS_ALARM, cease_after=${MY_CEASE_AFTER},clear_after_burst=true,id=${MY_ID};

.select ${LIST6}
alarmburst:freq=${MY_RBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{10}", system_dn="%mibprefix", cause=1, severity=2, problem="AlmDevice_ExternalAlarm",text="Battery Fail",type = ET_COMMUNICATIONS_ALARM, cease_after=1,clear_after_burst=true,id=${MY_ID};

.select ${LIST7}
alarmburst:freq=${MY_RBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{10}", system_dn="%mibprefix", cause=1, severity=2, problem="AlmDevice_ExternalAlarm",text="Air Conditioner Failure",type = ET_COMMUNICATIONS_ALARM, cease_after=1,clear_after_burst=true,id=${MY_ID};

.select ${LIST8}
alarmburst:freq=${MY_RBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{10}", system_dn="%mibprefix", cause=1, severity=5, problem="IMA Link Transmission Misconnected",text="ConfigurationMismatch",type = ET_COMMUNICATIONS_ALARM, cease_after=1,clear_after_burst=true,id=${MY_ID};


EOF
}


if [ $# -ne 1 ]; then
    echo "#Usage: ./create_peak_storm_alarms.sh  peak | /netsim/${VERSION}/netsim_pipe"
    echo "Note:  The script sends 40% of the alarms with a problem text "Fan SW Fault" for FMX to filter"
    exit 1
fi

case $1 in
    average) average;;
    peak) peak ;;
    storm) storm;;
    *) echo "ERROR: Unknown type $1";;
esac



