FROM centos:7.2.1511
RUN yum install -y cmake pcre pcre-devel openssl openssl-devel gd-devel \
    zlib-devel gcc gcc-c++ net-tools iproute telnet wget curl &&\
    yum clean all && \
    rm -rf /var/cache/yum/*