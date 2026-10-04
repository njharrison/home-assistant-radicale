ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache python3 py3-pip apache2-utils \
    && python3 -m pip install --no-cache-dir --break-system-packages "Radicale==3.5.9" "bcrypt>=4.0"

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
