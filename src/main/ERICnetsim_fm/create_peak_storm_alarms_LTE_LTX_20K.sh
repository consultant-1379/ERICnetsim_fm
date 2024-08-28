#!/bin/bash

##########
#
# Revision: E
#
# History:
#	  3 Jan 2012-	changed nodes sending average alarm rate
#
##########
#### 1. NETSIM #############

SIMLIST=`ls /netsim/netsimdir | grep LTE | grep -v zip`
GROUP_LIST=`echo ${SIMLIST} | awk 'BEGIN {RS=" " } { print $0}' | sed 's/.*-LTE/LTE/g' `

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
#get_server_for_RNC $FM_PEAKRNC
FM_PEAK_SERVER=$RESULT
#get_server_for_RNC $FM_STORMRNC
FM_STORM_SERVER=$RESULT

################## FM LOAD ############################################

makeRbsList()
{
    MY_LTE=$1
    MY_START_NUM=$2
    MY_END_NUM=$3

    MY_LIST=""
    let ERBS_ID=${MY_START_NUM}
    while [ ${ERBS_ID} -le ${MY_END_NUM} ] ; do
        ERBS=`printf "%sERBS%05d" $MY_LTE $ERBS_ID`
        MY_LIST="${MY_LIST} ${ERBS}"
        let ERBS_ID=${ERBS_ID}+1
    done

    echo "${MY_LIST}"
}

average()
{
    echo "Going to do average alarms"
    let CURR_ID=100
    for LTE in $GROUP_LIST; do
        for FMLTE in $FM_AVERAGE_LTE_LIST; do #
            if [ "$LTE" = "$FMLTE" ]; then
               LIST1=`makeRbsList $LTE 1 6`
                LIST2=`makeRbsList $LTE 7 14`
                LIST3=`makeRbsList $LTE 16 23`
                LIST4=`makeRbsList $LTE 25 30`
    #The below nodes are used to keep alarms active for > 15 mins to keep in line with the TERE
                LIST5=`makeRbsList $LTE 15 15`
                LIST6=`makeRbsList $LTE 24 24`

                # burst LTE ID CEASE_AFTER LTERATE NUM_ALARMS LOOP ERBSRATE
		burst $LTE $CURR_ID 40 0 60 true 0.037488
                # Explanation of setting rate in average burst:
                # ERBSRATE is the alarms/sec/ERBSnode, for Average multiply this by 8*30=240 nodes to get the Average Rate per ERBS per sec.
                # In this example "burst $LTE $CURR_ID 180 0 60 true 0.0270"
                # 0.0270 * 240 = 6.48 alarms/sec is the overall ERBS average rate
                # LOOP is set to true for average so the NUM_ALARMS value is irrelevant.
                # If you change the RBSRATE, then you DO NOT need to change the NUM_ALARMS for average
                # Another example: "burst $LTE $CURR_ID 180 0 60 true 0.023"
                # 0.023 * 240 = 5.52 alarms/sec is the overall ERBS average rate                
                
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
    echo "#Creating 1 alarm and then the next second it creates 1 cease alarm per second on 30 nodes s
eems to produce this"
    echo "#Creating 300 alarms and 300 alarm ceasing per node "
    echo "#This gives 30 alarm/alarm ceasing per second"

    LIST1=`makeRbsList $FM_PEAKLTE 31 37`
    LIST2=`makeRbsList $FM_PEAKLTE 38 42`
    LIST3=`makeRbsList $FM_PEAKLTE 43 47`
    LIST4=`makeRbsList $FM_PEAKLTE 48 50`

    # burst RNC ID CEASE_AFTER RNCRATRE NUM_ALARMS LOOP ERBSRATE
    burst $FM_PEAKLTE 110 180 0 315 false 1.05014
    
    # Explanation of setting rate in peak burst:
    # ERBSRATE is the alarms/sec/node, for Peak multiply this by 20 nodes to get the Peak Rate per sec.
    # LOOP is set to false for peak so when the NUM_ALARMS sent per node at the ERBSRATE, the burst will stop which is correct as it should only last for 5 minute.
    # If you change the ERBSRATE, then you MUST change the NUM_ALARMS
    # For Peak in this example "burst $FM_PEAKLTE 110 1 0 330 false 1.10"
    # 1.10 (alarms per/sec/node) * 60 (sec) * 5 (min peak length) = 330
    # 1.10 (alarms per/sec/node) * 20 (nodes) = 22 alarms/sec
    # For Peak in another example "burst $FM_PEAKLTE 110 1 0 285 false 0.95"
    # 0.95 (alarms per/sec/node) * 60 (sec) * 5 (min peak length) = 285
    # 0.95 (alarms per/sec/node) * 20 (nodes) = 19 alarms/sec
    
}

storm()
{
    echo "#Creating storm alarm rate"
    echo "#storm rate is 200 alarm/alarm ceasing per second for a duration of 60 seconds"
    echo "#create a burst of 2 alarms per second using freq = 2"
    echo "#create a burst of 120alarms    which at 2 alarms per second this will last for 1 minutes"
    echo "#Do this on 100 nodes and this gives 200 alarm/alarm ceasing per second for 60 seconds"

#The script sends Storm Alarms to LTE06 and 90% of them are filtered by FMX 

    LIST1=`makeRbsList $FM_STORMLTE 31 60`
    #LIST2=`makeRbsList $FM_STORMLTE 37 45`
    #LIST3=`makeRbsList $FM_STORMLTE 46 54`
    #LIST4=`makeRbsList $FM_STORMLTE 55 60`


    # burst RNC ID CEASE_AFTER RNCRATRE NUM_ALARMS LOOP ERBSRATE
    burst $FM_STORMLTE 110 1 0 400 false 6
    
    # Explanation of setting rate in storm burst:
    # ERBSRATE is the alarms/sec/node, for Storm multiply this by 30 nodes to get the Storm Rate per sec.
    # LOOP is set to false for storm so when the NUM_ALARMS sent per node at the ERBSRATE, the burst will stop which is correct as it should only last for 1 minute.
    # If you change the ERBSRATE, then you MUST change the NUM_ALARMS
    # For Storm in this example "burst $FM_STORMLTE 110 1 0 400 false 6.67"
    # 6.67 (alarms per/sec/node) * 60 (sec) * 1 (min storm length) = 400
    # 6.67 (alarms per/sec/node) * 30 (nodes) = 200 alarms/sec
    # For Storm in another example "burst $FM_STORMLTE 110 1 0 360 false 7"
    # 7 (alarms per/sec/node) * 60 (sec) * 1 (min storm length) = 360
    # 7 (alarms per/sec/node) * 30 (nodes) = 210 alarms/sec
    # !! If you change from 30 Nodes above then you'll need to recalculate !!
    
}


burst()
{
    MY_LTE=$1
    MY_ID=$2
    MY_CEASE_AFTER=$3
    MY_LTE_RATE=$4
    MY_NUM_ALARMS=$5
    MY_LOOP=$6
    MY_ERBS_FREQ=$7

    #netsim download page, nsperf program, print amount ofalarms per second
    SIM=`ls /netsim/netsimdir | grep ${MY_LTE} | grep -v zip`
if [ $LIST5 ] ; then

    if [ $MY_LTE = "LTE08" -o $MY_LTE = "LTE07" ] ;  then 
	cat <<NEW_FUNC
.open $SIM

.select ${LIST5}
alarmburst:freq=${MY_ERBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{40}", system_dn="%mibprefix", cause=1, severity=3, problem="TU Synch Reference Loss of Signal",type = ET_COMMUNICATIONS_ALARM, cease_after=1,clear_after_burst=true,id=${MY_ID};

.select ${LIST6}
alarmburst:freq=${MY_ERBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{40}", system_dn="%mbprefix", cause=1, severity=2, problem="LinkFailure",type = ET_COMMUNICATIONS_ALARM, cease_after=1, clear_after_burst=true,id=${MY_ID};

NEW_FUNC

    else
        cat <<MY_FUNC
.open $SIM

.select ${LIST5}
alarmburst:freq=${MY_ERBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{40}", system_dn="%mibprefix", cause=1, severity=3, problem="TU Synch Reference Loss of Signal",type = ET_COMMUNICATIONS_ALARM, cease_after=$MY_CEASE_AFTER,clear_after_burst=true,id=${MY_ID};

.select ${LIST6}
alarmburst:freq=${MY_ERBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{40}", system_dn="%mbprefix", cause=1, severity=2, problem="LinkFailure",type = ET_COMMUNICATIONS_ALARM, cease_after=$MY_CEASE_AFTER, clear_after_burst=true,id=${MY_ID};

MY_FUNC
   fi

else
	echo ""

fi




    cat <<EOF
.open $SIM

.select ${LIST1}
alarmburst:freq=${MY_ERBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{10}", system_dn="%mibprefix", cause=1, severity=2, problem="AlmDevice_ExternalAlarm",text="Aircraft Light Facility",type = ET_COMMUNICATIONS_ALARM, cease_after=1,clear_after_burst=true,id=${MY_ID};

.select ${LIST2}
alarmburst:freq=${MY_ERBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{10}", system_dn="%mibprefix", cause=1, severity=3, problem="TU Synch Reference Loss of Signal",type = ET_COMMUNICATIONS_ALARM, cease_after=1,clear_after_burst=true,id=${MY_ID};

.select ${LIST3}
alarmburst:freq=${MY_ERBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{10}", system_dn="%mbprefix", cause=1, severity=2, problem="LinkFailure",type = ET_COMMUNICATIONS_ALARM, cease_after=1, clear_after_burst=true,id=${MY_ID};

.select ${LIST4}
alarmburst:freq=${MY_ERBS_FREQ},num_alarms=${MY_NUM_ALARMS},loop=${MY_LOOP},idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{10}", system_dn="%mibprefix", cause=1, severity=1, problem="NssSynchronization_SystemClockStatusChanged",type = ET_COMMUNICATIONS_ALARM, cease_after=1, clear_after_burst=true,id=${MY_ID};

EOF





}


if [ $# -ne 1 ]; then
    echo "#Usage: ./create_peak_storm_alarms.sh peak | /netsim/${VERSION}/netsim_pipe"
    echo "Note:  The script sends 40% of the alarms with a problem text "Fan SW Fault" for FMX to filt
er"
    exit 1
fi

case $1 in
    average) average;;
    peak) peak ;;
    storm) storm;;
    *) echo "ERROR: Unknown type $1";;
esac

