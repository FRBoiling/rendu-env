#基础镜像
FROM centos:7

RUN yum -y update

#安装 gcc7.3
RUN yum -y install centos-release-scl \
&& yum -y install devtoolset-7-gcc devtoolset-7-gcc-c++ devtoolset-7-binutils \
&& yum -y install devtoolset-7-gdb make \
&& yum -y install libatomic
RUN echo "source /opt/rh/devtoolset-7/enable" >> ~/.bashrc

#安装基本的网络调试工具，和tmxu,git
RUN yum -y install wget \
&& yum -y install net-tools nc telnet \
&& yum -y install tmux \
&& yum -y install vim

#时区设置
ENV TZ Asia/Shanghai
RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

#安装git
RUN  yum install -y \
https://repo.ius.io/ius-release-el7.rpm \
https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
&& yum install git -y

#更改shell为zsh,安装on-my-zsh
RUN yum -y install zsh \
&& git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
&& cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
&& chsh -s /bin/zsh
RUN sed -i 's/robbyrussell/crunch/g' /root/.zshrc
RUN echo "source /opt/rh/devtoolset-7/enable" >> ~/.zshrc

#安装on-my-zsh插件
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
&& git clone https://github.com/zsh-users/zsh-autosuggestions \
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
&& sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' /root/.zshrc

#开启ssh服务
RUN yum -y install passwd openssh-server openssl-devel
#设置root用户密码为root
RUN /bin/echo "root" | passwd --stdin root
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key \
&& ssh-keygen -t rsa -f /etc/ssh/ssh_host_ecdsa_key \
&& ssh-keygen -t rsa -f /etc/ssh/ssh_host_ed25519_key

#安装cmake 
WORKDIR /root
RUN wget https://github.com/Kitware/CMake/releases/download/v3.19.8/cmake-3.19.8-Linux-x86_64.tar.gz
RUN tar -xzvf cmake-3.19.8-Linux-x86_64.tar.gz
RUN rm -rf cmake-3.19.8-Linux-x86_64.tar.gz
RUN ln -s /root/cmake-3.19.8-Linux-x86_64/bin/cmake /usr/bin/cmake \
&& ln -s /root/cmake-3.19.8-Linux-x86_64/bin/ccmake /usr/bin/ccmake \
&& ln -s /root/cmake-3.19.8-Linux-x86_64/bin/cmake-gui /usr/bin/cmake-gui \
&& ln -s /root/cmake-3.19.8-Linux-x86_64/bin/cpack /usr/bin/cpack \
&& ln -s /root/cmake-3.19.8-Linux-x86_64/bin/ctest /usr/bin/ctest

#启动 ssh 服务
CMD ["/usr/sbin/sshd","-D"]
