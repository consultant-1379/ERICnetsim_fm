#!/bin/sh



Total_alarms=800
NODE_TYPE=$1
VERSION=$2
TIME_INTERVAL_BETWEEN_ALARMS=0
OVERALL_RATE=2.2

SIM=`echo ".show simulations" | /netsim/inst/netsim_pipe | grep $NODE_TYPE | grep -i $VERSION | grep -v zip `
num_NEs=`echo -e ".open $SIM\n.show simnes" | /netsim/inst/netsim_pipe | grep -i public |  wc -l`

#NUM_ALARMS=$(( ${Total_alarms} / $num_NEs )) 

#$FREQUENCY_PER_SECOND_PER_NODE=`echo "scale=10; $OVERALL_RATE / $num_NEs" | bc -l`
echo num_NEs $num_NEs


case "$NODE_TYPE" in

 "GGSN-MPG" )

cat <<EOF

.open $SIM
.select network
stopburst:id=all;
ceasealarm:id=all;
EOF
;;

 "SAPC" )

cat <<EOF

.open $SIM
.select network
stopburst:id=all; 
ceasealarm:id=all;
EOF
;; 

 "HSS" )

cat <<EOF

.open $SIM
.select network
stopburst:id=all; 
ceasealarm:id=all;
EOF
;;
"SASN" )


cat <<EOF

.open $SIM
.select network
stopburst:id=all; 
ceasealarm:id=all;
EOF

;;
"SGSNM" )

NODE_LIST=`echo -e ".open $SIM\n.show simnes" | /netsim/inst/netsim_pipe | grep -i public | awk ' {print $1 }'`
NODE_LIST=`echo ${NODE_LIST}`


cat <<EOF

.open $SIM
.select $NODE_LIST
stopburst:id=all; 
ceasealarm:all;
EOF

;;

"GSN" )


NODE_LIST=`echo -e ".open $SIM\n.show simnes" | /netsim/inst/netsim_pipe | grep -i public | awk ' {print $1 }'`
NODE_LIST=`echo ${NODE_LIST}`



cat <<EOF

.open $SIM
.select $NODE_LIST
stopburst:id=all; 
ceasealarm:id=all;
EOF

;;
"SIU" )


cat <<EOF

.open $SIM
.select network
stopburst:id=all; 
ceasealarm:id=all;
EOF

;;

 "*" )
	echo "Node Type is not supported"
;;

esac

