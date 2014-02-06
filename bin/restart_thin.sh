#!/bin/sh

pkill -KILL -f "thin server"

thin start -d
ps aux | grep "thin [s]erver"
