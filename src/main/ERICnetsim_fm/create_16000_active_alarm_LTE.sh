#!/bin/sh

#### 1. NETSIM #############

SIMLIST=`echo ".show simulations" | /netsim/inst/netsim_pipe | grep LTE | grep -v zip`
GROUP_LIST=`echo ${SIMLIST} | awk 'BEGIN {RS=" " } { print $0}' | sed 's/.*-LTE/LTE/g' `


### total of 20 nodes per LTE GROUP. Each node will send NUM_ALARMS
NUM_ALARMS=100

for LTE_GROUP_NAME in $GROUP_LIST; 
do

ERBS_NODE_LIST=""$LTE_GROUP_NAME"ERBS00140 "$LTE_GROUP_NAME"ERBS00141 "$LTE_GROUP_NAME"ERBS00142 "$LTE_GROUP_NAME"ERBS00143 "$LTE_GROUP_NAME"ERBS00144 "$LTE_GROUP_NAME"ERBS00145 "$LTE_GROUP_NAME"ERBS00146 "$LTE_GROUP_NAME"ERBS00147 "$LTE_GROUP_NAME"ERBS00148 "$LTE_GROUP_NAME"ERBS00149 "$LTE_GROUP_NAME"ERBS00150 "$LTE_GROUP_NAME"ERBS00151 "$LTE_GROUP_NAME"ERBS00152 "$LTE_GROUP_NAME"ERBS00153 "$LTE_GROUP_NAME"ERBS00154 "$LTE_GROUP_NAME"ERBS00155 "$LTE_GROUP_NAME"ERBS00156 "$LTE_GROUP_NAME"ERBS00157 "$LTE_GROUP_NAME"ERBS00158 "$LTE_GROUP_NAME"ERBS00159 "

SIM=`echo ".show simulations" | /netsim/inst/netsim_pipe | grep ${LTE_GROUP_NAME} | grep -v zip`

cat <<EOF

.open $SIM
.select ${ERBS_NODE_LIST}
alarmburst:freq=2.0,num_alarms=$NUM_ALARMS,loop=false,idle_time=0,mo_class="no_value",mo_instance="%mibprefix,ManagedElement=1,Equipment=1,Subrack=MS,Slot=%unique{1000}", system_dn="%mibprefix", cause=1, severity=3, problem="AlmDevice_ExternalAlarm",text="Aircraft Light Facility",type = ET_COMMUNICATIONS_ALARM, cease_after=100,clear_after_burst=true,id=100;
EOF

sleep 10
done
