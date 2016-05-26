FROM centos:centos7

MAINTAINER Kedrick Cooper

LABEL Description="RUNDECK Image"


ENV RDECK_BASE=/var/lib/rundeck

######## Update and Clean installation  ########

RUN yum -y update 
RUN yum -y clean all

######## Install Java  ########

RUN yum -y install java-1.8.0-openjdk

####### Create a service account ########

RUN useradd -d $RDECK_BASE -m rundeck

######## Add the install commands ########

ADD ./install.sh /
ADD ./run.sh /

######## Download Rundeck ########

ADD http://repo.rundeck.org/latest.rpm /tmp/latest.rpm

######## Run the installation script ########

RUN /install.sh

ENTRYPOINT /run.sh

VOLUME /var/lib/rundeck/data
VOLUME /var/lib/rundeck/var
VOLUME /var/lib/rundeck/logs
VOLUME /var/rundeck/projects

EXPOSE 4440 4443
