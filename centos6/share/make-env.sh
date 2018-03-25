#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0);pwd)
BASE_NAME=supervisor
PARENT_DIR=/opt
TARGET_DIR=/opt/$BASE_NAME
VENV_DIR=$TARGET_DIR/python/venv
ARCH_NAME=/share/$BASE_NAME-centos6-$(date +%Y%m%d).tar.gz

# パッケージインストール
yum -y install epel-release
yum -y install python-virtualenv

# python仮想環境作成
[[ -d $VENV_DIR ]] && rm -rf $VENV_DIR
virtualenv -p /usr/bin/python2.6 $VENV_DIR
. $VENV_DIR/bin/activate
pip install supervisor

# 起動ファイル
mkdir -p $TARGET_DIR/etc/init.d
curl -ksSL https://raw.githubusercontent.com/Supervisor/initscripts/master/redhat-init-equeffelec -o $TARGET_DIR/etc/init.d/supervisord
chmod a+x $TARGET_DIR/etc/init.d/supervisord

# 設定ファイル
mkdir -p $TARGET_DIR/etc/supervisord.d
SUPERVISORD_CONF=$TARGET_DIR/etc/supervisord.conf
$VENV_DIR/bin/echo_supervisord_conf > $SUPERVISORD_CONF
sed -i -e 's|logfile=/tmp/supervisord\.log|logfile=/var/log/supervisor/supervisord.log|g' $SUPERVISORD_CONF
sed -i -e 's|pidfile=/tmp/supervisord\.pid|pidfile=/var/run/supervisord.pid|g' $SUPERVISORD_CONF
sed -i -e 's|;\[include\]|[include]|g' $SUPERVISORD_CONF
sed -i -e 's|;files = relative/directory/\*\.ini|files = supervisord.d/*.ini|g' $SUPERVISORD_CONF

# アーカイブ作成
tar czf $ARCH_NAME -C $PARENT_DIR $BASE_NAME
chmod a+w ${ARCH_NAME}
