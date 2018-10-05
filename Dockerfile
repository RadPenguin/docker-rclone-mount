FROM radpenguin/rclone:latest

ARG BUILD_DATE
ENV VERSION 1.0.0
LABEL build_version="RadPenguin version:- ${VERSION} Build-date:- ${BUILD_DATE}"

ENV CONFIG_OPTS="--config /config/rclone.conf"
ENV MOUNT_PATH="/media"
ENV RCLONE_OPTS="--allow-other --allow-non-empty"
ENV REMOTE_NAME="media:"
ENV TZ="America/Edmonton"

RUN \
 echo "**** configure fuse ****" && \
 sed -ri 's/^#user_allow_other/user_allow_other/' /etc/fuse.conf

ADD start.sh /start.sh

VOLUME ["/config"]
VOLUME ["/media"]

ENTRYPOINT ["/bin/sh"]

CMD ["/start.sh"]
