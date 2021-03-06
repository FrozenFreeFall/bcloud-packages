#!/bin/bash
# This shell script is used to build rpm for bcloud
# Released by wangjiezhe <wangjiezhe@gmail.com>

if [ $# -ne 2 ]
then
	echo "Usage: $(basename "$0") version release"
	exit 2
fi

version=${1//-/.}
release="$2"

if [ ! -d  "$HOME"/rpmbuild/SPECS ]
then
	if [ -n "$(which rpmdev-setuptree)" ]
	then
		rpmdev-setuptree
	else
		echo "The command \`rpmdev-setuptree\` doesn't in your path.'"
		echo "Please check you path or if your have installed package development tools."
		echo "If not, install the core development tools:"
		echo "yum install @development-tools"
		echo "yum install fedora-packager"
		exit 1
	fi
fi

# Replace these variables by your pathes
GIT="$HOME"/Downloads/github/wangjiezhe/bcloud
DEST="$HOME"/Downloads/github/wangjiezhe/bcloud-packages

SOURCES="$HOME"/rpmbuild/SOURCES
SPECS="$HOME"/rpmbuild/SPECS
RPMS="$HOME"/rpmbuild/RPMS/noarch
SRPMS="$HOME"/rpmbuild/SRPMS

if [ ! -f "$SPECS"/bcloud.spec ]
then
	if [ -f "$PWD"/bcloud.spec ]
	then
		cp "$PWD"/bcloud.spec "$SPECS"
	else
		echo "No spec file found!"
		exit 1
	fi
fi

mkdir -p "$SOURCES"/bcloud-"$version"
cd "$GIT"/
cp -vr HISTORY LICENSE README.md setup.py bcloud-gui bcloud po share "$SOURCES"/bcloud-"$version"
# rm -rf "$SOURCES"/bcloud-$version/bcloud/__pycache__/

cd "$SOURCES"/
tar -cvzf bcloud-"$version".tar.gz bcloud-"$version"
rm -rf bcloud-"$version"

cd "$SPECS"/
sed -i "/^Version/s/[0-9]\+\.[0-9]\+\.[0-9]\+/$version/" bcloud.spec
sed -i "/^Release/s/[0-9]\+/$release/" bcloud.spec
rpmbuild -ba bcloud.spec
cp bcloud.spec "$DEST"/build_rpm/
# cp makerpm-bcloud.sh "$DEST"/build_rpm/

cp "$RPMS"/bcloud-"$version"-"$release".fc20.noarch.rpm "$DEST"/
cp "$SRPMS"/bcloud-"$version"-"$release".fc20.src.rpm "$DEST"/build_rpm
