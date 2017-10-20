#!/bin/bash
#
# install.opensrf.sh
#
# Install opensrf using the tar distribution
#
# To be run as root

set -e

# Environmental variables set by puppet.
SYSDIR="<%= @sysdir %>"
OPENSRF_USER="<%= @user %>"
OSNAME="<%= @make_osname %>"
REPOSITORY="<%= @repository %>"
VERSION="<%= @version %>"

installdir="${SYSDIR}/install/opensrf"
target="${installdir}/opensrf-${VERSION}"
if [ -d "$target" ]
then
    echo "OpenSRF is already installed. To reinstall, remove the directory manually: rm -rf ${target}"
    exit 0
fi


make_options="--enable-python --with-websockets-port=443"
mkdir -p "$installdir"
tar="${VERSION}.tar.gz"
cd "$installdir"
wget -O "$tar" "$REPOSITORY"
tar -xaf "$tar"
cd "$target"
make -f src/extras/Makefile.install "${OSNAME}"
autoreconf -i
PATH=${SYSDIR}/bin:$PATH ./configure --prefix="$SYSDIR" --sysconfdir="${SYSDIR}/conf" ${make_options}
make
make install
echo "${SYSDIR}/lib" > /etc/ld.so.conf.d/opensrf.conf
ldconfig
a2dissite 000-default
a2dismod mpm_event
a2enmod mpm_prefork
chown -R "$OPENSRF_USER":"$OPENSRF_USER" "$SYSDIR"

# Use a temporary directory
cd /tmp
rm -rf /tmp/apache-websocket
git clone https://github.com/disconnect/apache-websocket
cd apache-websocket
apxs2 -i -a -c mod_websocket.c
a2dismod websocket

echo "Installation is complete."


exit 0