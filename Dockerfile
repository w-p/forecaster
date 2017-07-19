FROM ubuntu:zesty

MAINTAINER Will Palmer <will@steelhive.com>

ADD ./requirements.txt /srv/
RUN apt-get -y -qq update && \
    apt-get -y -qq install \
        runit \
        nginx \
        python-pip \
        virtualenv && \
    sysctl -w net.ipv6.conf.lo.disable_ipv6=1 && \
    sysctl -w net.ipv6.conf.all.disable_ipv6=1 && \
    sysctl -w net.ipv6.conf.default.disable_ipv6=1 && \
    virtualenv -p python3 /srv/venv && \
    . /srv/venv/bin/activate && \
    pip install -r /srv/requirements.txt && \
    deactivate

ADD ./app /srv/app/
ADD ./nginx.conf /srv/
ADD ./runit /etc/service/
ADD ./entrypoint.sh /usr/bin/
ADD ./frontend/dist /srv/frontend/

EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
