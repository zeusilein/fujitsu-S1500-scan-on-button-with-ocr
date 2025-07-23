#!/bin/sh
now=`date +"%Y-%m-%d-%H%M%S"`
/app/sane-scan-pdf/scan -d -r $SCAN_RESOLUTION -v --mode "$SCAN_MODE" --crop --ocr --skip-empty-pages -o /scans/scan-$now.pdf
