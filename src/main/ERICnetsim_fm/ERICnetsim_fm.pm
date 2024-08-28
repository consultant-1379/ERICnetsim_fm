#!/usr/bin/perl
package ERICnetsim_fm;
sub new {
	my ($average_alarm, $peak_volume, $peak_duration, $peak_frequency_per_hour, $storm_volume, $storm_duration, $storm_frequency_per_day, $PercentageNodeSynchConnLost, $PercentageAlmDeviceExternalAlarm, $PercentageAuxPlugInUnitPiuConnectionLost)= @_;
	my $NumOfSecIn1Min = 60;
	my $NumOfMinIn1Hour = 60;
	my $NumOfHourIn1Day = 24;
	my $NumOfSecIn1Hour = $NumOfSecIn1Min * $NumOfMinIn1Hour;
	my $NumOfSecIn1Day = $NumOfSecIn1Hour * $NumOfHourIn1Day;
	my $Average_Alarm_Duration = $NumOfSecIn1Day - ($peak_duration*$NumOfSecIn1Min*$peak_frequency_per_hour*$NumOfHourIn1Day + $storm_duration*$NumOfSecIn1Min*$storm_frequency_per_day);
	my $TereInfo = {
		"average_alarm"					=> $average_alarm,
		"Average_Alarm_Duration"			=> $Average_Alarm_Duration,
		"peak_volume"					=> $peak_volume,
		"peak_duration"					=> $peak_duration,
		"peak_frequency_per_hour"			=> $peak_frequency_per_hour,
		"storm_volume"					=> $storm_volume,
		"storm_duration"				=> $storm_duration,
		"storm_frequency_per_day"			=> $storm_frequency_per_day,
		"NumOfSecIn1Min"				=> $NumOfSecIn1Min,
		"NumOfMinIn1Hour"				=> $$NumOfMinIn1Hour,
		"NumOfHourIn1Day"				=> $NumOfHourIn1Day,
		"NumOfSecIn1Hour"				=> $NumOfSecIn1Hour,
		"NumOfSecIn1Day"				=> $NumOfSecIn1Day,
		"PercentageNodeSynchConnLost"			=> $PercentageNodeSynchConnLost,
		"PercentageAlmDeviceExternalAlarm"		=> $PercentageAlmDeviceExternalAlarm,
		"PercentageAuxPlugInUnitPiuConnectionLost"	=> $PercentageAuxPlugInUnitPiuConnectionLost
	};
bless $TereInfo, 'ERICnetsim_fm';
return $TereInfo;
}
sub NumOfAverageAlrmPerDay{
		my ($avgalr) = shift;
		return $avgalr->{'average_alarm'}*$avgalr->{'Average_Alarm_Duration'};
}

sub NumOfPeakAlrmPerDay{
		my $peakalr = shift;
		return $peakalr->{'peak_volume'}*$peakalr->{'peak_duration'}*$peakalr->{'peak_frequency_per_hour'}*$peakalr->{'NumOfSecIn1Min'}*$peakalr->{'NumOfHourIn1Day'};
}

sub NumOfStormAlrmPerDay{
		my $stormalr = shift;
		return $stormalr->{'storm_volume'}*$stormalr->{'storm_duration'}*$stormalr->{'NumOfSecIn1Min'}*$stormalr->{'storm_frequency_per_day'};
}

sub TotalNumOfAlrmPerDay{
		my $totalalr = shift;
		return $totalalr->NumOfAverageAlrmPerDay()+$totalalr->NumOfPeakAlrmPerDay()+$totalalr->NumOfStormAlrmPerDay();
}

sub NumOf_NodeSynchTp_ConnectionLost_Alrm{
        my $NodeSynchTpConnLost = shift;
        $NumOfNodeSyncConnLostAlrm =  $NodeSynchTpConnLost->{'PercentageNodeSynchConnLost'}*$NodeSynchTpConnLost->TotalNumOfAlrmPerDay();
        $NumOfNodeSyncConnLostShortLivedAlrm = .9*$NumOfNodeSyncConnLostAlrm;
	my $Value_NodeSyncConnLost = {
		"NumOfNodeSyncConnLostAlrm"		=> $NumOfNodeSyncConnLostAlrm,
		"NumOfNodeSyncConnLostShortLivedAlrm"	=> $NumOfNodeSyncConnLostShortLivedAlrm
	};
return $Value_NodeSyncConnLost;
}
sub NumOf_AlmDevice_ExternalAlarm_Alrm{
        my $ExternalAlarm = shift;
        $NumOfAlmDevice_ExternalAlarm = .3*$ExternalAlarm->TotalNumOfAlrmPerDay();
        $Num_High_Temperature_Alrm = .3*$NumOfAlmDevice_ExternalAlarm;
        $Num_Aircraft_Light_Faulty_Alrm = .05*$NumOfAlmDevice_ExternalAlarm;
        $Num_Long_Lived_Alrm = .05*$NumOfAlmDevice_ExternalAlarm;
        $Num_Battery_Fail_Alrm = .3*$NumOfAlmDevice_ExternalAlarm;
        $Num_Air_Conditioner_Failure_Alrm = .3*$NumOfAlmDevice_ExternalAlarm;
	my $Value_ExternalAlarm = {
		"NumOfAlmDevice_ExternalAlarm"		=> $NumOfAlmDevice_ExternalAlarm,
		"Num_High_Temperature_Alrm"		=> $Num_High_Temperature_Alrm,
		"Num_Aircraft_Light_Faulty_Alrm"	=> $Num_Aircraft_Light_Faulty_Alrm,
		"Num_Long_Lived_Alrm"			=> $Num_Long_Lived_Alrm,
		"Num_Battery_Fail_Alrm"			=> $Num_Battery_Fail_Alrm,
		"Num_Air_Conditioner_Failure_Alrm"	=> $Num_Air_Conditioner_Failure_Alrm
	};
return $Value_ExternalAlarm;
}
sub Num_AuxPlugInUnit_PiuConnectionLost_Alrm{
        my $AuxPlugInUnit = shift;
        $NumOfAuxPlugInUnit_PiuConnectionLost = .3*$AuxPlugInUnit->TotalNumOfAlrmPerDay();
        $NumOfAuxPlugInUnit_PiuConnectionLostShortLived = .9*$NumOfAuxPlugInUnit_PiuConnectionLost;
	my $Value_AuxPlugInUnit = {
	"NumOfAuxPlugInUnit_PiuConnectionLost"		=> $NumOfAuxPlugInUnit_PiuConnectionLost,
	"NumOfAuxPlugInUnit_PiuConnectionLostShortLived"=> $NumOfAuxPlugInUnit_PiuConnectionLostShortLived
	};
return $Value_AuxPlugInUnit;
}
1;
