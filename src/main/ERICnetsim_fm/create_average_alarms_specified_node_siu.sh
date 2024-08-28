#!/bin/sh



Total_alarms=800
NODE_TYPE=$1
VERSION=$2
TIME_INTERVAL_BETWEEN_ALARMS=0
OVERALL_RATE=2.2

SIM=`echo ".show simulations" | /netsim/inst/netsim_pipe | grep $NODE_TYPE | grep -i $VERSION | grep -v zip `
num_NEs=`echo -e ".open $SIM\n.show simnes" | /netsim/inst/netsim_pipe | grep -i public |  wc -l`

NUM_ALARMS=$(( ${Total_alarms} / $num_NEs )) 

FREQUENCY_PER_SECOND_PER_NODE=`echo "scale=10; $OVERALL_RATE / $num_NEs" | bc -l`
echo FREQUENCY_PER_SECOND_PER_NODE=$FREQUENCY_PER_SECOND_PER_NODE
echo OVERALL_RATE=$OVERALL_RATE
echo num_NEs $num_NEs

remainder=`echo "scale=0; $OVERALL_RATE / $num_NEs" | bc -l`
if [ $remainder -le 0 ] ; then

	FREQUENCY_PER_SECOND_PER_NODE=0$FREQUENCY_PER_SECOND_PER_NODE
fi


case "$NODE_TYPE" in

 "GGSN-MPG" )

cat <<EOF

.open $SIM
.select network
alarmburst:id=1329141415953521, num_alarms=$NUM_ALARMS,freq=$FREQUENCY_PER_SECOND_PER_NODE,idle_time=$TIME_INTERVAL_BETWEEN_ALARMS,cease_after=1, mo_class="J20 GGSN - %nename",mo_instance="gc-0/0/0", source_id="MASTER",severity=1, name="Hardware",text="NE on fire, smoke not yet detected.", loop=true, mode=persistent;
EOF
;;

 "SAPC" )

cat <<EOF

.open $SIM
.select network
alarmburst:id=1329141833873197, num_alarms=$NUM_ALARMS,freq=$FREQUENCY_PER_SECOND_PER_NODE,idle_time=$TIME_INTERVAL_BETWEEN_ALARMS,cease_after=1, moclass="%nename",moinstance="no_value",type=18, cause=125,severity=3,problem="no_value",text="Alarm from NETSim", loop=true, mode=persistent;
EOF
;; 

 "HSS" )

cat <<EOF

.open $SIM
.select network
alarmburst:id=1329141833873197, num_alarms=$NUM_ALARMS,freq=$FREQUENCY_PER_SECOND_PER_NODE,idle_time=$TIME_INTERVAL_BETWEEN_ALARMS,cease_after=1, moclass="%nename",moinstance="no_value",type=18, cause=125,severity=3,problem="no_value",text="Alarm from NETSim", loop=true, mode=persistent;

EOF
;;
"SASN" )


cat <<EOF

.open $SIM
.select network
alarmburst:id=1329147388463541, num_alarms=$NUM_ALARMS,frequency=$FREQUENCY_PER_SECOND_PER_NODE, idle_time=$TIME_INTERVAL_BETWEEN_ALARMS, event=101, type=2,cause=2, severity=3, text="no_value", loop=true, mode=persistent, cease_after=1;
EOF

;;
"SGSNM" )

NODE_LIST=`echo -e ".open $SIM\n.show simnes" | /netsim/inst/netsim_pipe | grep -i public | awk ' {print $1 }'`
NODE_LIST=`echo ${NODE_LIST}`


cat <<EOF

.open $SIM
.select $NODE_LIST
alarmburst:id=1318872889334168, num_alarms=$NUM_ALARMS,freq=$FREQUENCY_PER_SECOND_PER_NODE,idle_time=$TIME_INTERVAL_BETWEEN_ALARMS,cease_after=1, moclass="no_value",severity=3,type=0, cause=0,problem="no_value",text="NE on fire, smoke not yet detected.", loop=true, mode=persistent;
EOF

;;

"GSN" )


NODE_LIST=`echo -e ".open $SIM\n.show simnes" | /netsim/inst/netsim_pipe | grep -i public | awk ' {print $1 }'`
NODE_LIST=`echo ${NODE_LIST}`



cat <<EOF

.open $SIM
.select $NODE_LIST
alarmburst:id=1318872889334167, num_alarms=$NUM_ALARMS,freq=$FREQUENCY_PER_SECOND_PER_NODE,idle_time=$TIME_INTERVAL_BETWEEN_ALARMS,cease_after=1, moclass="no_value",severity=3,type=0, cause=0,problem="no_value",text="NE on fire, smoke not yet detected.", loop=true, mode=persistent;
EOF

;;
"SIU" )


cat <<EOF

.open $SIM
.select network
alarmburst:id=1325783869821767, num_alarms=$NUM_ALARMS,freq=$FREQUENCY_PER_SECOND_PER_NODE,idle_time=$TIME_INTERVAL_BETWEEN_ALARMS,cease_after=1, mo_class="Equipment",mo_instance="STN=0,Equipment=0", type=4,cause=315,severity=3, problem="no_value",text="no_value", loop=true, mode=persistent;
EOF

;;

 "*" )
	echo "Node Type is not supported"
;;

esac

