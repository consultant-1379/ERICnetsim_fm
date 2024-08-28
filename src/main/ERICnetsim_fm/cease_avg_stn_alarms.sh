#!/bin/sh

SIM="DOG_012_2_30K_SYS_G12A_G12B_400_2048_cell_Irathom"
rm -f /netsim/netsimdir/xyx.mml
rm -f /netsim/netsimdir/id.txt
MMLSCRIPT="xyx.mml"
echo ".open $SIM" > $MMLSCRIPT
VAR=1
cat /netsim/netsimdir/activities/STNNodes.txt | while read line
do
echo ".selectnocallback $line" >> $MMLSCRIPT
echo "ceasealarm:all;" >> $MMLSCRIPT
VAR=`expr $VAR + 1`
echo ".sleep 1" >> $MMLSCRIPT
done

rm -f /netsim/netsimdir/ush.txt
/netsim/inst/netsim_shell < $MMLSCRIPT | grep ALARMID > /netsim/netsimdir/ush.txt
