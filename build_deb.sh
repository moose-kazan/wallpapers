#!/bin/sh

cd $(dirname $(readlink -f $0))

PKG_VER=$(git describe --tags --always --dirty --match "v*" | sed 's/^v//')
PKG_BUILD=1

for distr in focal jammy noble resolute; do
	echo "Building deb-package $PKG_VER-$distr$PKG_BUILD for $distr"
	echo "vadim-kalinnikov-wallpapers (${PKG_VER}-${distr}${PKG_BUILD}) ${distr}; urgency=medium

  * New upstream release

 -- Vadim Kalinnikov <moose@ylsoftware.com>  $(date --rfc-email)" > debian/changelog
	dpkg-buildpackage -rfakeroot --build=source
done
