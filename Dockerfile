FROM centos:centos7

MAINTAINER Kedrick Cooper

LABEL Description="RUNDECK Image"

ENV HOST localhost
ENV SERVER_URL http://rundeck-rundeck-test.apps.192.0.2.201.xip.io/
ENV PORT 4440
#ENV MYSQL_HOST localhost
#ENV MYSQL_DATABASE rundeck
#ENV MYSQL_USER rundeck
#ENV MYSQL_PASSWORD Ru^d3ck123$
#ENV OLDLDAP jaas-loginmodule.conf
#ENV NEWLDAP jaas-ldap.conf

######## Install rundeck and required packages ########

USER root

RUN rpm -Uvh http://repo.rundeck.org/latest.rpm

######## Install Java and Rundeck  ########

RUN yum -y install java-1.8.0-openjdk rundeck

######## Update and Clean installation  ########

RUN yum -y update && \
yum -y clean all

######## Set Rundeck Environment Variables #########

#    sed -i 's/${OLDLDAP}/${NEWLDAP}/g' /etc/rundeck/profile



######## Change user and ownersheip and permissions ########

RUN cp RDconfig /etc/rundeck
RUN mkdir -p /tmp/rundeck
RUN chown -R rundeck:rundeck /tmp/rundeck
RUN chown -R rundeck:rundeck /etc/rundeck
RUN chown -R rundeck:rundeck /etc/rundeck/RDconfig
RUN chown -R rundeck:rundeck /var/rundeck
RUN chown -R rundeck:rundeck /var/lib/rundeck
RUN chown -R rundeck:rundeck /var/log/rundeck

RUN chmod u=rwx /etc/rundecl/RDconfig
RUN chmod a=rwx /var/log/rundeck
RUN chmod a=rwx /tmp/rundeck
RUN chmod -R a=rwx /var/rundeck
RUN chmod -R a=rwx /etc/rundeck
RUN chmod -R a=rwx /var/lib/rundeck
RUN chmod -R u=rwx /etc/init.d/rundeckd

########   Run Rundeck  ########

EXPOSE 4440

USER rundeck

CMD ["/etc/rundeck/RDconfig"]
