#!/bin/sh
now=`date +"%Y-%m-%d-%H%M%S"`
/app/sane-scan-pdf/scan -d -r 200 -v --mode 'Gray' --duplex --crop --ocr --skip-empty-pages -o /scans/scan-$now.pdf
