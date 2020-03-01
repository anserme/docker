FROM httpd:alpine
MAINTAINER Punkmer<admin@dreamback.cc>	

 ENV GOAL=google_and_zhwikipedia \	
    FUNC=youtube                \	
    DOMAIN=dreamback.cc	

 RUN apk --no-cache add gcc g++ git python3 python3-dev libc-dev                            && \	
    pip3 install --upgrade --no-cache-dir pip                                              && \	
    pip3 install --no-cache-dir gunicorn gevent requests flask cchardet fastcache lru-dict && \	
    git clone https://github.com/anserme/zmirror /app --depth 1                            && \	
    apk del --purge gcc g++ git libc-dev && rm -rf /src /app/.git	

 WORKDIR /app	
EXPOSE  8001	

 CMD cp more_configs/config_${GOAL}.py config.py           && \	
    cp more_configs/custom_func_${FUNC}.py custom_func.py && \	
    sed -i "/my_host_name/d" config.py                    && \	
    echo "my_host_name = '${DOMAIN}'" >> config.py        && \
    echo "verbose_level = 2" >> config.py        && \
    gunicorn --bind 0.0.0.0:8001 --workers 8 --worker-connections 1000 wsgi:application
