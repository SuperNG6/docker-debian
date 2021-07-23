FROM lsiobase/alpine:3.13 as builder
# set label
LABEL maintainer="NG6"
WORKDIR /downloads
COPY install.sh  /downloads
# download bilibili-helper
RUN set -ex \
	&& chmod +x install.sh \
	&& bash install.sh

FROM debian:buster-slim
# set label
LABEL maintainer="NG6"

# copy files
COPY root/ /
COPY --from=builder /downloads/s6-overlay/  /
# create abc user
RUN apt -y update && apt -y install tzdata wget \
&&  useradd -u 1000 -U -d /config -s /bin/false abc \
&&  usermod -G users abc  \
&&  echo "**** cleanup ****" \
&&  apt-get clean \
&&  rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*


ENTRYPOINT [ "/init" ]
