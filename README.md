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
**NOTE**: It is recommended to map `/var/log/squid` and `/var/spool/squid` to `tmpfs` (as show in the example above) to avoid excessive load on SDCard if you're running this container on RaspberryPI or similar setup. But keep in mind --in this case logs are not persisted.

View `squid.service` log (startup troubleshoting):
```
docker exec -ti squid journalctl -u squid
```

View SQUID application:
```
docker exec -ti squid less /var/log/squid/cache.log
```

View SQUID access log:
```
docker exec -ti squid less /var/log/squid/access.log
```
