#!/bin/sh

# fail fast
set -e -u

# Configure the timezone
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Configure rclone
if [[ $( rclone $CONFIG_OPTS config show | grep "empty config" | wc -l ) != "0" ]]; then
  echo "$( date +'%Y/%m/%d %H:%M:%S' ) Configuring rclone"
  rclone $CONFIG_OPTS config
fi

mkdir -p $MOUNT_PATH || true

echo "$( date +'%Y/%m/%d %H:%M:%S' ) Mounting $REMOTE_NAME at $MOUNT_PATH"

function term_handler {
  echo "$( date +'%Y/%m/%d %H:%M:%S' ) Sending SIGTERM to child pid"
  kill -SIGTERM ${!}      #kill last spawned background process $(pidof rclone)
  fuse_unmount
  echo "exiting container now"
  exit $?
}

function cache_handler {
  echo "$( date +'%Y/%m/%d %H:%M:%S' ) Sending SIGHUP to child pid"
  kill -SIGHUP ${!}
}

function fuse_unmount {
  echo "$( date +'%Y/%m/%d %H:%M:%S' ) Unmounting $MOUNT_PATH"
  fusermount -uz $MOUNT_PATH
}

# Add traps, SIGHUP is for cache clearing
trap term_handler SIGINT SIGTERM
trap cache_handler SIGHUP

# Mount and wait
echo "$( date ) /usr/bin/rclone $CONFIG_OPTS mount $RCLONE_OPTS $REMOTE_NAME $MOUNT_PATH"
/usr/bin/rclone $CONFIG_OPTS mount $RCLONE_OPTS "$REMOTE_NAME" "$MOUNT_PATH" & wait ${!}
echo "$( date +'%Y/%m/%d %H:%M:%S' ) rclone crashed"
fuse_unmount

exit $?
