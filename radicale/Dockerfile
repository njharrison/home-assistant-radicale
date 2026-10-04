ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache python3 py3-pip apache2-utils curl openssl socat \
    && python3 -m pip install --no-cache-dir --break-system-packages "Radicale==3.5.9" "bcrypt>=4.0" \
    && curl -fsSL https://get.acme.sh | sh -s email=radicale@localhost

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
