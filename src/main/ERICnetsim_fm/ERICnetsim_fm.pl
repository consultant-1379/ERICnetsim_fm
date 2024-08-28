#!/usr/bin/perl
use ERICnetsim_fm;
$wran_16K=ERICnetsim_fm::new(10,30,5,2,200,1,4,.3,.3,.3);
$wran_20K=ERICnetsim_fm::new(12.5,30,5,2,200,1,4,.3,.3,.3);
$wran_30K=ERICnetsim_fm::new(20,30,5,4,200,1,8,.3,.3,.3);

printf "\nAlarms for WRAN 16K\n\n";

printf ("Average Alaram Per Day	:\t%7d\n",$wran_16K->NumOfAverageAlrmPerDay());
printf ("Peak Alaram Per Day	:\t%7d\n",$wran_16K->NumOfPeakAlrmPerDay());
printf ("Storm Alaram Per Day	:\t%7d\n",$wran_16K->NumOfStormAlrmPerDay());
printf ("Total Alaram Per Day	:\t%7d\n",$wran_16K->TotalNumOfAlrmPerDay());

# around 30% of total alarm flow shall be with SpecificProblem .NodeSynchTp_ConnectionLost.. These alarms shall follow these rules:
# Around 90% of those alarm should be short-lived, active less than 1 minute
#

printf ("NodeSynchTp_ConnectionLost     :\t%7d\n", $wran_16K->NumOf_NodeSynchTp_ConnectionLost_Alrm()->{'NumOfNodeSyncConnLostAlrm'});

printf ("NodeSynchTp_ConnectionLost short lived     :\t%7d\n",$wran_16K->NumOf_NodeSynchTp_ConnectionLost_Alrm()->{'NumOfNodeSyncConnLostShortLivedAlrm'});

#around 30% of total alarm flow shall be with SpecificProblem .AlmDevice_ExternalAlarm.. These alarm shall follow these rules:
#around 30% of those alarms should have ProblemText set to .High Temperature. and be short-lived, active less than 1 min   
#around 5% of those alarms should have ProblemText set to .Aircraft Light Faulty. and be active for more than 5 minutes  
#around 5% of those alarms should be long-lived and have ProblemText set to .Long Lived. and be active for more than 5 minutes.
#around 30% of those alarms should have ProblemText set to .Battery Fail. and be active less than 2 minutes
#around 30% of those alarms should have ProblemText set to .Air Conditioner Failure. can be active any length of time. 
#

printf ("Number of AlmDevice_ExternalAlarm     :\t%7d\n",$wran_16K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'NumOfAlmDevice_ExternalAlarm'});

printf ("Number of Alarm due to High_Temperature     :\t%7d\n",$wran_16K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_High_Temperature_Alrm'});

printf ("Number of Alarm due to Aircraft Light Faulty     :\t%7d\n",$wran_16K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_Aircraft_Light_Faulty_Alrm'});

printf ("Number of Alarm due to Long_Lived     :\t%7d\n",$wran_16K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_Long_Lived_Alrm'});

printf ("Number of Alarm due to Battery_Fail     :\t%7d\n",$wran_16K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_Battery_Fail_Alrm'});

printf ("Number of Alarm due to Air Conditioner Failure     :\t%7d\n",$wran_16K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_Air_Conditioner_Failure_Alrm'});

#around 30% of total alarm flow shall be with SpecificProblem .AuxPlugInUnit_PiuConnectionLost.. These alarm shall follow these rules:
#around 90% of those alarms should be short-lived
#
printf ("AuxPlugInUnit_PiuConnectionLost     :\t%7d\n",$wran_16K->Num_AuxPlugInUnit_PiuConnectionLost_Alrm()->{'NumOfAuxPlugInUnit_PiuConnectionLost'});

printf ("AuxPlugInUnit_PiuConnectionLost short lived     :\t%7d\n",$wran_16K->Num_AuxPlugInUnit_PiuConnectionLost_Alrm()->{'NumOfAuxPlugInUnit_PiuConnectionLostShortLived'});

printf ("\nAlarm for WRAN 20K\n\n");

printf ("Average Alaram Per Day   :\t%7d\n",$wran_20K->NumOfAverageAlrmPerDay());
printf ("Peak Alaram Per Day      :\t%7d\n",$wran_20K->NumOfPeakAlrmPerDay());
printf ("Storm Alaram Per Day     :\t%7d\n",$wran_20K->NumOfStormAlrmPerDay());
printf ("Total Alaram Per Day     :\t%7d\n",$wran_20K->TotalNumOfAlrmPerDay());

# around 30% of total alarm flow shall be with SpecificProblem .NodeSynchTp_ConnectionLost.. These alarms shall follow these rules:
# # Around 90% of those alarm should be short-lived, active less than 1 minute
# #
printf ("NodeSynchTp_ConnectionLost     :\t%7d\n", $wran_20K->NumOf_NodeSynchTp_ConnectionLost_Alrm()->{'NumOfNodeSyncConnLostAlrm'});

printf ("NodeSynchTp_ConnectionLost short lived     :\t%7d\n",$wran_20K->NumOf_NodeSynchTp_ConnectionLost_Alrm()->{'NumOfNodeSyncConnLostShortLivedAlrm'});

#round 30% of total alarm flow shall be with SpecificProblem .AlmDevice_ExternalAlarm.. These alarm shall follow these rules:
#around 30% of those alarms should have ProblemText set to .High Temperature. and be short-lived, active less than 1 min
##around 5% of those alarms should have ProblemText set to .Aircraft Light Faulty. and be active for more than 5 minutes
##around 5% of those alarms should be long-lived and have ProblemText set to .Long Lived. and be active for more than 5 minutes.
##around 30% of those alarms should have ProblemText set to .Battery Fail. and be active less than 2 minutes
##around 30% of those alarms should have ProblemText set to .Air Conditioner Failure. can be active any length of time.
##
printf ("Number of AlmDevice_ExternalAlarm     :\t%7d\n",$wran_20K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'NumOfAlmDevice_ExternalAlarm'});

printf ("Number of Alarm due to High_Temperature     :\t%7d\n",$wran_20K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_High_Temperature_Alrm'});

printf ("Number of Alarm due to Aircraft Light Faulty     :\t%7d\n",$wran_20K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_Aircraft_Light_Faulty_Alrm'});

printf ("Number of Alarm due to Long_Lived     :\t%7d\n",$wran_20K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_Long_Lived_Alrm'});

printf ("Number of Alarm due to Battery_Fail     :\t%7d\n",$wran_20K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_Battery_Fail_Alrm'});

printf ("Number of Alarm due to Air Conditioner Failure     :\t%7d\n",$wran_20K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_Air_Conditioner_Failure_Alrm'});

#around 30% of total alarm flow shall be with SpecificProblem .AuxPlugInUnit_PiuConnectionLost.. These alarm shall follow these rules:
#around 90% of those alarms should be short-lived
##
printf ("AuxPlugInUnit_PiuConnectionLost     :\t%7d\n",$wran_20K->Num_AuxPlugInUnit_PiuConnectionLost_Alrm()->{'NumOfAuxPlugInUnit_PiuConnectionLost'});

printf ("AuxPlugInUnit_PiuConnectionLost short lived     :\t%7d\n",$wran_20K->Num_AuxPlugInUnit_PiuConnectionLost_Alrm()->{'NumOfAuxPlugInUnit_PiuConnectionLostShortLived'});

printf ("\nAlarm for WRAN 30K\n\n");

printf ("Average Alaram Per Day   :\t%7d\n",$wran_30K->NumOfAverageAlrmPerDay());
printf ("Peak Alaram Per Day      :\t%7d\n",$wran_30K->NumOfPeakAlrmPerDay());;
printf ("Storm Alaram Per Day     :\t%7d\n",$wran_30K->NumOfStormAlrmPerDay());
printf ("Total Alaram Per Day     :\t%7d\n",$wran_30K->TotalNumOfAlrmPerDay());

# around 30% of total alarm flow shall be with SpecificProblem .NodeSynchTp_ConnectionLost.. These alarms shall follow these rules:
# Around 90% of those alarm should be short-lived, active less than 1 minute
# 
printf ("NodeSynchTp_ConnectionLost     :\t%7d\n", $wran_30K->NumOf_NodeSynchTp_ConnectionLost_Alrm()->{'NumOfNodeSyncConnLostAlrm'});

printf ("NodeSynchTp_ConnectionLost short lived     :\t%7d\n",$wran_30K->NumOf_NodeSynchTp_ConnectionLost_Alrm()->{'NumOfNodeSyncConnLostShortLivedAlrm'});

#around 30% of total alarm flow shall be with SpecificProblem .AlmDevice_ExternalAlarm.. These alarm shall follow these rules:
#around 30% of those alarms should have ProblemText set to .High Temperature. and be short-lived, active less than 1 min
##around 5% of those alarms should have ProblemText set to .Aircraft Light Faulty. and be active for more than 5 minutes
##around 5% of those alarms should be long-lived and have ProblemText set to .Long Lived. and be active for more than 5 minutes.
##around 30% of those alarms should have ProblemText set to .Battery Fail. and be active less than 2 minutes
##around 30% of those alarms should have ProblemText set to .Air Conditioner Failure. can be active any length of time.
#
printf ("Number of AlmDevice_ExternalAlarm     :\t%7d\n",$wran_30K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'NumOfAlmDevice_ExternalAlarm'});

printf ("Number of Alarm due to High_Temperature     :\t%7d\n",$wran_30K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_High_Temperature_Alrm'});

printf ("Number of Alarm due to Aircraft Light Faulty     :\t%7d\n",$wran_30K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_Aircraft_Light_Faulty_Alrm'});

printf ("Number of Alarm due to Long_Lived     :\t%7d\n",$wran_30K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_Long_Lived_Alrm'});

printf ("Number of Alarm due to Battery_Fail     :\t%7d\n",$wran_30K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_Battery_Fail_Alrm'});

printf ("Number of Alarm due to Air Conditioner Failure     :\t%7d\n",$wran_30K->NumOf_AlmDevice_ExternalAlarm_Alrm()->{'Num_Air_Conditioner_Failure_Alrm'});

#around 30% of total alarm flow shall be with SpecificProblem .AuxPlugInUnit_PiuConnectionLost.. These alarm shall follow these rules:
#around 90% of those alarms should be short-lived
#
printf ("AuxPlugInUnit_PiuConnectionLost     :\t%7d\n",$wran_30K->Num_AuxPlugInUnit_PiuConnectionLost_Alrm()->{'NumOfAuxPlugInUnit_PiuConnectionLost'});

printf ("AuxPlugInUnit_PiuConnectionLost short lived     :\t%7d\n",$wran_30K->Num_AuxPlugInUnit_PiuConnectionLost_Alrm()->{'NumOfAuxPlugInUnit_PiuConnectionLostShortLived'});

#10	30	5	2	200	1	4
#12.5	30	5	2	200	1	4
#20	30	5	4	200	1	8
