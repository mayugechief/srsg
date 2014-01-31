#!/bin/sh

DIR="`pwd`"
$DIR/bin/stop_thin.sh

thin start -d
ps aux | grep "thin [s]erver"
