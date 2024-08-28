#!/bin/sh

SIM=ENTER_SIM_NAME
echo ".open $SIM"
cat BSCNodes2.txt | while read line
do
echo ".selectnocallback $line"
echo "SENDALARM:NUMBER=101,PRCA=40,CLS=1,CAT=11,INFO1=\"BUSINESS GROUP ATTENDANT TERMINAL FAULT\";"
sleep 10
done
