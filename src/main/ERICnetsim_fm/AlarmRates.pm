package AlarmRates;

sub new {

    my ($class) = @_;
    my $self = {
        	DepType => undef,
                scope => undef,
   		AvgAlmRate => undef,
           	PkAlmRate => undef,
   		PkDur => undef,
   		PkFrqHour => undef,
   		StrmRate => undef,
   		StrmDur => undef,
   		StrmFrqDay => undef,
   		Active => undef
                 };
     bless $self, $class;
     return $self;
}

sub init {
    my ( $self,$DeploymentType,$Scope,$AverageAlarmRate,$PeakAlarmRate,$PeakDuration,$PeakFrequencyPerHour,$StormRate,$StormDuration,$StormFrequencyPerDay,$Active) = @_;
        $self->{DepType} = $DeploymentType;
	$self->{scope} = $Scope;
	$self->{AvgAlmRate} = $AverageAlarmRate;
	$self->{PkAlmRate} = $PeakAlarmRate;
	$self->{PkDur} = $PeakDuration;
	$self->{PkFrqHour} = $PeakFrequencyPerHour;
	$self->{StrmRate} = $StormRate;
	$self->{StrmDur} = $StormDuration;
	$self->{StrmFrqDay} = $StormFrequencyPerDay;
	$self->{Active} = $Active;

 return $self;
}

sub DepType {
    my ( $self, $deptype ) = @_;
    $self->{DepType} = $deptype if defined ($deptype);
    return $self->{DepType};
}

sub scope {
    my ( $self, $scop ) = @_;
    $self->{scope} = $scop if defined ($scop);
    return $self->{scope};
}
sub AvgAlmRate {
    my ( $self, $avgalmrt ) = @_;
    $self->{AvgAlmRate} = $avgalmrt if defined ($avgalmrt);
    return $self->{AvgAlmRate};
}
sub PkAlmRate {
    my ( $self, $pkalmr ) = @_;
    $self->{PkAlmRate} = $pkalmr if defined ($pkalmr);
    return $self->{PkAlmRate};
}
sub PkDur {
    my ( $self, $pd ) = @_;
    $self->{PkDur} = $pd if defined ($pd);
    return $self->{PkDur};
}
sub PkFrqHour {
    my ( $self, $pfh ) = @_;
    $self->{PkFrqHour} = $pfh if defined ($pfh);
    return $self->{PkFrqHour};
}
sub StrmRate {
    my ( $self, $sr ) = @_;
    $self->{StrmRate} = $sr if defined ($sr);
    return $self->{StrmRate};
}
sub StrmDur {
    my ( $self, $sd ) = @_;
    $self->{StrmDur} = $sd if defined ($sd);
    return $self->{StrmDur};
}

sub StrmFrqDay {
    my ( $self, $sfd ) = @_;
    $self->{StrmFrqDay} = $sfd if defined ($sfd);
    return $self->{StrmFrqDay};
}
sub Active {
    my ( $self, $act ) = @_;
    $self->{Active} = $act if defined ($act);
    return $self->{Active};
}

sub print {
    my ($self) = @_;
        print "$self->{DepType}\n";
        print "$self->{scope}\n";
        print "$self->{AvgAlmRate}\n";
        print "$self->{PkAlmRate}\n";
        print "$self->{PkDur}\n";
	print "$self->{PkFrqHour}\n";
	print "$self->{StrmRate}\n";
	print "$self->{StrmDur}\n";
	print "$self->{StrmFrqDay}\n";
	print "$self->{Active}\n";
        }
        1;
    
