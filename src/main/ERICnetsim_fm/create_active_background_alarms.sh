#!/bin/sh

SIM=DOG_012_2_30K_SYS_G12A_300_512_cell_GSM_GSM_IRA
echo ".open $SIM"
MAX_ALARM=342
cat BSCNodes.txt | while read line
do
echo ".selectnocallback $line"
VAR=2
while [ $VAR -le $MAX_ALARM ]
do
VAR=`expr $VAR + 1`
echo "SENDALARM:NUMBER=$VAR,PRCA=40,CLS=1,CAT=11,INFO1=\"BUSINESS GROUP ATTENDANT TERMINAL FAULT\";"
sleep 1
done
done
