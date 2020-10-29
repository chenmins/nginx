FROM chenmins/nginx:dev
LABEL maintainer Chenmin
RUN useradd  www -u 1200 -M -s /sbin/nologin && mkdir -p /var/log/nginx && mkdir /nginx
ADD replace-filter-nginx-module.tar.gz /nginx/
ADD nginx-1.14.2.tar.gz /nginx/
ADD sregex-master.zip /nginx/
ADD ngx_http_substitutions_filter_module-master.zip /nginx/
RUN unzip /nginx/sregex-master.zip -d /nginx/ && \
	unzip /nginx/ngx_http_substitutions_filter_module-master.zip -d /nginx/ && \
    cd /nginx/sregex-master && make && make install && \
    cd ../ && ln -sv /usr/local/lib/libsregex.so.0.0.1 /lib64/libsregex.so.0
WORKDIR /nginx/nginx-1.14.2
RUN ./configure --prefix=/usr/local/nginx --user=www --group=www --pid-path=/var/run/nginx/nginx.pid \
    --modules-path=/usr/lib64/nginx/modules --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio \
    --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module \
    --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module \
    --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module \
    --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail \
    --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' \
    --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie' \
    --add-module=/nginx/replace-filter-nginx-module \
    --add-module=/nginx/ngx_http_substitutions_filter_module-master
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
EXPOSE 80
WORKDIR /usr/local/nginx
CMD ["nginx","-g","daemon off;"]