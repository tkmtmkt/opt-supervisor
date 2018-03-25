#!/bin/bash
ln -sf {/opt/supervisor,}/etc/supervisord.d
ln -sf {/opt/supervisor,}/etc/init.d/supervisord
ln -sf {/opt/supervisor,}/etc/supervisord.conf
ln -sf {/opt/supervisor/python/venv,/usr}/bin/supervisorctl
ln -sf {/opt/supervisor/python/venv,/usr}/bin/supervisord

chkconfig --add supervisord

mkdir -p /var/log/supervisor
