FROM httpd:alpine
MAINTAINER Punkmer<admin@dreamback.cc>	

 ENV GOAL=google_and_zhwikipedia \	
    FUNC=youtube                \	
    DOMAIN=dreamback.cc	

 RUN apk --no-cache add gcc g++ git python3 python3-dev libc-dev                            && \	
    pip3 install --upgrade --no-cache-dir pip                                              && \	
    pip3 install --no-cache-dir gunicorn gevent requests flask cchardet fastcache lru-dict && \	
    git clone https://github.com/anserme/zmirror /app --depth 1                            && \	
    wget https://gist.githubusercontent.com/aploium/8cd86ebf07c275367dd62762cc4e815a/raw/29a6c7531c59590c307f503b186493e559c7d790/h5.conf   && \
    apk del --purge gcc g++ git libc-dev && rm -rf /src /app/.git	

 WORKDIR /app	
EXPOSE  80	

 CMD  sed -i 's/要被取代的字串/${DOMAIN}/g'      apache.conf   && \
    cp h5.conf  /etc/apache2/conf-enabled                && \
    cp more_configs/config_${GOAL}.py config.py           && \	
    cp more_configs/custom_func_${FUNC}.py custom_func.py && \	
    sed -i "/my_host_name/d" config.py                    && \	
    echo "my_host_name = '${DOMAIN}'" >> config.py        && \
    echo "verbose_level = 2" >> config.py                 && \
    gunicorn --bind 0.0.0.0:80 --workers 8 --worker-connections 1000 wsgi:application
