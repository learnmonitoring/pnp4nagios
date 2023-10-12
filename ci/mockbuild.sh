#!/usr/bin/bash

NAME=pnp4nagios
VERSION=$1

dnf install -y epel-release
dnf install -y mock

tar -xf ${NAME}-${VERSION}.tgz ${NAME}-${VERSION}/dist/${NAME}.spec
mv ${NAME}-${VERSION}/dist/${NAME}.spec ./${NAME}.spec.base


RELEASE=$(grep '^Release: ' ${NAME}.spec | cut -d ':' -f2 | awk -F'%' '{print $1}' | tr -d ' ')

mkdir outputs


BREL="${RELEASE}.alma"
sed '/^Release: /s/$RELEASE/$BREL/' <${NAME}.spec.base >${NAME}.spec
config='almalinux-8-x86_64'
mock -r $config  \
     --spec=${NAME}.spec \
     --sources=. --resultdir=./outputs 


# release 16.el8.alma
# srpm name-version-(release).src.rpm

exit 0
config='fedora-38-x86_64'
mock -r $config \
     --spec=${NAME}.spec \
     --sources=. --resultdir=./outputs
