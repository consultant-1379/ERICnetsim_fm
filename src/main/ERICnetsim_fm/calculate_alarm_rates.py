from __future__ import division
import sys
import ERICnetsim_fm


NUM_SECS_1_MIN=60
NUM_MINS_1_HOUR=60
NUM_HOURS_1_DAY=24

NUM_SECS_1_HOUR=60 * NUM_SECS_1_MIN
NUM_SECS_1_DAY=NUM_HOURS_1_DAY*NUM_SECS_1_HOUR

NUM_MINS_1_DAY=24*NUM_MINS_1_HOUR


FoundCurDeployment=0
count=0
for  i in ERICnetsim_fm.TERE_ALarmRates_List:
    if ( i.Active=="TRUE" ):
        CurDeployment=i
        FoundCurDeployment=1
        TERE_AlarmRateId=count
    else:
        count=count+1
    
if ( FoundCurDeployment==0):
    print "Cannot determine current Deployment. Please check configuration"
    sys.exit(0)
        




print ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].scope

#Step 1
TotalNumAlm1Day=ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].AvgAlmRate\
        *NUM_SECS_1_DAY

#Step 2
TotalPkAlm1Day=ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].PkAlmRate\
        *ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].PkDur\
        *NUM_SECS_1_MIN\
        *ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].PkFrqHour\
        *NUM_HOURS_1_DAY

#Step 3
TotalStrmAlm1Day=ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].StrmAlmRate\
        *ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].StrmDur\
        *NUM_SECS_1_MIN\
        *ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].StrmFrqDay

print TotalNumAlm1Day
print TotalPkAlm1Day
print TotalStrmAlm1Day

#Step 4
TotalBackGroundAlm1Day = TotalNumAlm1Day - ( TotalPkAlm1Day + TotalStrmAlm1Day)

print TotalBackGroundAlm1Day

#Step 5
#BackgroundAlarm duration in mins. This is the number of mins the background rate runs during the day. 
#The background rate is running when peaks and storms are not running
BackGroundAlmDur=((NUM_MINS_1_DAY)-(\
        (ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].PkDur\
        *ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].PkFrqHour\
        *NUM_HOURS_1_DAY)\
        +(ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].StrmDur\
        *ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].StrmFrqDay)\
        ))

print ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].StrmDur
print ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].StrmFrqDay
#Step 5.4
#Total Background alarms in 1 minute
TotalBackGroundAlm1Min = int(TotalBackGroundAlm1Day / BackGroundAlmDur)

#Step 6
#If background rate is running all the time in the background then it is running every minute all day (including during peaks and storms)!!!
#So now recalculate the total alarms sent by background rate in 1 day with this new value!!!
TotalBackGroundAlm1Day = TotalBackGroundAlm1Min * NUM_MINS_1_DAY

print TotalBackGroundAlm1Day

#Step 6.1
BackGroundAlmRate = TotalBackGroundAlm1Day / NUM_SECS_1_DAY

#Step 7
BackGroundAlmRatePerNode=float(BackGroundAlmRate/ERICnetsim_fm.FM_LTE_Continuous_Rate_Num_Nodes)

#Step 8
#As there is a constant rate running in the background during the peak, the actual peak alarm rate is ===> ACTUAL PEAK ALARM RATE = TERE PEAK ALARM RATE - BACKGROUND ALARM RATE  
PkAlmRate=float(ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].PkAlmRate - BackGroundAlmRate)

#Step 11
#As there is a constant rate running in the background during the Storm, the actual Storm alarm rate is ===> ACTUAL STORM ALARM RATE = TERE STORM ALARM RATE - BACKGROUND ALARM RATE
StrmAlmRate=float(ERICnetsim_fm.TERE_ALarmRates_List[TERE_AlarmRateId].StrmAlmRate - BackGroundAlmRate)


PkAlmRatePerNode=float(PkAlmRate/ERICnetsim_fm.FM_Peak_Num_Nodes)
StrmAlmRatePerNode=float(StrmAlmRate/ERICnetsim_fm.FM_Storm_Num_Nodes)


print "BackGroundAlmRate"
print BackGroundAlmRate


print "PkAlmRate"
print PkAlmRate

print "StrmAlmRate"
print StrmAlmRate

print "BackGroundAlmRatePerNode"
print BackGroundAlmRatePerNode


print "PkAlmRatePerNode"
print PkAlmRatePerNode

print "StrmAlmRate"
print StrmAlmRatePerNode

