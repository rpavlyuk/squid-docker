# squid-docker
SQUID Caching Proxy in Docker container under Fedora Linux. Has all necessary permission fixes in place to enable `pam_auth`

## Running the container
Sample `docker run` command:
```
docker run --rm --name squid --hostname squid --tty --privileged \
  --volume /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --tmpfs /run \
  --tmpfs /run/lock \
  --tmpfs /tmp \
  --tmpfs /var/log/squid:noexec,size=64m,mode=1777 \
  --tmpfs /var/spool/squid:noexec,size=128m,mode=1777 \
  -e "container=docker" \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  --cgroupns=host \
  --volume /etc/squid/squid.conf:/etc/squid/squid.conf:ro \
  -p 3128:3128 \
  -p 3129:3129 \
  rpavlyuk/squid:latest
```
