FROM ubuntu:16.04
USER root


#使用国内apt-get源
RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial main restricted universe multiverse\n" > /etc/apt/sources.list\
 && echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-security main restricted universe multiverse\n" >> /etc/apt/sources.list\
 && echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse\n" >> /etc/apt/sources.list\
 && echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse\n" >> /etc/apt/sources.list\
 && echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse\n" >> /etc/apt/sources.list\
 && apt-get update\
 && apt-get install -y apt-transport-https python-software-properties software-properties-common curl wget x11vnc xvfb jwm zenity cabextract\
 && curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -\
 && echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_6.x/ xenial main\n" >> /etc/apt/sources.list.d/nodesource.list\
 && apt-get update\
 && apt-get install -y nodejs\
 && apt-get install -y --no-install-recommends language-pack-zh-hans fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-cyrillic xfonts-scalable ttf-wqy-microhei\
 && /usr/share/locales/install-language-pack zh_CN \
 && ln /etc/fonts/conf.d/65-wqy-microhei.conf /etc/fonts/conf.d/69-language-selector-zh-cn.conf\
 && dpkg --add-architecture i386\
 && curl --silent https://dl.winehq.org/wine-builds/Release.key | apt-key add -\
 && apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/\
 && apt-get update\
 && apt-get install -y winehq-devel\
 && apt-get autoclean \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/*

COPY noVNC /usr/lib/noVNC
WORKDIR /usr/lib/noVNC/websockify
RUN npm install --registry http://npmreg.mirrors.ustc.edu.cn

ENV TZ "PRC"
RUN echo "Asia/Shanghai" > /etc/timezone \
 && dpkg-reconfigure -f noninteractive tzdata
ENV LANGUAGE zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
RUN dpkg-reconfigure -f noninteractive locales

COPY entrypoint.sh /opt/bin/entrypoint.sh
RUN chmod +x /opt/bin/entrypoint.sh

VOLUME /data

EXPOSE 5900
EXPOSE 80

ENTRYPOINT ["/opt/bin/entrypoint.sh"]