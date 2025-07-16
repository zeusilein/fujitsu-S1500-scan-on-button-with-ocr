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
        util-linux

WORKDIR /app
RUN git clone https://github.com/rocketraman/sane-scan-pdf.git --depth 1
RUN mkdir /scans

#Add the scanner VID:PID
RUN echo "usb 0x04c5 0x11a2" >> /etc/sane.d/fujitsu.conf
RUN echo "usb 0x04c5 0x11a2" >> /etc/scanbd/fujitsu.conf

COPY scanbd.conf /etc/scanbd/scanbd.conf
COPY scan.sh /etc/scanbd/scripts/scan.sh

VOLUME /scans

CMD scanbd -d1 -f
