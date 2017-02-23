#!/bin/bash
set -e
source /pd_build/buildconfig

header "Installing Nginx..."

export CONFIGURE_OPTS=--disable-audit
cd /tmp

run minimal_apt_get_install gdebi-core
run apt-get build-dep -y --no-install-recommends nginx-extras
run apt-get source -y -b nginx-extras
run gdebi -n nginx-common_*.deb
run gdebi -n nginx-extras_*.deb
run rm -rf *.deb *.gz *.dsc *.changes nginx-*

# Unfortunately there is no way to automatically remove build deps, so we do this manually.
run apt-get remove -y gdebi-core python3-chardet python3-debian python3-pkg-resources python3-six autoconf automake autopoint bsdmainutils debhelper dh-autoreconf dh-strip-nondeterminism dh-systemd geoip-bin gettext gettext-base groff-base intltool-debian libarchive-zip-perl libasprintf0c2 libcroco3 libexpat1-dev libfile-stripnondeterminism-perl libfontconfig1-dev libfreetype6-dev libgd-dev libgeoip-dev libice-dev libice6 libjbig-dev libjpeg-dev libjpeg62-turbo-dev libluajit-5.1-dev liblzma-dev libmhash-dev libmhash2 libpam0g-dev libpcre3-dev libpcrecpp0 libperl-dev libpipeline1 libpng12-dev libpthread-stubs0-dev libruby2.1 libsm-dev libsm6 libtiff5-dev libtiffxx5 libunistring0 libvpx-dev libx11-dev libxau-dev libxcb1-dev libxdmcp-dev libxpm-dev libxt-dev libxt6 man-db po-debconf rake ruby ruby-dev ruby2.1 ruby2.1-dev rubygems-integration x11-common x11proto-core-dev x11proto-input-dev x11proto-kb-dev xorg-sgml-doctools xtrans-dev