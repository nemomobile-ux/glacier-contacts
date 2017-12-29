Name:       glacier-contacts

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}

Summary:    Contacts application for nemo
Version:    0.6.0
Release:    1
Group:      Applications/System
License:    GPLv2
URL:        https://github.com/nemomobile-ux/glacier-contacts
Source0:    %{name}-%{version}.tar.bz2

Requires:   qt-components-qt5
Requires:   qt5-qtquickcontrols
Requires:   qt5-qtquickcontrols-nemo

Requires:   nemo-qml-plugin-thumbnailer-qt5
Requires:   nemo-qml-plugin-contacts-qt5
Requires:   nemo-qml-plugin-folderlistmodel
Requires:   glacier-gallery
Requires:   glacier-filemuncher
Requires:   contactsd
Requires:   nemo-qml-plugin-dbus-qt5
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Contacts)
BuildRequires:  pkgconfig(qdeclarative5-boostable)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  desktop-file-utils
Provides:   meego-handset-people > 0.2.32
Provides:   meego-handset-people-branding-upstream > 0.2.32
Obsoletes:   meego-handset-people <= 0.2.32
Obsoletes:   meego-handset-people-branding-upstream <= 0.2.32

%description
Contacts application using Qt Quick for Nemo Mobile.

%prep
%setup -q -n %{name}-%{version}

%build
%qtc_qmake5
%qtc_make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install


desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/glacier-contacts
%{_datadir}/applications/glacier-contacts.desktop
%{_datadir}/glacier-contacts
%{_libdir}/qt5/qml/org/nemomobile/qmlcontacts/*
