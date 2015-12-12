#!/bin/bash
clear
#write out current crontab
export PATH=/home/sim/.rbenv/shims:/home/sim/.rbenv/plugins/ruby-build/bin:/home/sim/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
cd /home/sim/Workspace/cafira
rake deadline_alerts:send_alert_emails
