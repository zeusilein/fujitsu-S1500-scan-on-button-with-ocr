#!/bin/sh
now=`date +"%Y-%m-%d-%H%M%S"`
/app/sane-scan-pdf/scan -d -r $SCAN_RESOLUTION -v --mode "$SCAN_MODE" --crop --ocr --skip-empty-pages -o /scans/scan-$now.pdf
/usr/bin/gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=/scans/scan-${now}-ebook.pdf /scans/scan-${now}.pdf
