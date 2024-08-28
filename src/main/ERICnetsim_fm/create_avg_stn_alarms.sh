#!/bin/sh

SIM="ENTER_SIM_NAME"
rm -f /netsim/netsimdir/abc.mml
MMLSCRIPT="abc.mml"
echo ".open $SIM" > $MMLSCRIPT
cat /netsim/netsimdir/activities/STNNodes.txt | while read line
do
echo ".selectnocallback $line" >> $MMLSCRIPT
echo "sendalarm;" >> $MMLSCRIPT
echo ".sleep 1" >> $MMLSCRIPT
done

rm -f /netsim/netsimdir/ush.txt
/netsim/inst/netsim_shell < $MMLSCRIPT | grep ALARMID > /netsim/netsimdir/ush.txt
