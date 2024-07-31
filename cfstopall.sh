#!/bin/bash

for app in $(cf apps | tail -n +4 | awk '{print $1}') ;
do
cf stop $app
done
