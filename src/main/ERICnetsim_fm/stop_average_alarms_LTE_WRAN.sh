#!/bin/sh

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

FM_AVERAGE_LTE_LIST="LTE01 LTE02 LTE03 LTE04 LTE05 LTE06 LTE07 LTE08 LTE09"
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

################## STOP FM AVERAGE #######################

if [ $# -eq 1 ]; then
{
LIST=$1
}
fi

for RNC in $LIST; do
for FMRNC in $FM_AVERAGE_RNC_LIST; do
   if [ "$RNC" = "$FMRNC" ]; then
       
        SIM=`ls /netsim/netsimdir | grep ${RNC} | grep -v zip`
        echo ".open $SIM"
        echo ".select ${RNC}"
        echo "stopburst:id=all;"
        echo ".select network"
        echo "stopburst:id=all;"
   fi
done
done

for LTE in $LIST; do
for FMLTE in $FM_AVERAGE_LTE_LIST; do
   if [ "$LTE" = "$FMLTE" ]; then

        SIM=`ls /netsim/netsimdir | grep ${LTE} | grep -v zip`
        echo ".open $SIM"
        echo ".select network"
        echo "stopburst:id=all;"
   fi
done
done
