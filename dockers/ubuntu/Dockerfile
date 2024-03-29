FROM ubuntu:20.04
LABEL rendu <419610242@qq.com>

# 换源
RUN cd /etc/apt \
    cp /etc/apt/sources.list /etc/apt/sources.list.bak 

# COPY sources.list.tuna /etc/apt/sources.list
RUN sed -i 's@/archive.ubuntu.com/@/mirrors.tuna.tsinghua.edu.cn/@g' /etc/apt/sources.list && \
    sed -i 's@/security.ubuntu.com/@/mirrors.tuna.tsinghua.edu.cn/@g' /etc/apt/sources.list && \
    sed -i 's@/ports.ubuntu.com/@/mirrors.tuna.tsinghua.edu.cn/@g' /etc/apt/sources.list 

# 更新
RUN apt clean 
RUN apt update 
RUN apt -y upgrade

# 网络
RUN apt-get install -y net-tools
RUN apt-get install -y iputils-ping
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# 通用工具
RUN apt-get install -y vim
RUN apt-get install -y git

# zsh
RUN apt-get install -y zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh
RUN echo $SHELL

# 安装 zsh-syntax-highlighting 插件
RUN apt install autojump
# 安装 zsh-syntax-highlighting 插件
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# 安装 zsh-autosuggestions 插件
RUN git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN sed -ri 's/^plugins=.*/plugins=(git autojump zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

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

CMD [ "rd_ubuntu" ]

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]

