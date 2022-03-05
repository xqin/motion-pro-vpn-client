FROM centos:7.9.2009

RUN set -xe \
    &&  sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-Base.repo \
    && yum update -y \
    && yum -y install epel-release \
    && yum install -y sysvinit-tools iproute openssh-clients \
    && yum clean all

ADD source /installer/MotionPro
RUN chmod +x /installer/MotionPro/MotionPro_Linux_CentOS_x64_v1.2.13.sh \
  && /installer/MotionPro/MotionPro_Linux_CentOS_x64_v1.2.13.sh \
  && rm -rf /installer/

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
  && echo -e "Host *\nStrictHostKeyChecking no\nUserKnownHostsFile=/dev/null\nAddressFamily inet" >> /etc/ssh/ssh_config

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["/bin/bash"]
