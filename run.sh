#!/bin/bash

docker run --rm --name squid --hostname squid --tty --privileged \
  --volume /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --tmpfs /run \
  --tmpfs /run/lock \
  --tmpfs /tmp \
  -e "container=docker" \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  --cgroupns=host \
  $@ rpavlyuk/squid
