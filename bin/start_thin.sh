#!/bin/sh

thin start -d
ps aux | grep "thin [s]erver"
