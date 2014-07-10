#!/bin/bash --login

cd /home/wallem-vsl/Documents/TPS_QA/

rm -rf tmp/pids/thin.pid

rvm use 1.9.3

echo IP is `hostname -I` > processes_id.txt

bundle exec thin start -d -p 4000 > logthin.txt

sleep 10

