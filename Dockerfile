FROM chenmins/nginx:dev
LABEL maintainer Chenmin
RUN useradd  www -u 1200 -M -s /sbin/nologin
RUN mkdir -p /var/log/nginx && mkdir /nginx
ADD sregex-master.zip /nginx/
ADD replace-filter-nginx-module.tar.gz /nginx/
ADD nginx-1.14.2.tar.gz /nginx/
#RUN tar -zxvf /nginx/replace-filter-nginx-module.tar.gz
#RUN tar -zxvf /nginx/nginx-1.14.2.tar.gz
#WORKDIR /nginx/nginx-1.14.2