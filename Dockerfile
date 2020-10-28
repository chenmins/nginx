FROM chenmins/nginx:dev
LABEL maintainer Chenmin
RUN useradd  www -u 1200 -M -s /sbin/nologin
RUN mkdir -p /var/log/nginx
ADD sregex-master.zip .
ADD replace-filter-nginx-module.tar.gz .
RUN tar -zxvf replace-filter-nginx-module.tar.gz
ADD nginx-1.14.2.tar.gz .
RUN tar -zxvf nginx-1.14.2.tar.gz
WORKDIR nginx-1.14.2