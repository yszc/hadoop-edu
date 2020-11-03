FROM centos:7

RUN yum install -y wget java-1.8.0-openjdk*

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.262.b10-0.el7_8.x86_64 
ENV PATH=$JAVA_HOME/bin:$PATH

RUN cd /root && \
    wget https://mirror.bit.edu.cn/apache/hadoop/common/hadoop-3.1.4/hadoop-3.1.4.tar.gz && \
    tar -zxvf hadoop-3.1.4.tar.gz -C /usr/local/ && \
    rm hadoop-3.1.4.tar.gz && \
    mv /usr/local/hadoop-3.1.4 /usr/local/hadoop

ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$HADOOP_HOME/bin:$PATH

RUN yum install -y openssh-server openssh-clients && \
    ssh-keygen  -t rsa  -f /root/.ssh/id_rsa -P '' -N '' && \
    ssh-keygen -A && \
    echo /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

ADD run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]