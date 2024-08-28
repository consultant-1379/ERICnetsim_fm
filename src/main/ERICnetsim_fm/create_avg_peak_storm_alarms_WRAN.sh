#!/bin/bash

if [ -r /netsim/ERICnetsim_fm/netsim_wran_cfg ] ; then
    . /netsim/ERICnetsim_fm/netsim_wran_cfg
else
   echo "netsim_wran_cfg missing - please rectify this is needed for FM load"
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
    let CURR_ID=$AVG_ID
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

                
                # burst RNC  ID       CEASE_AFTER RNCRATE NUM_ALARMS LOOP    RBSRATE
                  burst $RNC $CURR_ID $AVG_CA $AVG_RNCR $AVG_NALMS $AVG_LOOP $AVG_RBSR              
                
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
    burst $FM_PEAKRNC $PK_ID $PK_CA $PK_RNCR $PK_NALMS $PK_LOOP $PK_RBSR
    
    
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
    burst $FM_STORMRNC $STRM_ID $STRM_CA $STRM_RNCR $STRM_NALMS $STRM_LOOP $STRM_RBSR
    
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

