FROM centos:7

RUN yum install -y wget && \
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
    yum clean all && \
    yum install -y java-1.8.0-openjdk* 

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.262.b10-0.el7_8.x86_64 

RUN cd /root && \
    wget https://mirror.bit.edu.cn/apache/hadoop/common/hadoop-3.1.4/hadoop-3.1.4.tar.gz && \
    tar -zxvf hadoop-3.1.4.tar.gz -C /usr/local/ && \
    rm hadoop-3.1.4.tar.gz

RUN cd /usr/local/hadoop-3.1.4/etc/hadoop && \
    echo -e "\nHDFS_NAMENODE_USER=root \nHDFS_DATANODE_USER=root \nHDFS_SECONDARYNAMENODE_USER=root \nYARN_RESOURCEMANAGER_USER=root \nYARN_NODEMANAGER_USER=root " >> hadoop-env.sh

ENV HADOOP_HOME=/usr/local/hadoop-3.1.4




