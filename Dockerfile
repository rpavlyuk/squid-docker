FROM fedora:latest

# Refresh container
RUN dnf update -y
RUN dnf install -y ca-certificates tzdata less vim
RUN /usr/bin/update-ca-trust

ENV container=docker

# Enable systemd.
RUN dnf -y install systemd && dnf clean all && \
  (cd /lib/systemd/system/sysinit.target.wants/ ; for i in * ; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i ; done) ; \
  rm -f /lib/systemd/system/multi-user.target.wants/* ;\
  rm -f /etc/systemd/system/*.wants/* ;\
  rm -f /lib/systemd/system/local-fs.target.wants/* ; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
  rm -f /lib/systemd/system/basic.target.wants/* ;\
  rm -f /lib/systemd/system/anaconda.target.wants/*

# Install Squid
RUN dnf install squid -y

# Enable Squid on boot
RUN systemctl enable squid.service

# Fix PAM authentication issues
RUN setcap 'cap_setuid+ep' /usr/lib64/squid/basic_pam_auth
RUN getcap /usr/lib64/squid/basic_pam_auth

# Expose Cache Ports
EXPOSE 3128/tcp
EXPOSE 3129/tcp

# Volumes
VOLUME ["/var/spool/squid"]

# Run the binary
VOLUME ["/sys/fs/cgroup"]
CMD ["/sbin/init"]
