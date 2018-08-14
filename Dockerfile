FROM centos:centos7
MAINTAINER DXkite dxkite(at)qq.com

RUN yum install -y wget git unzip net-tools

RUN mkdir /suda-app
WORKDIR /suda-app

RUN wget -O /suda-app/xampp-installer.run "https://www.apachefriends.org/xampp-files/7.2.8/xampp-linux-x64-7.2.8-0-installer.run"
RUN chmod +x xampp-installer.run
RUN bash -c ./xampp-installer.run
RUN ln -sf /opt/lampp/lampp /usr/bin/lampp

RUN git clone https://github.com/DXkite/suda ./suda-git

COPY ./entry-point.sh ./entry-point.sh
RUN chmod +x ./entry-point.sh

COPY ./upgrade.sh ./upgrade.sh
RUN chmod +x ./upgrade.sh

RUN mkdir -p ./public
RUN mkdir -p ./runtime-data
RUN mkdir -p ./app

VOLUME ["/suda-app/app"]
VOLUME ["/suda-app/public"]
VOLUME ["/suda-app/runtime-data"]
ENTRYPOINT [ "./entry-point.sh" ]

EXPOSE 80
