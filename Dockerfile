FROM debian:bookworm-slim

RUN apt-get update && apt-get upgrade -y && \
    apt install -y \
        bc \
        ghostscript \
        git \
        imagemagick \
        netpbm \
        poppler-utils \
        sane \
        sane-utils \
        scanbd \
        time \
        units \
        tesseract-ocr \
        tesseract-ocr-osd \
        tesseract-ocr-eng \
        tesseract-ocr-deu \
        tesseract-ocr-fra \
        tesseract-ocr-ita \
        tesseract-ocr-spa \
        util-linux

WORKDIR /app
RUN git clone https://github.com/rocketraman/sane-scan-pdf.git --depth 1
RUN mkdir /scans

#Add the scanner VID:PID
RUN echo "usb 0x04c5 0x11a2" >> /etc/sane.d/fujitsu.conf
RUN echo "usb 0x04c5 0x11a2" >> /etc/scanbd/fujitsu.conf

RUN echo '# global settings\n\
global {\n\
        debug       = true\n\
        debug-level = 2\n\
        user        = root\n\
        group       = root\n\
        saned       = "/usr/sbin/saned"\n\
        saned_opt   = {} # string-list\n\
        saned_env   = { "SANE_CONFIG_DIR=/etc/scanbd" } # list of environment vars for saned\n\
        scriptdir   = /etc/scanbd/scripts\n\
        timeout     = 500\n\
        pidfile     = "/var/run/scanbd.pid"\n\
\n\
        # env-vars for the scripts\n\
        environment {\n\
                # pass the device label as below in this env-var\n\
                device = "SCANBD_DEVICE"\n\
                # pass the action label as below in this env-var\n\
                action = "SCANBD_ACTION"\n\
        }\n\
\n\
        action scan {\n\
                filter = "^scan.*"\n\
                numerical-trigger {\n\
                        from-value = 1\n\
                        to-value   = 0\n\
                }\n\
                desc   = "Scan to file"\n\
                script = "scan.sh"\n\
        }\n\
\n\
}\n'\
> /etc/scanbd/scanbd.conf

RUN mkdir /etc/scanbd/scripts
RUN touch /etc/scanbd/scripts/scan.sh
RUN echo '#!/bin/sh\n\
 now=`date +"%Y-%m-%d-%H%M%S"`\n\
 /app/sane-scan-pdf/scan -d -r $SCAN_RESOLUTION -v --mode "$SCAN_MODE" --crop --ocr --skip-empty-pages -o /scans/scan-$now.pdf\n\
 /usr/bin/gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=/scans/scan-${now}-ebook.pdf /scans/scan-${now}.pdf\n'\
 > /etc/scanbd/scripts/scan.sh

VOLUME /scans

CMD scanbd -d1 -f
