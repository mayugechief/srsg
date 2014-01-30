#!/bin/sh

DIR="`pwd`"
$DIR/bin/clear_log.sh

pkill -KILL -f "thin server"
