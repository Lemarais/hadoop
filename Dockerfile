FROM ubuntu:bionic

COPY hadoop-2.7.7 /hadoop-2.7.7

RUN apt-get update && \
    apt-get install -y ssh openssh-client openssh-server \
                       curl openjdk-8-jdk

# install java
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin

# create ssh key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# change ssh port to avoid conflict
ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

#Hadoop Related Options
ENV HADOOP_HOME=/hadoop-2.7.7
ENV HADOOP_INSTALL=$HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin

RUN cd /hadoop-2.7.7/bin/ && \
    ./hdfs namenode -format
