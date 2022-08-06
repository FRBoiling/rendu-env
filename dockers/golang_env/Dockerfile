FROM golang:latest
LABEL rendu <419610242@qq.com>

ENV GOPROXY https://goproxy.cn,direct

# 换源
RUN cd /etc/apt \
    cp /etc/apt/sources.list /etc/apt/sources.list.bak 

RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \  
    sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    sed -i 's/security-cdn.debian.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list 

# 更新
RUN apt clean 
RUN apt update 
RUN apt -y upgrade

# RUN apt-get install -y --no-install-recommends \

# 通用工具
RUN apt-get install -y vim
RUN apt-get install -y git
RUN apt-get install -y curl
RUN apt-get install -y zip
RUN apt-get install -y unzip

# 网络
RUN apt-get install -y net-tools
RUN apt-get install -y iputils-ping
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# golang 需要 rsync 同步数据
RUN apt-get install -y rsync
RUN sed -ri 's/RSYNC_ENABLE=false/RSYNC_ENABLE=true/g' /etc/default/rsync
RUN mkdir /root/sync
COPY rsync.conf /etc

# 删除 apt update 产生的缓存文件
# 因为 docker 的文件系统是层文件系统，上一个层中缓存有apt-get update的结果，
# 那么下次 Dockerfile 运行时就会直接使用之前的缓存，
# 这样 docker 中的 apt 软件源就不是最新的软件列表了，将会带来缓存过期的问题。
# 并且这些缓存将占用不少空间，导致最终生成的image非常庞大，
# 而这些垃圾文件是我们最终的image中无需使用到的东西，我们应当在Docker构建过程中予以删除。
RUN apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 修改 root 的密码为 root
RUN echo 'root:root' |chpasswd

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
CMD [ "rd_go_env" ]
ENTRYPOINT [ "docker-entrypoint.sh" ]

