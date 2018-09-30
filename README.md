# docker-rclone-mount

Mount an [rclone](http://rclone.org) folder that is sharable to other containers.

ENV CONFIG_OPTS="--config /config/rclone.conf"
ENV MOUNT_PATH="/media"
ENV RCLONE_OPTS="--allow-other --allow-non-empty"
ENV REMOTE_NAME="media:"
ENV TZ="America/Edmonton"

## Usage
```
docker create \
  --name=rclone \
  --env CONFIG_OPTS="--config /config/rclone.conf" \
  --env MOUNT_PATH="/media" \
  --env RCLONE_OPTS="--allow-other --allow-non-empty" \
  --env REMOTE_NAME="media:" \
  --env TZ="America/Edmonton" \
  --privileged \
  --volume $( pwd )/config:/config \
  --volume $( pwd )/media:/media \
  radpenguin/rclone-mount
```

## Parameters
The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
```
--env CONFIG_OPTS - The rclone config options
--env MOUNT_PATH - the rclone media mount path. Defaults to /media
--env RCLONE_OPTS - the rclone options
--env TZ - the timezone to use for the cron and log. Defaults to `America/Edmonton`
--volume /config - config file and for rclone
--volume /media - the rclone mount
```

It is based on alpine linux. For shell access while the container is running, `docker exec -it rclone-mount /bin/bash`.

See [rclone docs](https://rclone.org/commands/) for syntax and additional options.
