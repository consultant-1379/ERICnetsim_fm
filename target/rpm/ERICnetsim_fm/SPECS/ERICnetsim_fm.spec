%define _unpackaged_files_terminate_build 0
Name: ERICnetsim_fm
Version: 13.0
Release: SNAPSHOT20120924150054
Summary: ERICnetsim_fm
License: 2012,ericsson
Distribution: netsim_fm
Group: Application/Collectors
Packager: eahedav
autoprov: yes
autoreq: yes
BuildRoot: /var/lib/jenkins/ERICnetsim_fm/target/rpm/ERICnetsim_fm/buildroot

%description

%install
if [ -e $RPM_BUILD_ROOT ];
then
  mv /var/lib/jenkins/ERICnetsim_fm/target/rpm/ERICnetsim_fm/tmp-buildroot/* $RPM_BUILD_ROOT
else
  mv /var/lib/jenkins/ERICnetsim_fm/target/rpm/ERICnetsim_fm/tmp-buildroot $RPM_BUILD_ROOT
fi

%files

%attr(755,netsim,netsim) /netsim/ERICnetsim_fm

%pre
echo "I am now install ERICnetsim_fm"
