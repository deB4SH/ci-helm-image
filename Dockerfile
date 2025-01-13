FROM debian:bookworm-slim
LABEL org.opencontainers.image.authors="github@b4sh.de"
#install required packages
RUN apt update \
    && apt install -y curl wget unzip gpg git nodejs apt-transport-https
# install helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
RUN apt-get update && apt-get install -y helm
# install helm push plugin
RUN helm plugin install https://github.com/chartmuseum/helm-push
# install cosign
RUN wget -O cosign "https://github.com/sigstore/cosign/releases/download/v2.0.0/cosign-linux-${TARGETARCH}" \
    && mv cosign /usr/local/bin/cosign \
    && chmod +x /usr/local/bin/cosign

#clean up leftovers
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*
