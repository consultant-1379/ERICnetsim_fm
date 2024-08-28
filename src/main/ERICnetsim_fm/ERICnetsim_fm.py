#!/usr/bin/env python

GRAN_DEPLOYMENT_NAME="COREWIRELINE"
LTE_DEPLOYMENT_NAME="LTE"
WRAN_DEPLOYMENT_NAME="WRAN"
BSS_DEPLOYMENT_NAME="BSS"


# Classes are taken from the TERE section called: "General Alarm rates"
class AlarmRates:
    def __init__(self,DeploymentType,Scope,AverageAlarmRate,PeakAlarmRate,PeakDuration,PeakFrequencyPerHour,StormRate,StormDuration,StormFrequencyPerDay,Active ):         
        self.DepType=DeploymentType 
        self.scope = Scope 
        self.AvgAlmRate = AverageAlarmRate 
        self.PkAlmRate = PeakAlarmRate 
        self.PkDur = PeakDuration 
        self.PkFrqHour = PeakFrequencyPerHour 
        self.StrmAlmRate = StormRate 
        self.StrmDur = StormDuration 
        self.StrmFrqDay = StormFrequencyPerDay 
        self.Active = Active 

class FMXAlarmConfig:

    def __init__(self,DeploymentType,SpecificProblem,SpecificProblemPercent,ProblemText,ActiveDuration,ActivePercent):
        self.DepType=DeploymentType
        self.SP = SpecificProblem
        self.SPPercent = SpecificProblemPercent
        self.ProbText = ProblemText
        self.ActiveDur = ActiveDuration
        self.ActivePercent = ActivePercent


#According to the TERE the following rules apply when selecting how many nodes are used to apply network load
#Any peak and storm alarm rates shall come from 20 network elements.
#In the WRAN case the continous alarm rate shall be spread out on at least 1000 nodes. 
#In the CORE case the continuous alarm rate shall be spread out on at least 200 nodes (100 AXE nodes and 100 SNMP nodes).
#In the BSS case the continous alarm rate shall be spread out on at least 1040 nodes (40 BSC and 1000 BTSs).
#In the LTE case the continuous alarm rate shall be spreadout on at least 150 eRBS nodes.
FM_WRAN_Continuous_Rate_Num_Nodes=1000
FM_CORE_Continuous_Rate_Num_Nodes=200
FM_BSS_Continuous_Rate_Num_Nodes=1040
FM_LTE_Continuous_Rate_Num_Nodes=240

FM_Peak_Num_Nodes=20
FM_Storm_Num_Nodes=20

#################################
# Below are the alarm rates for Constant LOAD for GRAN/WRAN/LTE nodes
# Each object refers to a single line in the TERE section "General Alarm Rates"
################################
TERE_ALarmRates_List=[]
TERE_ALarmRates_List.append(AlarmRates(DeploymentType="BSS",Scope="15K",AverageAlarmRate=7,PeakAlarmRate=30,PeakDuration=5,PeakFrequencyPerHour=2,StormRate=0,StormDuration=0,StormFrequencyPerDay=0,Active="FALSE"))
TERE_ALarmRates_List.append( AlarmRates("BSS","20K",10,30,5,2,0,0,0,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("BSS","30K",14,30,5,2,0,0,0,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("COREWIRELINE","15K",3,30,5,2,0,0,0,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("COREWIRELINE","16K",3,30,5,2,0,0,0,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("COREWIRELINE","20K",4,30,5,2,0,0,0,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("COREWIRELINE","30K",6,30,5,2,0,0,0,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("WRAN","7.5K",5,30,5,1,200,1,2,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("WRAN","15K",10,30,5,2,200,1,4,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("WRAN","16K",10,30,5,2,200,1,4,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("WRAN","20K",12.5,30,5,2,200,1,4,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("WRAN","30K",20,30,5,4,200,1,8,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("WRAN","40K",25,40,5,4,250,1,8,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("WRAN","50K",30,50,5,4,300,1,8,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("LTE","7.5K",5,30,5,1,200,1,2,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("LTE","15K",10,30,5,2,200,1,4,"FALSE"))
#For 16K alarm rate LTE nodes supply 10 alarms per second and assuming 4000 siu nodes 
# EPC nodes supply 3 alarms/sec and SIU supply 2.2 alarms/sec
TERE_ALarmRates_List.append( AlarmRates("LTE","16K",10,30,5,2,200,1,4,"FALSE"))
TERE_ALarmRates_List.append( AlarmRates("LTE","20K",12.5,30,5,2,200,1,4,"FALSE"))
#According to FM systems the LTE rate across LTE 30K deployment is actually 17.4 alarms per second
#In a deployment which has EPC nodes and SIU nodes where EPC rate is 3 alarms/sec and EPC rate is 4.4 alarms/sec.
TERE_ALarmRates_List.append( AlarmRates("LTE","30K",17.4,30,5,4,200,4,8,"TRUE"))




LTE16K_FMX_CONFIG_1= FMXAlarmConfig("LTE","NssSynchronization_SystemClockStatusChange",0.2,"Faulty Facility",2,1)
print LTE16K_FMX_CONFIG_1.SP

print TERE_ALarmRates_List[0].DepType


