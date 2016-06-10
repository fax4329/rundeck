FROM centos:centos7

MAINTAINER Kedrick Cooper

LABEL Description="RUNDECK Image"

#ENV HOST localhost
#ENV HOST1 192.168.99.100
ENV SERVER_URL http://localhost:4440
#ENV URL1 http://192.168.99.100:4440
#ENV PORT 4440
#ENV MYSQL_HOST localhost
#ENV MYSQL_DATABASE rundeck
#ENV MYSQL_USER rundeck
#ENV MYSQL_PASSWORD Ru^d3ck123$
#ENV OLDLDAP jaas-loginmodule.conf
#ENV NEWLDAP jaas-ldap.conf

######## Install rundeck and required packages ########

RUN rpm -Uvh http://repo.rundeck.org/latest.rpm 

######## Install Java and Rundeck  ########

RUN yum -y install java-1.8.0-openjdk rundeck 

######## Install MYSQL database  ########

#RUN yum -y install wget && \
#wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm  && \
#rpm -i mysql-community-release-el7-5.noarch.rpm && \
#yum -y install mysql-server 

######## Update and Clean installation  ########

RUN yum -y update && \
yum -y clean all

######## Set Rundeck Environment Variables #########

#RUN  sed -i '/framework.server.url/d' /etc/rundeck/framework.properties && \
#     echo "framework.server.url = ${URL1}" >> /etc/rundeck/framework.properties

#RUN  sed -i "s/${HOST}/${HOST1}/g" /etc/rundeck/framework.properties

#RUN  sed -i "s/${HOST}/${HOST1}/g" /etc/rundeck/rundeck-config.properties

#RUN echo "Preparing RUNDECK on ${URL}" && \
#    sed -i '/dataSource.url/d' /etc/rundeck/rundeck-config.properties && \
#    echo "dataSource.url = jdbc:mysql://${MYSQL_HOST}/${MYSQL_DATABASE}?autoReconnect=true" >> /etc/rundeck/rundeck-config.properties && \
#    echo "dataSource.username=${MYSQL_USER}" >> /etc/rundeck/rundeck-config.properties && \
#    echo "dataSource.password=${MYSQL_PASSWORD}" >> /etc/rundeck/rundeck-config.properties && \
#    sed -i '/grails.serverURL/d' /etc/rundeck/rundeck-config.properties && \
#    echo "grails.serverURL=${URL}" >> /etc/rundeck/rundeck-config.properties && \
#    sed -i '/framework.server.hostname/d' /etc/rundeck/framework.properties && \
#    echo "framework.server.hostname = ${HOST}" >> /etc/rundeck/framework.properties && \
#    sed -i '/framework.server.port/d' /etc/rundeck/framework.properties && \
#    echo "framework.server.port = ${PORT}" >> /etc/rundeck/framework.properties && \
#    sed -i '/framework.server.url/d' /etc/rundeck/framework.properties && \
#    echo "framework.server.url = ${URL}" >> /etc/rundeck/framework.properties && \
#    sed -i '/framework.ssh.timeout/d' /etc/rundeck/framework.properties && \
#    echo "framework.ssh.timeout = 10000" >> /etc/rundeck/framework.properties && \
#    echo "rundeck.projectsStorageType=db" >> /etc/rundeck/rundeck-config.properties && \
#    echo "rundeck.config.storage.converter.1.type=jasypt-encryption" >> /etc/rundeck/rundeck-config.properties && \
#    echo "rundeck.config.storage.converter.1.path=projects" >> /etc/rundeck/rundeck-config.properties && \
#    echo "rundeck.config.storage.converter.1.config.password=${MYSQL_PASSWORD}" >> /etc/rundeck/rundeck-config.properties && \
#    echo "rundeck.storage.provider.1.type=db" >> /etc/rundeck/rundeck-config.properties && \
#    echo "rundeck.storage.provider.1.path=keys" >> /etc/rundeck/rundeck-config.properties && \
#    echo "rundeck.storage.converter.1.type=jasypt-encryption" >> /etc/rundeck/rundeck-config.properties && \
#    echo "rundeck.storage.converter.1.path=keys" >> /etc/rundeck/rundeck-config.properties && \
#    echo "rundeck.storage.converter.1.config.password=${MYSQL_PASSWORD}" >> /etc/rundeck/rundeck-config.properties && \
#    sed -i 's/${OLDLDAP}/${NEWLDAP}/g' /etc/rundeck/profile


########  Setup the Jaas-Ldap.conf file  ########

#RUN touch /etc/rundeck/jaas-ldap.conf
#RUN chown rundeck:rundeck /etc/rundeck/jaas-ldap.conf

#RUN echo "multiauth {" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "   " >> /etc/rundeck/jaas-ldap.conf && \
#    echo "com.dtolabs.rundeck.jetty.jaas.JettyCachingLdapLoginModule sufficient" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  debug=\"true\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  contextFactory=\"com.sun.jndi.ldap.LdapCtxFactory\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  providerUrl=\"ldap://ldap.dal05.softlayer.local ldap://ldap.dal01.softlayer.local\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  bindDn=\"CN=unix_is_server_auth,OU=LdapAuthAccounts,OU=ServiceAccounts,OU=Groups,OU=Accounts,DC=softlayer,DC=local\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  bindPassword=\"Y\(vuSBOkER8V=qR7\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  authenticationMethod=\"simple\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  forceBindingLogin=\"true\"" >> /etc/rundeck/jaas-ldap.conf && \ 
#    echo "  userBaseDn=\"DC=SOFTLAYER,DC=LOCAL\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  userRdnAttribute=\"sAMAccountName\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  userIdAttribute=\"sAMAccountName\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  userPasswordAttribute=\"unicodePwd\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  userObjectClass=\"user\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  roleBaseDn=\"OU=Groups,OU=Accounts,DC=SOFTLAYER,DC=LOCAL\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  roleNameAttribute=\"cn\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  roleMemberAttribute=\"member\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  roleObjectClass=\"group\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  cacheDurationMillis=\"300000\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  supplementalRoles=\"users\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  reportStatistics=\"true\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  nestedGroups=\"true\";" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "org.eclipse.jetty.plus.jaas.spi.PropertyFileLoginModule sufficient" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  debug=\"true\"" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "  file=\"/etc/rundeck/realm.properties\";" >> /etc/rundeck/jaas-ldap.conf && \
#    echo "};" >> /etc/rundeck/jaas-ldap.conf

######## Change user and ownersheip and permissions ########

RUN mkdir -p /tmp/rundeck
RUN chown -R rundeck:rundeck /tmp/rundeck
RUN chown -R rundeck:rundeck /etc/rundeck 
RUN chown -R rundeck:rundeck /var/rundeck 
RUN chown -R rundeck:rundeck /var/lib/rundeck 
RUN chown -R rundeck:rundeck /var/log/rundeck

RUN chmod a=rwx /var/log/rundeck
RUN chmod a=rwx /tmp/rundeck
RUN chmod -R a=rwx /var/rundeck
RUN chmod -R a=rwx /etc/rundeck
RUN chmod -R a=rwx /var/lib/rundeck
RUN chmod -R u=rwx /etc/init.d/rundeckd

########   Run Rundeck  ########

USER rundeck

CMD source /etc/rundeck/profile && ${JAVA_HOME:-/usr}/bin/java ${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck ${RDECK_HTTP_PORT}

EXPOSE 4440
