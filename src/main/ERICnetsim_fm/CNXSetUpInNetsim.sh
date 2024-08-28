#!/bin/sh

SIM="DOG_012_0_30K_SYS_G11B_400_2048_cell_Irathom_new"
DIR="CNX_MML"
echo ".open $SIM" 
cat CNXNodes.txt | while read line
do
echo ".selectnocallback $line"
echo ".stop"
echo ".set ulib /netsim/netsimdir/$SIM/user_cmds/$DIR"
echo ".set save"
echo ".start"
done

