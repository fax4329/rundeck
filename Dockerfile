FROM centos:centos7

MAINTAINER Kedrick Cooper

LABEL Description="RUNDECK Image"

USER root

######## Install rundeck and required packages ########

RUN yum -y update

RUN rpm -Uvh http://repo.rundeck.org/latest.rpm 

######## Install Java and Rundeck  ########

RUN yum -y install java-1.8.0-openjdk 
RUN yum -y install rundeck 

######## Update and Clean installation  ########

RUN yum -y clean all

########   Run Rundeck  ########

#CMD source /etc/rundeck/profile && ${JAVA_HOME:-/usr}/bin/java ${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck ${RDECK_HTTP_PORT}

VOLUME ["/etc/rundeck", "/var/rundeck", "/var/lib/rundeck", "/var/log/rundeck"]

EXPOSE 4440

CMD ["/bin/bash"] 
