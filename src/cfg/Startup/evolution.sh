#!/bin/bash
sleep 10 && (LANG=en_US.utf8; evolution &) && sleep 5 && kdocker -q -x $(ps -A|grep evolution$|awk {'print $1;'})
