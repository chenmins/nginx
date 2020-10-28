FROM chenmins/nginx:dev
LABEL maintainer Chenmin
RUN useradd  www -u 1200 -M -s /sbin/nologin
RUN mkdir -p /var/log/nginx && mkdir /nginx
ADD replace-filter-nginx-module.tar.gz /nginx/
ADD nginx-1.14.2.tar.gz /nginx/
RUN unzip /nginxsregex-master.zip -d /nginx/ && \
    cd /nginx/sregex-master && make && make install && \
    cd ../ && ln -sv /usr/local/lib/libsregex.so.0.0.1 /lib64/libsregex.so.0
WORKDIR /nginx/nginx-1.14.2
RUN ./configure --prefix=/usr/local/nginx --with-http_image_filter_module --user=www --group=www \
    --with-http_ssl_module --with-http_v2_module --with-http_stub_status_module \
    --add-module=/nginx/replace-filter-nginx-module \
    --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx/nginx.pid
RUN make -j 4 && make install && \
    rm -rf /usr/local/nginx/html/*  && \
    echo "Chenmin hello" >/usr/local/nginx/html/index.html  && \
    rm -rf nginx* && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
RUN chown -R www.www /var/log/nginx
ENV LOG_DIR /var/log/nginx
ENV PATH $PATH:/usr/local/nginx/sbin
#COPY nginx.conf /usr/local/nginx/conf/nginx.conf
EXPOSE 80
WORKDIR /usr/local/nginx
CMD ["nginx","-g","daemon off;"]