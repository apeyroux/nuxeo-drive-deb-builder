from ubuntu:xenial

env DRIVE_VERSION=2.5.4
env SRC_DRIVE=/src/ndrive-$DRIVE_VERSION

run apt update -qq
run apt install -y \
    build-essential \
    debhelper \
    devscripts \
    equivs \
    git \
    software-properties-common 

# up latest dh-virtualenv
run echo "deb http://ftp.debian.org/debian jessie-backports main" \
    | tee /etc/apt/sources.list.d/jessie-backports.list >/dev/null
run apt-get update -qq
run apt-get install -y --allow-unauthenticated -t jessie-backports dh-virtualenv

# clone src
run mkdir /src
run git clone https://github.com/nuxeo/nuxeo-drive.git -b release-$DRIVE_VERSION $SRC_DRIVE

workdir $SRC_DRIVE

# fix dh-virtualenv with --requirements requirements-unix.txt
# run cat requirements-unix.txt >> requirements.txt

# copy debian package config
copy ./debian $SRC_DRIVE/debian

# create changelog
run dch --create --distribution unstable --package "ndrive" --newversion $DRIVE_VERSION "nuxeo-drive build with docker"

# install build dependencies
run mk-build-deps -ri --tool "apt-get --allow-downgrades --yes"

# patch shebang, use python venv
run sed -i 's/^#\!\/usr\/bin\/env python/#\!\/opt\/venvs\/ndrive\/bin\/python/g' ./nuxeo-drive-client/scripts/*

# make package and push .deb in debian/dist dir
cmd dpkg-buildpackage -us -uc -b --changes-option=-udebian/dist/