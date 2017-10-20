#!/bin/bash
#
# install.ils.sh
#
# Install ils using the tar distribution
#
# To be run as root

set -e

# Environmental variables set by puppet.
SYSDIR="<%= @sysdir %>"
OPENSRF_USER="<%= @user %>"
OSNAME="<%= @make_osname %>"
REPOSITORY="<%= @repository %>"
STAFF_CLIENT_STAMP_ID="<%= @staff_client_stamp %>"
VERSION="<%= @version %>"

make_snakeoil_certificate() {
    local domain=$1
    local file_cert=$2
    local file_key=$3
    openssl req -subj "/CN=${domain}" \
                -new \
                -newkey rsa:4096 \
                -days 3650 \
                -nodes \
                -x509 \
                -keyout "$file_key" \
                -out "$file_cert"
}

installdir="${SYSDIR}/install/openils"
target="${installdir}/Evergreen-${VERSION}"
if [ -d "$target" ]
then
    echo "OpenSRF is already installed. To reinstall, remove the directory manually: rm -rf ${target}"
    exit 0
fi

tar="${VERSION}.tar.gz"
mkdir -p "$installdir"
cd "$installdir"
wget --no-check-certificate -O "$tar" "${REPOSITORY}"
tar -xaf "$tar"
cd "$target"
autoreconf -i
make -f Open-ILS/src/extras/Makefile.install "${OSNAME}"
echo "/usr/local/lib/dbd" > /etc/ld.so.conf.d/eg.conf
ldconfig
make -f Open-ILS/src/extras/Makefile.install "${OSNAME}-developer"
cd "${target}/Open-ILS/web/js/ui/default/staff"
npm install

grunt all
cd "$target"
PATH=${SYSDIR}/bin:$PATH ./configure --prefix="$SYSDIR" --sysconfdir="${SYSDIR}/conf"
make
make STAFF_CLIENT_STAMP_ID="$STAFF_CLIENT_STAMP_ID" install
rsync -av --delete "${target}/Open-ILS/src/support-scripts" "${SYSDIR}/bin/"
v="dojo-release-1.3.3"
f="${v}.tar.gz"
wget -O "$f" "http://download.dojotoolkit.org/release-1.3.3/${f}"
tar -C "${SYSDIR}/var/web/js" -xzf "$f"
cp -r "${SYSDIR}/var/web/js/${v}/"* "${SYSDIR}/var/web/js/dojo/".
chown -R "$OPENSRF_USER":"$OPENSRF_USER" "$SYSDIR"

make_snakeoil_certificate "<%= @fqdn %>" "<%= @apache_ssl_crt %>" "<%= @apache_ssl_key %>"


echo "Installation is complete."

# Errors from here and on are ok...
set +e

rm "${SYSDIR}/var/web/xul/server"
ln -s "${SYSDIR}/var/web/xul/${STAFF_CLIENT_STAMP_ID}" "${SYSDIR}/var/web/xul/server"

cd "${target}/Open-ILS/xul/staff_client"
make rigrelease rebuild linux32-updates-client linux64-updates-client
make install

rm -f "${SYSDIR}/conf/"*.example

exit 0