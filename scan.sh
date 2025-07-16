#!/bin/sh
now=`date +"%Y-%m-%d-%H%M%S"`
/app/sane-scan-pdf/scan -d -r 300 -v --mode 'Color' --crop -o /scans/scan-$now.pdf
