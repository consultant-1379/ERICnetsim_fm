#!/bin/sh



Total_alarms=800
NODE_TYPE=$1
VERSION=$2
TIME_INTERVAL_BETWEEN_ALARMS=0
OVERALL_RATE=0.375

SIM=`echo ".show simulations" | /netsim/inst/netsim_pipe | grep $NODE_TYPE | grep -i $VERSION | grep -v zip `
num_NEs=`echo -e ".open $SIM\n.show simnes" | /netsim/inst/netsim_pipe | grep -i public |  wc -l`

NUM_ALARMS=$(( ${Total_alarms} / $num_NEs )) 
NUM_ALARMS=1

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
showbursts;
EOF
;;

 "SAPC" )

cat <<EOF

.open $SIM
.select network
showbursts;
EOF
;; 

 "HSS" )

cat <<EOF

.open $SIM
.select network
showbursts;

EOF
;;
"SASN" )


cat <<EOF

.open $SIM
.select network
showbursts;
EOF

;;
"SGSNM" )

NODE_LIST=`echo -e ".open $SIM\n.show simnes" | /netsim/inst/netsim_pipe | grep -i public | awk ' {print $1 }'`
NODE_LIST=`echo ${NODE_LIST}`


cat <<EOF

.open $SIM
.select $NODE_LIST
showbursts;
EOF

;;

"GSN" )


NODE_LIST=`echo -e ".open $SIM\n.show simnes" | /netsim/inst/netsim_pipe | grep -i public | awk ' {print $1 }'`
NODE_LIST=`echo ${NODE_LIST}`



cat <<EOF

.open $SIM
.select $NODE_LIST
showbursts;
EOF

;;
"SIU" )


cat <<EOF

.open $SIM
.select network
showbursts;
EOF

;;

 "*" )
	echo "Node Type is not supported"
;;

esac

