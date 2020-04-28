FROM alpine:3.11
LABEL maintainer="rverst <robert@verst.eu>"
LABEL repository="https://github.com/rverst/pdfmerge"

ENV PUID=1000
ENV PGID=1000

ENV WAIT_TIMEOUT=300
ENV ROTATE_ODD=0
ENV ROTATE_EVEN=1
ENV REVERSE_EVEN=1

RUN  apk update && apk add --no-cache bash incron su-exec inotify-tools qpdf

ADD ./pdfmerge.sh /opt/pdfmerge.sh
ADD ./entrypoint.sh /opt/entrypoint.sh

RUN chmod a+rx /opt/*.sh && \
    echo "lockfile_dir = /tmp" >> /etc/incron.conf && \
    addgroup -g "$PGID" app && adduser -u "$PUID" -D -G app app

USER app

RUN cd /home/app && \
    incrontab -l > mycron && echo '/input IN_CREATE /opt/pdfmerge.sh $#' >> mycron && \
    incrontab mycron && \
    rm mycron

USER root

VOLUME ["/input", "/output"]

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["/usr/sbin/incrond", "-n"]
